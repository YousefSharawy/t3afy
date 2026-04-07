import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'gradient_card.dart';
import 'section_header.dart';

class SupervisorSection extends StatelessWidget {
  const SupervisorSection({super.key, required this.name, this.phone});

  final String name;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'المشرف المسؤول'),
          SizedBox(height: AppHeight.s16),
          Row(
            children: [
              Container(
                width: AppWidth.s44,
                height: AppHeight.s42,
                decoration: BoxDecoration(
                  color: ColorManager.infoLight,
                  border: Border.all(color: ColorManager.info, width: 0.5.sp),
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
                child: Center(child: Image.asset(IconAssets.mentor)),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: ColorManager.natural400,
                      ),
                    ),
                    if (phone != null) ...[
                      SizedBox(height: AppHeight.s4),
                      Text(
                        phone!,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.natural300,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _launchSms(phone),
                    child: Container(
                      width: AppWidth.s28,
                      height: AppHeight.s28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                        border: Border.all(
                          color: ColorManager.info,
                          width: 0.5.sp,
                        ),
                        color: ColorManager.infoLight,
                      ),
                      child: Center(
                        child: Image.asset(
                          IconAssets.call,
                          width: AppWidth.s18,
                          height: AppHeight.s18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppWidth.s8),
                  GestureDetector(
                    onTap: () => _launchPhone(phone),
                    child: Container(
                      width: AppWidth.s28,
                      height: AppHeight.s28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                        border: Border.all(
                          color: ColorManager.info,
                          width: 0.5.sp,
                        ),
                        color: ColorManager.infoLight,
                      ),
                      child: Center(
                        child: Image.asset(
                          IconAssets.message,
                          width: AppWidth.s18,
                          height: AppHeight.s18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String? phone) async {
    if (phone != null) await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _launchSms(String? phone) async {
    if (phone != null) await launchUrl(Uri.parse('sms:$phone'));
  }
}
