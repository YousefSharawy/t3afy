import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';

/// Greeting row at the top of the Manager command band (on Deep Root).
class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key, required this.adminName, this.avatarUrl});

  final String adminName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'الملف الشخصي',
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push(Routes.adminProfile),
            child: _Avatar(name: adminName, url: avatarUrl),
          ),
        ),
        SizedBox(width: Space.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'لوحة التحكم',
                style: AppText.caption(color: ColorManager.onInkMuted),
              ),
              Text(
                adminName,
                style: getDisplayStyle(
                  fontSize: FontSize.s18,
                  color: ColorManager.onInk,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // The floating notifications bell sits on this row's end side.
        SizedBox(width: AppNavShell.bellReserve),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.url});

  final String name;
  final String? url;

  static const double _size = 48;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p.characters.first).join();
  }

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials,
        style: getSemiBoldStyle(
          fontSize: FontSize.s16,
          color: ColorManager.onInk,
        ),
      ),
    );
    final u = url;
    if (u == null || u.isEmpty) return fallback;
    final px = (_size * MediaQuery.devicePixelRatioOf(context)).round();
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: u,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        memCacheWidth: px,
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }
}
