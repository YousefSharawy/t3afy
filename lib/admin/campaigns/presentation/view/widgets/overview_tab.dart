import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSize.s16),
      children: [
        _InfoCard(
          children: [
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'المنطقة',
              value: detail.locationName ?? '—',
            ),
            _Divider(),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'التاريخ',
              value: detail.date,
            ),
            _Divider(),
            _InfoRow(
              icon: Icons.category_outlined,
              label: 'النوع',
              value: detail.type,
            ),
            if (detail.supervisorName != null) ...[
              _Divider(),
              _InfoRow(
                icon: Icons.person_outlined,
                label: 'المشرف',
                value: detail.supervisorName!,
              ),
            ],
            if (detail.supervisorPhone != null) ...[
              _Divider(),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'هاتف المشرف',
                value: detail.supervisorPhone!,
              ),
            ],
          ],
        ),
        SizedBox(height: AppHeight.s16),
        _InfoCard(
          children: [
            _InfoRow(
              icon: Icons.group_outlined,
              label: 'المتطوعون',
              value: '${detail.members.length} من ${detail.targetBeneficiaries > 0 ? detail.targetBeneficiaries : '—'}',
            ),
            _Divider(),
            _InfoRow(
              icon: Icons.flag_outlined,
              label: 'الهدف',
              value: '${detail.targetBeneficiaries} مستفيد',
            ),
            _Divider(),
            _InfoRowWithCheck(
              icon: Icons.check_circle_outline,
              label: 'تم الوصول',
              value: '${detail.reachedBeneficiaries} مستفيد',
              achieved: detail.reachedBeneficiaries > 0,
            ),
          ],
        ),
        if (detail.description != null && detail.description!.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          _SectionCard(title: 'الوصف', body: detail.description!),
        ],
        if (detail.notes != null && detail.notes!.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          _SectionCard(title: 'ملاحظات', body: detail.notes!),
        ],
        if (detail.objectives.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          _ListCard(
            title: 'الأهداف',
            items: detail.objectives.map((o) => o.title).toList(),
            icon: Icons.check_box_outlined,
          ),
        ],
        if (detail.supplies.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          Container(
            padding: EdgeInsets.all(AppSize.s16),
            decoration: BoxDecoration(
              color: ColorManager.blueOne800,
              borderRadius: BorderRadius.circular(AppRadius.s12),
              border: Border.all(color: ColorManager.blueOne700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المستلزمات',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s13,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppHeight.s12),
                ...detail.supplies.map(
                  (s) => Padding(
                    padding: EdgeInsets.only(bottom: AppHeight.s8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14.r,
                          color: const Color(0xFF00ABD2),
                        ),
                        SizedBox(width: AppWidth.s8),
                        Expanded(
                          child: Text(
                            s.name,
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppWidth.s8,
                            vertical: AppHeight.s2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.blueOne700,
                            borderRadius: BorderRadius.circular(AppRadius.s8),
                          ),
                          child: Text(
                            '${s.quantity}',
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s11,
                              color: ColorManager.blueTwo200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: AppHeight.s80),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.blueOne700),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s12,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: const Color(0xFF00ABD2)),
          SizedBox(width: AppWidth.s10),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowWithCheck extends StatelessWidget {
  const _InfoRowWithCheck({
    required this.icon,
    required this.label,
    required this.value,
    required this.achieved,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool achieved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.r,
            color: achieved ? const Color(0xFF4ADE80) : Colors.white.withValues(alpha: 0.3),
          ),
          SizedBox(width: AppWidth.s10),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: achieved ? const Color(0xFF4ADE80) : Colors.white,
            ),
          ),
          if (achieved) ...[
            SizedBox(width: AppWidth.s4),
            Icon(Icons.check_circle, size: 14.r, color: const Color(0xFF4ADE80)),
          ],
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: ColorManager.blueOne700,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.blueOne700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          Text(
            body,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.title,
    required this.items,
    required this.icon,
  });

  final String title;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.blueOne700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s8),
              child: Row(
                children: [
                  Icon(icon, size: 14.r, color: const Color(0xFF00ABD2)),
                  SizedBox(width: AppWidth.s8),
                  Expanded(
                    child: Text(
                      item,
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
