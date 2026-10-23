import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';
import 'package:t3afy/admin/campaigns/domain/repos/campaigns_repo.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaigns_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_stats_usecase.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'campaigns_state.dart';

class CampaignsCubit extends Cubit<CampaignsState> with SafeEmit<CampaignsState> {
  // The stats usecase and repo are still injected by DI but no longer needed:
  // every count is derived from the resolved-status list (one source of truth).
  CampaignsCubit(this._getCampaigns, GetCampaignStatsUsecase _, CampaignsRepo _)
    : super(const CampaignsInitial()) {
    load();
    _hub
      ..watch(
        name: 'campaigns-tasks',
        table: 'tasks',
        onChange: _realtimeRefresh,
      )
      ..watch(
        name: 'campaigns-assignments',
        table: 'task_assignments',
        onChange: _realtimeRefresh,
      );
  }

  /// Realtime / app resume: always past the Hive cache, never a loading state.
  void _realtimeRefresh() => load(skipCache: true);

  final GetCampaignsUsecase _getCampaigns;
  final RealtimeHub _hub = RealtimeHub(
    debounce: const Duration(milliseconds: 400),
  );

  String _filter = 'all';
  List<CampaignEntity> _allCampaigns = [];
  int _seq = 0;

  List<CampaignEntity> get filteredCampaigns =>
      _allCampaigns.where((c) => c.matches(_filter)).toList();

  void _emitLoaded() => safeEmit(
    CampaignsLoaded(
      filteredCampaigns,
      _filter,
      CampaignEntity.countByFilter(_allCampaigns),
    ),
  );

  /// Loads the list. Only the very first load shows the loading state; later
  /// loads keep the data on screen. Returns an error message, or null.
  Future<String?> load({bool skipCache = false}) async {
    final seq = ++_seq;
    final hasData = state is CampaignsLoaded;
    if (!hasData) safeEmit(const CampaignsLoading());
    final result = await _getCampaigns(skipCache: skipCache);
    // A newer load started meanwhile (realtime burst, return from detail):
    // let that one emit so an older response can't overwrite newer data.
    if (seq != _seq) return null;
    return result.fold(
      (f) {
        if (!hasData) safeEmit(CampaignsError(f.message));
        return f.message;
      },
      (campaigns) {
        _allCampaigns = campaigns;
        _emitLoaded();
        return null;
      },
    );
  }

  /// Pull-to-refresh: always bypasses the cache.
  Future<String?> refresh() => load(skipCache: true);

  void setFilter(String filter) {
    _filter = filter;
    if (state is CampaignsLoaded) _emitLoaded();
  }

  @override
  Future<void> close() async {
    await _hub.dispose();
    return super.close();
  }
}
