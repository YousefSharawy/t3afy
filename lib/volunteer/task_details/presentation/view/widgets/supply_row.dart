import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_supply_entity.dart';

class SupplyRow extends StatelessWidget {
  const SupplyRow({super.key, required this.supply});

  final TaskSupplyEntity supply;

  static const _iconMap = <String, String>{
    'كتيبات': IconAssets.books,
    'كتيبات توعوية': IconAssets.books,
    'بروشورات': IconAssets.books,
    'مطبوعات': IconAssets.books,
    'بنرات': IconAssets.flag,
    'بنرات ترويجية': IconAssets.flag,
    'لافتات': IconAssets.flag,
    'هدايا': IconAssets.gift,
    'هدايا تحفيزية': IconAssets.laptop,
  };

  static const _defaultIcon = IconAssets.details;

  @override
  Widget build(BuildContext context) {
    final icon = _resolveIcon(supply.name);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
          child: Row(
            children: [
              Container(
                width: AppWidth.s36,
                height: AppHeight.s36,
                decoration: BoxDecoration(
                  color: ColorManager.primary50,
                  border: Border.all(
                    color: ColorManager.primary600,
                    width: 0.5.sp,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                ),
                child: Center(
                  child: Image.asset(
                    icon,
                    width: AppWidth.s20,
                    height: AppHeight.s20,
                  ),
                ),
              ),
              SizedBox(width: AppWidth.s10),
              Expanded(
                child: Text(
                  supply.name,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.natural400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s6,
                  vertical: AppHeight.s1,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.primary50,
                  borderRadius: BorderRadius.circular(AppRadius.s5),
                  border: Border.all(
                    color: ColorManager.primary600,
                    width: 0.5.sp,
                  ),
                ),
                child: Text(
                  '${supply.quantity} ${_unit(supply.name)}',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: ColorManager.primary700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: ColorManager.natural200, height: AppHeight.s1),
      ],
    );
  }

  String _resolveIcon(String name) {
    for (final entry in _iconMap.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }
    return _defaultIcon;
  }

  String _unit(String name) {
    if (name.contains('كتيب') ||
        name.contains('بروشور') ||
        name.contains('مطبوع')) {
      return 'نسخة';
    }
    if (name.contains('بنر') || name.contains('لافتة')) {
      return 'قطعة';
    }
    if (name.contains('هدي') || name.contains('هدايا')) {
      return 'هدية';
    }
    if (name.contains('ملصق')) {
      return 'ملصق';
    }
    if (name.contains('جهاز')) {
      return 'جهاز';
    }
    return 'قطعة';
  }
}
