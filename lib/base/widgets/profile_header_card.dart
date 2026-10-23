import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'profile_badge.dart';

/// Profile hero for both roles: avatar, name, contact line, level badges.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.badges = const [],
  });

  final String name;
  final String subtitle;
  final String? avatarUrl;
  final List<ProfileBadge> badges;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;
    final initials = name.trim().isEmpty ? '' : name.trim().characters.first;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.vxl),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [ColorManager.sprout, ColorManager.brand],
              ),
            ),
            child: ClipOval(
              child: Container(
                color: ColorManager.brandSoft,
                alignment: Alignment.center,
                child: hasAvatar
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl!,
                        width: 78,
                        height: 78,
                        memCacheWidth: 240,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => const Icon(
                          AppIcons.person,
                          color: ColorManager.brand,
                          size: 36,
                        ),
                      )
                    : initials.isEmpty
                    ? const Icon(
                        AppIcons.person,
                        color: ColorManager.brand,
                        size: 36,
                      )
                    : Text(
                        initials,
                        style: AppText.headline(color: ColorManager.brand),
                      ),
              ),
            ),
          ),
          SizedBox(height: Space.vm),
          Text(name, style: AppText.headline(), textAlign: TextAlign.center),
          if (subtitle.trim().isNotEmpty) ...[
            SizedBox(height: Space.vxs),
            Text(subtitle, style: AppText.label(), textAlign: TextAlign.center),
          ],
          if (badges.isNotEmpty) ...[
            SizedBox(height: Space.vm),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: Space.s,
              runSpacing: Space.vxs,
              children: badges,
            ),
          ],
        ],
      ),
    );
  }
}
