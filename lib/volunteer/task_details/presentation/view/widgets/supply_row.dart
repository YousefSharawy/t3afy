import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_supply_entity.dart';

class _SupplyStyle {
  final IconData icon;
  final Color color;

  const _SupplyStyle(this.icon, this.color);
}

class SupplyRow extends StatelessWidget {
  const SupplyRow({super.key, required this.supply});

  final TaskSupplyEntity supply;

  static const _iconMap = <String, _SupplyStyle>{
    'كتيبات': _SupplyStyle(Icons.menu_book_rounded, Color(0xFF4CAF50)),
    'كتيبات توعوية': _SupplyStyle(Icons.menu_book_rounded, Color(0xFF4CAF50)),
    'بروشورات': _SupplyStyle(Icons.menu_book_rounded, Color(0xFF4CAF50)),
    'مطبوعات': _SupplyStyle(Icons.menu_book_rounded, Color(0xFF4CAF50)),
    'بنرات': _SupplyStyle(Icons.flag_rounded, Color(0xFF2196F3)),
    'بنرات ترويجية': _SupplyStyle(Icons.flag_rounded, Color(0xFF2196F3)),
    'لافتات': _SupplyStyle(Icons.flag_rounded, Color(0xFF2196F3)),
    'هدايا': _SupplyStyle(Icons.card_giftcard_rounded, Color(0xFFE91E63)),
    'هدايا تحفيزية': _SupplyStyle(Icons.card_giftcard_rounded, Color(0xFFE91E63)),
  };

  static const _default =
      _SupplyStyle(Icons.inventory_2_rounded, ColorManager.cyanPrimary);

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(supply.name);

    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s16),
      child: Row(
        children: [
          // LEFT (start in RTL) — checkmark circle
          Container(
            width: 32.r,
            height: 32.r,
            decoration: const BoxDecoration(
              color: ColorManager.cyanPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 20.r),
          ),
          SizedBox(width: AppWidth.s10),

          // Quantity badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s12,
              vertical: AppHeight.s5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A5C),
              borderRadius: BorderRadius.circular(AppRadius.s8),
              border: Border.all(
                color: const Color(0xFF2A5080),
              ),
            ),
            child: Text(
              '${supply.quantity} ${_unit(supply.name)}',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: Colors.white,
              ),
            ),
          ),

          const Spacer(),

          // Supply name
          Text(
            supply.name,
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s15,
              color: Colors.white,
            ),
          ),
          SizedBox(width: AppWidth.s12),

          // RIGHT (end in RTL) — large icon box
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Icon(style.icon, color: style.color, size: 28.r),
          ),
        ],
      ),
    );
  }

  _SupplyStyle _resolveStyle(String name) {
    for (final entry in _iconMap.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }
    return _default;
  }

  String _unit(String name) {
    if (name.contains('كتيب') || name.contains('بروشور') || name.contains('مطبوع')) {
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
