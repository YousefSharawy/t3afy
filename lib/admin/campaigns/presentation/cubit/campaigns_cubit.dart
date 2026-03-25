import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';
import 'package:t3afy/admin/campaigns/domain/repos/campaigns_repo.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaigns_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_stats_usecase.dart';

part 'campaigns_state.dart';

class CampaignsCubit extends Cubit<CampaignsState> {
  CampaignsCubit(this._getCampaigns, this._getStats, this._repo)
      : super(const CampaignsInitial()) {
    load();
    _repo.subscribeRealtime(load);
  }

  final GetCampaignsUsecase _getCampaigns;
  final GetCampaignStatsUsecase _getStats;
  final CampaignsRepo _repo;

  String _filter = 'all';
  List<CampaignEntity> _allCampaigns = [];

  List<CampaignEntity> get filteredCampaigns {
    if (_filter == 'all') return _allCampaigns;
    if (_filter == 'active') {
      return _allCampaigns
          .where((c) => c.status == 'active' || c.status == 'ongoing')
          .toList();
    }
    if (_filter == 'done') {
      return _allCampaigns
          .where((c) => c.status == 'done' || c.status == 'completed')
          .toList();
    }
    return _allCampaigns.where((c) => c.status == _filter).toList();
  }

  Future<void> load() async {
    emit(const CampaignsLoading());
    final campaignsResult = await _getCampaigns();
    final statsResult = await _getStats();

    campaignsResult.fold(
      (f) => emit(CampaignsError(f.message)),
      (campaigns) {
        _allCampaigns = campaigns;
        statsResult.fold(
          (_) => emit(CampaignsLoaded(filteredCampaigns, _filter, const {})),
          (stats) => emit(CampaignsLoaded(filteredCampaigns, _filter, stats)),
        );
      },
    );
  }

  void setFilter(String filter) {
    _filter = filter;
    if (state is CampaignsLoaded) {
      final stats = (state as CampaignsLoaded).stats;
      emit(CampaignsLoaded(filteredCampaigns, _filter, stats));
    }
  }

  @override
  Future<void> close() {
    _repo.disposeRealtime();
    return super.close();
  }
}
