import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class CampaignStatusChips extends StatelessWidget {
  const CampaignStatusChips({super.key, required this.selectedStatus});

  final String selectedStatus;

  static const _statusColors = {
    'ongoing':   ColorManager.info,
    'upcoming':  ColorManager.warning,
    'done':      ColorManager.success,
    'suspended': ColorManager.error,
  };
  static const _statusLightColors = {
    'ongoing':   ColorManager.infoLight,
    'upcoming':  ColorManager.warningLight,
    'done':      ColorManager.successLight,
    'suspended': ColorManager.errorLight,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: campaignStatuses.map((status) {
        final isSelected = selectedStatus == status;
        final color = _statusColors[status]!;
        final lightColor = _statusLightColors[status]!;
        return GestureDetector(
          onTap: () => context.read<CreateCampaignCubit>().setStatus(status),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(
              left: status == campaignStatuses.last ? 0 : AppWidth.s8,
            ),
            padding: EdgeInsets.symmetric(vertical: AppHeight.s2,horizontal: AppWidth.s10),
            decoration: BoxDecoration(
              color: isSelected ? lightColor : ColorManager.white,
              borderRadius: BorderRadius.circular(AppRadius.s6),
              border: Border.all(
                color: isSelected ? color : ColorManager.natural200,
                width: 0.5.sp,
              ),
            ),
            child: Text(
              campaignStatusLabels[status]!,
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: isSelected ? color : ColorManager.natural400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}
