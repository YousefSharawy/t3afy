import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_member_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_objective_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_supply_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/auth/domain/entity/user_entity.dart';

UserEntity fakeUserEntity({
  String id = 'user-1',
  String email = 'test@test.com',
  String name = 'يوسف',
  String role = 'admin',
}) => UserEntity(id: id, email: email, name: name, role: role);

VolunteerDetailsEntity fakeVolunteerDetails({
  String id = 'vol-1',
  String name = 'يوسف',
  double rating = 4.0,
  int level = 3,
  String levelTitle = 'متطوع نشيط',
  int totalTasks = 46,
  int totalHours = 128,
  int totalPoints = 500,
  int placesVisited = 5,
  bool isOnline = true,
  String role = 'volunteer',
  List<VolunteerTaskAssignmentEntity>? tasks,
}) => VolunteerDetailsEntity(
  id: id,
  name: name,
  rating: rating,
  level: level,
  levelTitle: levelTitle,
  totalTasks: totalTasks,
  totalHours: totalHours,
  totalPoints: totalPoints,
  placesVisited: placesVisited,
  isOnline: isOnline,
  role: role,
  tasks: tasks ?? const [],
  region: 'القاهرة',
  email: 'vol@test.com',
  phone: '01000000000',
);

AdminVolunteerEntity fakeAdminVolunteer({
  String id = 'vol-1',
  String name = 'يوسف',
  double rating = 4.0,
  int totalHours = 128,
  int totalTasks = 46,
  bool isOnline = true,
  String role = 'volunteer',
}) => AdminVolunteerEntity(
  id: id,
  name: name,
  rating: rating,
  totalHours: totalHours,
  totalTasks: totalTasks,
  isOnline: isOnline,
  role: role,
  region: 'القاهرة',
);

CampaignEntity fakeCampaignEntity({
  String id = 'camp-1',
  String title = 'حملة توعية',
  String type = 'توعية مدرسية',
  String status = 'active',
  String date = '2026-01-01',
  int volunteerCount = 5,
  int targetBeneficiaries = 100,
  int reachedBeneficiaries = 80,
  int points = 50,
}) => CampaignEntity(
  id: id,
  title: title,
  type: type,
  status: status,
  date: date,
  volunteerCount: volunteerCount,
  targetBeneficiaries: targetBeneficiaries,
  reachedBeneficiaries: reachedBeneficiaries,
  points: points,
);

CampaignMemberEntity fakeCampaignMember({
  String id = 'member-1',
  String name = 'أحمد',
  double rating = 3.5,
  bool isOnline = false,
  String role = 'volunteer',
}) => CampaignMemberEntity(
  id: id,
  name: name,
  rating: rating,
  isOnline: isOnline,
  role: role,
);

CampaignDetailEntity fakeCampaignDetail({
  String id = 'camp-1',
  String title = 'حملة توعية',
  String type = 'توعية مدرسية',
  String status = 'active',
  String date = '2026-01-01',
  String? timeStart,
  String? timeEnd,
  int targetBeneficiaries = 100,
  int reachedBeneficiaries = 80,
  int points = 50,
  List<CampaignMemberEntity>? members,
  List<CampaignObjectiveEntity>? objectives,
  List<CampaignSupplyEntity>? supplies,
}) => CampaignDetailEntity(
  id: id,
  title: title,
  type: type,
  status: status,
  date: date,
  timeStart: timeStart,
  timeEnd: timeEnd,
  targetBeneficiaries: targetBeneficiaries,
  reachedBeneficiaries: reachedBeneficiaries,
  points: points,
  members: members ?? const [],
  objectives: objectives ?? const [],
  supplies: supplies ?? const [],
);

VolunteerEntity fakeCampaignVolunteer({
  String id = 'vol-1',
  String name = 'يوسف',
  double rating = 4.0,
}) => VolunteerEntity(id: id, name: name, rating: rating);
