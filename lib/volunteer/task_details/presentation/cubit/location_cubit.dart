import 'dart:async';
import 'dart:math';

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

  Timer? _locationTimer;
  Timer? _gpsPingTimer;
  DateTime? _checkedInAt;

  /// Call on screen init — restores state and starts tracking.
  Future<void> init() async {
    emit(LocationLoading());

    // 1. Restore existing check-in state from DB
    final userId = LocalAppStorage.getUserId() ?? '';
    try {
      final status = await dataSource.getCheckInStatus(taskId, userId);
      if (status != null) {
        final checkedOutStr = status['checked_out_at'] as String?;
        final checkedInStr = status['checked_in_at'] as String?;

        if (checkedOutStr != null) {
          final checkedInAt = DateTime.parse(checkedInStr!);
          final checkedOutAt = DateTime.parse(checkedOutStr);
          final verifiedHours =
              ((status['verified_hours'] as num?) ?? 0).toDouble();
          emit(LocationCheckedOut(checkedInAt, checkedOutAt, verifiedHours));
          return;
        }

        if (checkedInStr != null) {
          _checkedInAt = DateTime.parse(checkedInStr);
          final lat =
              ((status['check_in_lat'] as num?) ?? taskLat).toDouble();
          final lng =
              ((status['check_in_lng'] as num?) ?? taskLng).toDouble();
          emit(LocationCheckedIn(_checkedInAt!, lat, lng));
          _startGpsPings();
          _startLocationPolling();
          return;
        }
      }
    } catch (_) {
      // Ignore DB errors — fall through to GPS check
    }

    // 2. Check permission and start tracking
    await _startLocationPolling();
  }

  Future<void> _startLocationPolling() async {
    final hasPermission = await _ensurePermission();
    if (!hasPermission) return;

    await _updateLocation();
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateLocation();
    });
  }

  Future<bool> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      emit(LocationPermissionDenied());
      return false;
    }
    return true;
  }

  Future<void> _updateLocation() async {
    if (state is LocationCheckedIn || state is LocationCheckedOut) return;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final dist = haversineDistance(
          pos.latitude, pos.longitude, taskLat, taskLng);
      if (dist <= _checkInRadiusMeters) {
        emit(LocationNearTask(dist, pos.latitude, pos.longitude));
      } else {
        emit(LocationFarFromTask(dist, pos.latitude, pos.longitude));
      }
    } catch (_) {
      // Silently ignore GPS errors during periodic polling
    }
  }

  Future<void> checkIn() async {
    final hasPermission = await _ensurePermission();
    if (!hasPermission) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final dist = haversineDistance(
          pos.latitude, pos.longitude, taskLat, taskLng);
      if (dist > _checkInRadiusMeters) {
        emit(LocationFarFromTask(dist, pos.latitude, pos.longitude));
        return;
      }

      final userId = LocalAppStorage.getUserId() ?? '';
      await dataSource.checkIn(taskId, userId, pos.latitude, pos.longitude);
      _checkedInAt = DateTime.now();
      emit(LocationCheckedIn(_checkedInAt!, pos.latitude, pos.longitude));
      _locationTimer?.cancel();
      _startGpsPings();
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> checkOut() async {
    final hasPermission = await _ensurePermission();
    if (!hasPermission) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final checkedInAt = _checkedInAt ?? DateTime.now();
      final now = DateTime.now();
      final verifiedHours =
          (now.difference(checkedInAt).inMinutes / 60.0 * 10).round() / 10.0;

      final userId = LocalAppStorage.getUserId() ?? '';
      await dataSource.checkOut(
          taskId, userId, pos.latitude, pos.longitude, verifiedHours);

      _gpsPingTimer?.cancel();
      emit(LocationCheckedOut(checkedInAt, now, verifiedHours));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void _startGpsPings() {
    _gpsPingTimer?.cancel();
    _gpsPingTimer =
        Timer.periodic(const Duration(minutes: 2), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        );
        final userId = LocalAppStorage.getUserId() ?? '';
        await dataSource.recordLocation(
            taskId, userId, pos.latitude, pos.longitude);
      } catch (_) {}
    });
  }

  /// Haversine formula — returns distance in metres.
  static double haversineDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  @override
  Future<void> close() {
    _locationTimer?.cancel();
    _gpsPingTimer?.cancel();
    return super.close();
  }
}
