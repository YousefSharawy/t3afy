import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_supply_entity.dart';

class SupplyRow extends StatelessWidget {
  const SupplyRow({super.key, required this.supply});

  final TaskSupplyEntity supply;

  static const _iconMap = <String, IconData>{
    'كتيبات': AppIcons.books,
    'كتيبات توعوية': AppIcons.books,
    'بروشورات': AppIcons.books,
    'مطبوعات': AppIcons.books,
    'بنرات': AppIcons.flag,
    'بنرات ترويجية': AppIcons.flag,
    'لافتات': AppIcons.flag,
    'هدايا': AppIcons.gift,
    'هدايا تحفيزية': AppIcons.laptop,
  };

  static const _defaultIcon = AppIcons.requirements;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.vm),
      child: Row(
        children: [
          AppIconBadge(icon: _resolveIcon(supply.name)),
          SizedBox(width: Space.m),
          Expanded(child: Text(supply.name, style: AppText.bodyStrong())),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Space.s + 2,
              vertical: Space.vxs,
            ),
            decoration: BoxDecoration(
              color: ColorManager.brandSoft,
              borderRadius: BorderRadius.circular(Radii.chip),
            ),
            child: Text(
              '${supply.quantity} ${_unit(supply.name)}',
              style: getNumericStyle(
                fontSize: 12,
                color: ColorManager.brandStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(String name) {
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
