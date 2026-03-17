import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          const SectionHeader(
            icon: Icons.person_rounded,
            title: 'المشرف المسؤول',
          ),
          SizedBox(height: AppHeight.s12),
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: ColorManager.navyLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.cyanPrimary.withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24.r,
                ),
              ),
              SizedBox(width: AppWidth.s10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: Colors.white,
                    ),
                  ),
                  if (phone != null) ...[
                    SizedBox(height: AppHeight.s2),
                    Text(
                      phone!,
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _launchSms(phone),
                    icon: Icon(
                      Icons.message_rounded,
                      color: ColorManager.cyanPrimary,
                      size: 22.r,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 36.r,
                      minHeight: 36.r,
                    ),
                  ),
                  SizedBox(width: AppWidth.s4),
                  IconButton(
                    onPressed: () => _launchPhone(phone),
                    icon: Icon(
                      Icons.phone_rounded,
                      color: ColorManager.cyanPrimary,
                      size: 22.r,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 36.r,
                      minHeight: 36.r,
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
