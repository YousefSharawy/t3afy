import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';

/// Round avatar: network photo (decoded at display size) or initials, with an
/// optional sprout "online" dot on the end-bottom corner.
class VolunteerAvatar extends StatelessWidget {
  const VolunteerAvatar({
    super.key,
    required this.name,
    required this.size,
    this.url,
    this.online = false,
    this.ringColor = ColorManager.surface,
  });

  final String name;
  final String? url;
  final double size;
  final bool online;

  /// Color behind the online dot ring (the card/hero background).
  final Color ringColor;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '؟';
    return parts.take(2).map((p) => p.characters.first).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: ColorManager.brandSoft,
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials,
        style: getDisplayStyle(
          fontSize: size * 0.34,
          color: ColorManager.brandStrong,
        ),
      ),
    );
    final hasUrl = url != null && url!.isNotEmpty;
    final avatar = hasUrl
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              memCacheWidth: (size * 2).round(),
              placeholder: (_, _) => fallback,
              errorWidget: (_, _, _) => fallback,
            ),
          )
        : fallback;

    final dot = size * 0.26;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          if (online)
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: Semantics(
                label: 'متصل الآن',
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(
                    color: ColorManager.sprout,
                    shape: BoxShape.circle,
                    border: Border.all(color: ringColor, width: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
