import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';

class OnlineStatusState {}

class OnlineStatusCubit extends Cubit<OnlineStatusState>
    with WidgetsBindingObserver {
  final SupabaseClient _client;
  Timer? _heartbeat;

  OnlineStatusCubit(this._client) : super(OnlineStatusState()) {
    WidgetsBinding.instance.addObserver(this);
    _setOnline(true);
    _heartbeat = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _setOnline(true),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOnline(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _setOnline(false);
    }
  }

  Future<void> _setOnline(bool isOnline) async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;
    try {
      await _client.from('users').update({
        'is_online': isOnline,
        'last_seen_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', userId);
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _heartbeat?.cancel();
    _setOnline(false);
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
