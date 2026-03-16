import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({
    super.key,
    required this.adminName,
    this.avatarUrl,
  });

  final String adminName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Row(
        children: [
          SizedBox(height: AppHeight.s71),
          GestureDetector(
            onTap: () => context.push(Routes.adminProfile),
            child: Container(
              width: AppWidth.s34,
              height: AppHeight.s34,
              decoration: BoxDecoration(
                color: ColorManager.blueOne800,
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.s8)),
              ),
              child: Image.asset(
                width: AppWidth.s24,
              height: AppHeight.s24,
                IconAssets.volHome),
            ),
          ),
          SizedBox(width: AppWidth.s8,),
           Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .center,
            children: [
           Text("لوحة تحكم",style: getLightStyle(
            fontSize: FontSize.s10,
            fontFamily: FontConstants.fontFamily,
            color: Color(0xff25374F),
           ),),
           Text(adminName,style: getBoldStyle(
             fontSize: FontSize.s12,
            fontFamily: FontConstants.fontFamily,
            color: Color(0xff25374F),
           ),),
            ],
          ),
        ],
      ),
    );
  }
}
