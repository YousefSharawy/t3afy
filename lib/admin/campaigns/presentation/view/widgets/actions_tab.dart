import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'campaign_report_sheet.dart';
import 'send_alert_sheet.dart';

class ActionsTab extends StatelessWidget {
  const ActionsTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CampaignDetailCubit>();

    return ListView(
      padding: EdgeInsets.all(AppSize.s16),
      children: [
        _ActionCard(
          icon: Icons.notifications_active_outlined,
          iconBg: const Color(0xFF0EA5E9),
          title: 'ارسال تنبيه للفريق',
          subtitle: 'إرسال إشعار لجميع المتطوعين المعيّنين',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: SendAlertSheet(detail: detail),
              ),
            );
          },
        ),
        SizedBox(height: AppHeight.s12),
        _ActionCard(
          icon: Icons.bar_chart_outlined,
          iconBg: const Color(0xFF8B5CF6),
          title: 'عرض التقارير',
          subtitle: 'الاطلاع على تقارير هذه الحملة',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: CampaignReportSheet(detail: detail),
              ),
            );
          },
        ),
        SizedBox(height: AppHeight.s12),
        _ActionCard(
          icon: Icons.edit_outlined,
          iconBg: const Color(0xFF10B981),
          title: 'تعديل تفاصيل الحملة',
          subtitle: 'تعديل معلومات وبيانات الحملة',
          onTap: () => context.push('/editCampaign/${detail.id}'),
        ),
        SizedBox(height: AppHeight.s12),
        _ActionCard(
          icon: Icons.pause_circle_outline,
          iconBg: const Color(0xFFF59E0B),
          title: 'ايقاف الحملة مؤقتاً',
          subtitle: 'تغيير حالة الحملة إلى موقوفة',
          onTap: () async {
            final confirmed = await _confirmDialog(
              context,
              title: 'ايقاف الحملة',
              body: 'هل تريد إيقاف هذه الحملة مؤقتاً؟',
              confirmLabel: 'إيقاف',
              confirmColor: const Color(0xFFF59E0B),
            );
            if (confirmed && context.mounted) {
              cubit.pauseCampaign(detail.id);
            }
          },
        ),
        SizedBox(height: AppHeight.s12),
        _ActionCard(
          icon: Icons.delete_outline,
          iconBg: Colors.redAccent,
          title: 'حذف الحملة',
          subtitle: 'حذف الحملة وجميع بياناتها نهائياً',
          titleColor: Colors.redAccent,
          onTap: () async {
            final confirmed = await _confirmDialog(
              context,
              title: 'حذف الحملة',
              body: 'هذا الإجراء لا يمكن التراجع عنه. هل تريد حذف الحملة نهائياً؟',
              confirmLabel: 'حذف',
              confirmColor: Colors.redAccent,
            );
            if (confirmed && context.mounted) {
              final deleted = await cubit.deleteCampaign(detail.id);
              if (deleted && context.mounted) {
                context.go('/campaigns');
              }
            }
          },
        ),
        SizedBox(height: AppHeight.s80),
      ],
    );
  }

  Future<bool> _confirmDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorManager.blueOne800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        title: Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: Colors.white,
          ),
          textDirection: TextDirection.rtl,
        ),
        content: Text(
          body,
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white70,
          ),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'إلغاء',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white54,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmLabel,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: confirmColor,
              ),
            ),
          ),
        ],
      ),
    );
    return result == true;
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSize.s16),
        decoration: BoxDecoration(
          color: ColorManager.blueOne800,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(
            color: titleColor != null
                ? titleColor!.withValues(alpha: 0.3)
                : ColorManager.blueOne700,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: iconBg.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Icon(icon, color: iconBg, size: 22.r),
            ),
            SizedBox(width: AppWidth.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: titleColor ?? Colors.white,
                    ),
                  ),
                  SizedBox(height: AppHeight.s3),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: Colors.white.withValues(alpha: 0.3),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
