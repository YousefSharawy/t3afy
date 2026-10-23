import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SupervisorSection extends StatelessWidget {
  const SupervisorSection({super.key, required this.name, this.phone});

  final String name;
  final String? phone;

  bool get _hasPhone => phone != null && phone!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'المشرف المسؤول'),
          Row(
            children: [
              const AppIconBadge(icon: AppIcons.mentor, size: 44),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppText.bodyStrong()),
                    if (_hasPhone)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          phone!,
                          style: getNumericStyle(
                            fontSize: 13,
                            color: ColorManager.inkMuted,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_hasPhone) ...[
                _ContactButton(
                  icon: AppIcons.call,
                  tooltip: 'اتصال بالمشرف',
                  onPressed: () => launchUrl(Uri.parse('tel:$phone')),
                ),
                SizedBox(width: Space.xs),
                _ContactButton(
                  icon: AppIcons.message,
                  tooltip: 'رسالة نصية للمشرف',
                  onPressed: () => launchUrl(Uri.parse('sms:$phone')),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: ColorManager.brandSoft,
        foregroundColor: ColorManager.brand,
        minimumSize: Size.square(AppSizes.touch),
      ),
      icon: Icon(icon, size: 20),
    );
  }
}
