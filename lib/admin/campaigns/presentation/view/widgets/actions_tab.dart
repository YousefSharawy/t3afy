import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'action_card.dart';
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
        ActionCard(
          icon: IconAssets.notification,
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
        ActionCard(
          icon: IconAssets.reports,
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
        ActionCard(
          icon: IconAssets.edit,
          title: 'تعديل تفاصيل الحملة',
          subtitle: 'تعديل معلومات وبيانات الحملة',
          onTap: () => context.push('/editCampaign/${detail.id}'),
        ),
        SizedBox(height: AppHeight.s12),
        ActionCard(
          icon: IconAssets.pause,
          title: 'ايقاف الحملة مؤقتاً',
          subtitle: 'تغيير حالة الحملة إلى موقوفة',
          onTap: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'ايقاف الحملة',
              body: 'هل تريد إيقاف هذه الحملة مؤقتاً؟',
              confirmLabel: 'إيقاف',
              confirmColor: ColorManager.amber500,
            );
            if (confirmed && context.mounted) {
              cubit.pauseCampaign(detail.id);
            }
          },
        ),
        SizedBox(height: AppHeight.s12),
        PrimaryElevatedButton(
          borderColor: ColorManager.darkRed,
          backGroundColor: ColorManager.white,
          title: "حذف الحملة",
          onPress: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'حذف الحملة',
              body:
                  'هذا الإجراء لا يمكن التراجع عنه. هل تريد حذف الحملة نهائياً؟',
              confirmLabel: 'حذف',
              confirmColor: ColorManager.error,
            );
            if (confirmed && context.mounted) {
              cubit.deleteCampaign(detail.id);
            }
          },
          textStyle: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: Colors.red,
            fontSize: FontSize.s14,
          ),
        ),
        SizedBox(height: AppHeight.s80),
      ],
    );
  }

}
