import 'package:mocktail/mocktail.dart';
import 'package:t3afy/admin/campaigns/domain/repos/campaigns_repo.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';
import 'package:t3afy/auth/domain/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCampaignsRepo extends Mock implements CampaignsRepo {}

class MockVolunteersRepo extends Mock implements VolunteersRepo {}
