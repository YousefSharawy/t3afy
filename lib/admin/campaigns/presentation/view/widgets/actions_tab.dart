import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'action_card.dart';
import 'campaign_report_sheet.dart';
import 'send_alert_sheet.dart';

class ActionsTab extends StatelessWidget {
  const ActionsTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CampaignDetailCubit>();
    final gap = SizedBox(height: Space.vm);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.vl,
        Space.gutter,
        Space.vxl + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        ActionCard(
          icon: AppIcons.notification,
          title: 'إرسال تنبيه للفريق',
          subtitle: 'إشعار لجميع المتطوعين المعيّنين',
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: SendAlertSheet(detail: detail),
            ),
          ),
        ),
        gap,
        ActionCard(
          icon: AppIcons.reports,
          title: 'عرض التقرير',
          subtitle: 'ملخص أرقام هذه الحملة',
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => CampaignReportSheet(detail: detail),
          ),
        ),
        gap,
        ActionCard(
          icon: AppIcons.edit,
          title: 'تعديل الحملة',
          subtitle: 'تعديل معلومات وبيانات الحملة',
          onTap: () async {
            final changed = await context.push<bool>(
              '/editCampaign/${detail.id}',
            );
            if (changed == true) {
              cubit.load(detail.id, invalidateListCache: true);
            }
          },
        ),
        gap,
        ActionCard(
          icon: AppIcons.pause,
          title: 'إيقاف الحملة مؤقتاً',
          subtitle: 'تغيير حالة الحملة إلى موقوفة',
          color: ColorManager.warning,
          onTap: () async {
            HapticFeedback.mediumImpact();
            final confirmed = await showConfirmDialog(
              context,
              title: 'إيقاف الحملة',
              body: 'هل تريد إيقاف هذه الحملة مؤقتاً؟',
              confirmLabel: 'إيقاف',
            );
            if (confirmed) cubit.pauseCampaign(detail.id);
          },
        ),
        SizedBox(height: Space.vxl),
        BlocSelector<CampaignDetailCubit, CampaignDetailState, bool>(
          selector: (s) => s is CampaignDetailSaving,
          builder: (context, saving) => PrimaryElevatedButton(
            title: 'حذف الحملة',
            // The shared spinner is white; on the light error fill it needs the error color.
            titleWidget: saving
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      color: ColorManager.error,
                      strokeWidth: 2.4,
                    ),
                  )
                : null,
            backGroundColor: ColorManager.errorLight,
            textStyle: getSemiBoldStyle(
              fontSize: FontSize.s15,
              color: ColorManager.error,
            ),
            onPress: () async {
              if (saving) return;
              HapticFeedback.mediumImpact();
              final confirmed = await showConfirmDialog(
                context,
                title: 'حذف الحملة',
                body:
                    'هذا الإجراء لا يمكن التراجع عنه. هل تريد حذف الحملة نهائياً؟',
                confirmLabel: 'حذف',
                isDestructive: true,
              );
              if (confirmed) cubit.deleteCampaign(detail.id);
            },
          ),
        ),
      ],
    );
  }
}
