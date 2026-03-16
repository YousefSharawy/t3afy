import 'package:t3afy/volunteer/profile/data/model/profile_model.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';

extension ProfileMapper on ProfileModel {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      region: region,
      qualification: qualification,
      level: level,
      levelTitle: levelTitle,
      rating: rating,
      totalHours: totalHours,
      totalTasks: totalTasks,
      placesVisited: placesVisited,
      totalPoints: totalPoints,
      joinedAt: joinedAt,
    );
  }
}