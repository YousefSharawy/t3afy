import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/task_details/data/sources/check_in_data_source.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    required this.taskId,
    required this.taskLat,
    required this.taskLng,
    required this.dataSource,
  }) : super(LocationInitial());

  final String taskId;
  final double taskLat;
  final double taskLng;
  final CheckInDataSource dataSource;

  static const double _checkInRadiusMeters = 200.0;

  StreamSubscription<Position>? _positionStream;
  Timer? _gpsPingTimer;
  DateTime? _checkedInAt;

  /// Call on screen init — restores existing check-in state, then starts GPS.
  Future<void> init() async {
    emit(LocationLoading());

    // 1. Restore existing check-in/out state from DB
    final userId = LocalAppStorage.getUserId() ?? '';
    try {
      final status = await dataSource.getCheckInStatus(taskId, userId);
      if (status != null) {
        final checkedOutStr = status['checked_out_at'] as String?;
        final checkedInStr = status['checked_in_at'] as String?;

        if (checkedOutStr != null) {
          final checkedInAt = DateTime.parse(checkedInStr!);
          final checkedOutAt = DateTime.parse(checkedOutStr);
          final verifiedHours = ((status['verified_hours'] as num?) ?? 0)
              .toDouble();
          emit(LocationCheckedOut(checkedInAt, checkedOutAt, verifiedHours));
          return;
        }

        if (checkedInStr != null) {
          _checkedInAt = DateTime.parse(checkedInStr);
          final lat = ((status['check_in_lat'] as num?) ?? taskLat).toDouble();
          final lng = ((status['check_in_lng'] as num?) ?? taskLng).toDouble();
          emit(LocationCheckedIn(_checkedInAt!, lat, lng));
          _startGpsPings();
          return;
        }
      }
    } catch (_) {
      // DB errors are non-fatal — fall through to GPS
    }

    // 2. Start GPS tracking
    await _initGps();
  }

  /// Checks service + permission, gets initial position, then starts stream.
  Future<void> _initGps() async {
    try {
      // Step 1: location service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationError('خدمة الموقع غير مفعلة. يرجى تفعيلها من الإعدادات'));
        return;
      }

      // Step 2: permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        emit(LocationPermissionDenied());
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        emit(LocationPermissionDenied());
        return;
      }

      // Step 3: get initial position with explicit timeout
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      _emitDistanceState(pos);

      // Step 4: start continuous stream
      _startPositionStream();
    } on TimeoutException {
      if (!isClosed) {
        emit(
          LocationError('تعذر تحديد موقعك. تأكد من تفعيل GPS وحاول مرة أخرى'),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(LocationError('حدث خطأ في تحديد الموقع'));
      }
    }
  }

  void _startPositionStream() {
    _positionStream?.cancel();
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen(
          (pos) {
            if (isClosed) return;
            // Don't override terminal states
            if (state is LocationCheckedIn || state is LocationCheckedOut) {
              return;
            }
            _emitDistanceState(pos);
          },
          onError: (Object e) {
            if (!isClosed &&
                state is! LocationCheckedIn &&
                state is! LocationCheckedOut) {
              emit(LocationError('تعذر تتبع الموقع'));
            }
          },
          cancelOnError: false,
        );
  }

  void _emitDistanceState(Position pos) {
    final dist = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      taskLat,
      taskLng,
    );
    if (dist <= _checkInRadiusMeters) {
      emit(LocationNearTask(dist, pos.latitude, pos.longitude));
    } else {
      emit(LocationFarFromTask(dist, pos.latitude, pos.longitude));
    }
  }

  Future<void> checkIn() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      final dist = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        taskLat,
        taskLng,
      );
      if (dist > _checkInRadiusMeters) {
        emit(LocationFarFromTask(dist, pos.latitude, pos.longitude));
        return;
      }

      final userId = LocalAppStorage.getUserId() ?? '';
      await dataSource.checkIn(taskId, userId, pos.latitude, pos.longitude);
      _checkedInAt = DateTime.now();
      emit(LocationCheckedIn(_checkedInAt!, pos.latitude, pos.longitude));

      // Stop proximity stream — no longer needed while checked in
      _positionStream?.cancel();
      _positionStream = null;
      _startGpsPings();
    } on TimeoutException {
      if (!isClosed) {
        emit(LocationError('تعذر تحديد موقعك. حاول مرة أخرى'));
      }
    } catch (e) {
      if (!isClosed) emit(LocationError(e.toString()));
    }
  }

  Future<void> checkOut() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final checkedInAt = _checkedInAt ?? DateTime.now();
      final now = DateTime.now();
      final verifiedHours =
          (now.difference(checkedInAt).inMinutes / 60.0 * 10).round() / 10.0;

      final userId = LocalAppStorage.getUserId() ?? '';
      await dataSource.checkOut(
        taskId,
        userId,
        pos.latitude,
        pos.longitude,
        verifiedHours,
      );

      _gpsPingTimer?.cancel();
      emit(LocationCheckedOut(checkedInAt, now, verifiedHours));
    } on TimeoutException {
      if (!isClosed) {
        emit(LocationError('تعذر تحديد موقعك. حاول مرة أخرى'));
      }
    } catch (e) {
      if (!isClosed) emit(LocationError(e.toString()));
    }
  }

  /// Retry after an error state.
  Future<void> retry() => init();

  void _startGpsPings() {
    _gpsPingTimer?.cancel();
    _gpsPingTimer = Timer.periodic(const Duration(minutes: 2), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        );
        final userId = LocalAppStorage.getUserId() ?? '';
        await dataSource.recordLocation(
          taskId,
          userId,
          pos.latitude,
          pos.longitude,
        );
      } catch (_) {}
    });
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    _gpsPingTimer?.cancel();
    return super.close();
  }
}
