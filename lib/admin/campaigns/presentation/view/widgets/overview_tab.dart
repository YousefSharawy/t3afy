import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/core/utils/photo_viewer.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/map_button.dart'
    show openDirections;
import 'package:url_launcher/url_launcher.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  bool get _hasCoords =>
      detail.locationLat != null &&
      detail.locationLng != null &&
      detail.locationLat != 0 &&
      detail.locationLng != 0;

  Future<void> _openLocation() async {
    if (_hasCoords) {
      await openDirections(detail.locationLat!, detail.locationLng!);
      return;
    }
    final query = detail.locationAddress ?? detail.locationName ?? '';
    if (query.isEmpty) return;
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(detail.date);
    final time = DateAr.timeRange(detail.timeStart, detail.timeEnd);
    final location = [
      detail.locationName,
      detail.locationAddress,
    ].where((s) => s != null && s.isNotEmpty).join('، ');
    final hasLocationText = location.isNotEmpty;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.vl,
        Space.gutter,
        Space.vxl + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        _Section(
          title: 'معلومات الحملة',
          child: Column(
            children: [
              _InfoLine(
                icon: AppIcons.calendar,
                label: 'التاريخ',
                value: date == null ? detail.date : DateAr.date(date),
              ),
              if (time.isNotEmpty)
                _InfoLine(icon: AppIcons.alarm, label: 'الوقت', value: time),
              if (detail.type.isNotEmpty)
                _InfoLine(icon: AppIcons.target, label: 'النوع', value: detail.type),
              if (hasLocationText)
                _InfoLine(icon: AppIcons.location, label: 'الموقع', value: location),
              if ((detail.supervisorName ?? '').isNotEmpty)
                _InfoLine(
                  icon: AppIcons.mentor,
                  label: 'المشرف',
                  value: detail.supervisorName!,
                ),
              if ((detail.supervisorPhone ?? '').isNotEmpty)
                _InfoLine(
                  icon: AppIcons.phone,
                  label: 'هاتف المشرف',
                  value: detail.supervisorPhone!,
                  ltr: true,
                ),
              _InfoLine(
                icon: AppIcons.gift,
                label: 'النقاط',
                value: '${detail.points} نقطة',
              ),
            ],
          ),
        ),
        SizedBox(height: Space.vl),
        _Section(
          title: 'الفريق والمستفيدون',
          child: Column(
            children: [
              _InfoLine(
                icon: AppIcons.group,
                label: 'المتطوعون',
                value: '${detail.members.length} متطوع',
              ),
              _InfoLine(
                icon: AppIcons.target,
                label: 'المستهدف',
                value: '${detail.targetBeneficiaries} مستفيد',
              ),
              _InfoLine(
                icon: AppIcons.done2,
                label: 'تم الوصول إليهم',
                value: '${detail.reachedBeneficiaries} مستفيد',
                valueColor: detail.reachedBeneficiaries > 0
                    ? ColorManager.sproutText
                    : null,
              ),
            ],
          ),
        ),
        if (_hasCoords || hasLocationText) ...[
          SizedBox(height: Space.vl),
          _Section(
            title: 'الموقع',
            trailing: TextButton.icon(
              onPressed: _openLocation,
              icon: const Icon(AppIcons.map, size: 18),
              label: const Text('الاتجاهات'),
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.brand,
                minimumSize: Size(AppSizes.touch, AppSizes.touch * 0.8),
              ),
            ),
            child: _hasCoords
                ? AppMapPreview(
                    point: LatLng(detail.locationLat!, detail.locationLng!),
                    circleRadiusMeters: 200,
                    onTap: _openLocation,
                  )
                : Text(location, style: AppText.body(color: ColorManager.inkMuted)),
          ),
        ],
        if ((detail.description ?? '').isNotEmpty) ...[
          SizedBox(height: Space.vl),
          _Section(
            title: 'الوصف',
            child: Text(
              detail.description!,
              style: AppText.body(color: ColorManager.inkMuted),
            ),
          ),
        ],
        if (detail.objectives.isNotEmpty) ...[
          SizedBox(height: Space.vl),
          _Section(
            title: 'الأهداف',
            child: Column(
              children: [
                for (final o in detail.objectives)
                  _BulletLine(icon: AppIcons.done2, text: o.title),
              ],
            ),
          ),
        ],
        if (detail.supplies.isNotEmpty) ...[
          SizedBox(height: Space.vl),
          _Section(
            title: 'المستلزمات',
            child: Column(
              children: [
                for (final s in detail.supplies)
                  _BulletLine(
                    icon: AppIcons.requirements,
                    text: s.name,
                    trailing: '× ${s.quantity}',
                  ),
              ],
            ),
          ),
        ],
        if ((detail.notes ?? '').isNotEmpty) ...[
          SizedBox(height: Space.vl),
          _Section(
            title: 'ملاحظات',
            child: Text(
              detail.notes!,
              style: AppText.body(color: ColorManager.inkMuted),
            ),
          ),
        ],
        if (detail.papers.isNotEmpty) ...[
          SizedBox(height: Space.vl),
          _Section(
            title: 'أوراق التصاريح',
            child: _PapersGallery(papers: detail.papers),
          ),
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: title, trailing: trailing),
          child,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.ltr = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Space.vxs),
      child: Row(
        children: [
          AppIconBadge(icon: icon, size: 32),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.caption()),
                Text(
                  value,
                  textDirection: ltr ? TextDirection.ltr : null,
                  style: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: valueColor ?? ColorManager.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.icon, required this.text, this.trailing});

  final IconData icon;
  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Space.vxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconM, color: ColorManager.sprout),
          SizedBox(width: Space.s),
          Expanded(child: Text(text, style: AppText.body())),
          if (trailing != null)
            Text(
              trailing!,
              style: getNumericStyle(
                fontSize: FontSize.s13,
                color: ColorManager.inkMuted,
              ),
            ),
        ],
      ),
    );
  }
}

class _PapersGallery extends StatelessWidget {
  const _PapersGallery({required this.papers});

  final List<CampaignPaperEntity> papers;

  Future<void> _open(BuildContext context, CampaignPaperEntity paper) async {
    if (paper.fileName.toLowerCase().endsWith('.pdf')) {
      final url = Uri.tryParse(paper.fileUrl);
      if (url != null) await launchUrl(url, mode: LaunchMode.externalApplication);
      return;
    }
    await openPhotoViewer(context, paper.fileUrl, heroTag: paper.id);
  }

  @override
  Widget build(BuildContext context) {
    const size = 96.0;
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: papers.length,
        separatorBuilder: (_, _) => SizedBox(width: Space.s),
        itemBuilder: (context, index) {
          final paper = papers[index];
          final isPdf = paper.fileName.toLowerCase().endsWith('.pdf');
          return Semantics(
            button: true,
            label: 'عرض الورقة ${index + 1}',
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.input),
              onTap: () => _open(context, paper),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.input),
                child: Container(
                  width: size,
                  height: size,
                  color: ColorManager.surfaceSunken,
                  child: isPdf
                      ? const Icon(AppIcons.pdf, size: 36, color: ColorManager.error)
                      : Hero(
                          tag: paper.id,
                          child: CachedNetworkImage(
                            imageUrl: paper.fileUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: (size * 2).round(),
                            placeholder: (_, _) =>
                                const ColoredBox(color: ColorManager.surfaceSunken),
                            errorWidget: (_, _, _) => const Icon(
                              Icons.broken_image_rounded,
                              color: ColorManager.inkFaint,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
