import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key, required this.adminName, this.avatarUrl});

  final String adminName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push(Routes.adminProfile),
          child: Container(
            width: AppWidth.s44,
            height: AppHeight.s44,
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.s10)),
            ),
            child: Image.asset(IconAssets.volHome),
          ),
        ),
        SizedBox(width: AppWidth.s8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لوحة تحكم',
              style: getLightStyle(
                fontSize: FontSize.s10,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural400,
              ),
            ),
            Text(
              adminName,
              style: getBoldStyle(
                fontSize: FontSize.s12,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
