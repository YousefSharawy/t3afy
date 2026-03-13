import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import '../../../domain/entities/task_details_entity.dart';
import '../../../domain/entities/task_supply_entity.dart';

class TaskSuppliesTab extends StatelessWidget {
  const TaskSuppliesTab({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SuppliesCard(supplies: task.supplies),
        SizedBox(height: AppHeight.s14),
        _SuppliesNoteCard(),
        SizedBox(height: AppHeight.s24),
      ],
    );
  }
}

// ─── Main supplies card ────────────────────────────────────────────────────

class _SuppliesCard extends StatelessWidget {
  const _SuppliesCard({required this.supplies});

  final List<TaskSupplyEntity> supplies;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          Text(
            'المواد و المستلزمات المطلوبة لهذه المهمة',
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppHeight.s20),
          if (supplies.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppHeight.s16),
              child: Text(
                'لا توجد مستلزمات لهذه المهمة',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            )
          else
            ...supplies.map((s) => _SupplyRow(supply: s)),
        ],
      ),
    );
  }
}

class _SupplyRow extends StatelessWidget {
  const _SupplyRow({required this.supply});

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
      _SupplyStyle(Icons.inventory_2_rounded, Color(0xFF00ABD2));

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
              color: Color(0xFF00ABD2),
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
      if (name.contains(entry.key)) { return entry.value; }
    }
    return _default;
  }

  String _unit(String name) {
    if (name.contains('كتيب') || name.contains('بروشور') || name.contains('مطبوع')) {
      return 'نسخة';
    }
    if (name.contains('بنر') || name.contains('لافتة')) { return 'قطعة'; }
    if (name.contains('هدي') || name.contains('هدايا')) { return 'هدية'; }
    if (name.contains('ملصق')) { return 'ملصق'; }
    if (name.contains('جهاز')) { return 'جهاز'; }
    return 'قطعة';
  }
}

// ─── Note card ────────────────────────────────────────────────────────────

class _SuppliesNoteCard extends StatelessWidget {
  const _SuppliesNoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملاحظة المستلزمات',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          Text(
            'جميع المستلزمات ستكون جاهزة عند نقطة التجمع. يرجى التحقق من استلام الكميات المطلوبة قبل بدء المهمة.',
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Style helper ─────────────────────────────────────────────────────────

class _SupplyStyle {
  final IconData icon;
  final Color color;

  const _SupplyStyle(this.icon, this.color);
}
