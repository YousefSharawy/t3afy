import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_view/photo_view.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/map_button.dart';
import 'overview_info_card.dart';
import 'package:t3afy/base/widgets/info_row.dart';
import 'overview_info_row_with_check.dart';
import 'overview_divider.dart';
import 'overview_section_card.dart';
import 'overview_list_card.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSize.s16),
      children: [
        OverviewInfoCard(
          children: [
            InfoRow(
              icon: IconAssets.location,
              label: 'المنطقة',
              value: detail.locationName ?? '—',
            ),
            const OverviewDivider(),
            InfoRow(
              icon: IconAssets.calendar,
              label: 'التاريخ',
              value: detail.date,
            ),
            const OverviewDivider(),
            InfoRow(
              icon: IconAssets.target,
              label: 'النوع',
              value: detail.type,
            ),
            if (detail.supervisorName != null) ...[
              const OverviewDivider(),
              InfoRow(
                icon: IconAssets.volHome,
                label: 'المشرف',
                value: detail.supervisorName!,
              ),
            ],
            if (detail.supervisorPhone != null) ...[
              InfoRow(
                icon: IconAssets.phone,
                label: 'هاتف المشرف',
                value: detail.supervisorPhone!,
              ),
            ],
          ],
        ),
        SizedBox(height: AppHeight.s16),
        OverviewInfoCard(
          children: [
            InfoRow(
              icon: IconAssets.group,
              label: 'المتطوعون',
              value:
                  '${detail.members.length} من ${detail.targetBeneficiaries > 0 ? detail.targetBeneficiaries : '—'}',
            ),
            InfoRow(
              icon: IconAssets.target,
              label: 'الهدف',
              value: '${detail.targetBeneficiaries} مستفيد',
            ),
            OverviewInfoRowWithCheck(
              icon: IconAssets.done2,
              label: 'تم الوصول',
              value: '${detail.reachedBeneficiaries} مستفيد',
              achieved: detail.reachedBeneficiaries > 0,
            ),
          ],
        ),
        // Attendance summary — only show when at least one member exists
        if (detail.members.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          _AttendanceSummaryCard(detail: detail),
        ],
        if (detail.locationLat != null &&
            detail.locationLng != null &&
            detail.locationLat != 0 &&
            detail.locationLng != 0) ...[
          SizedBox(height: AppHeight.s16),
          GestureDetector(
            onTap: () => openDirections(detail.locationLat!, detail.locationLng!),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              child: SizedBox(
                height: 150.h,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(detail.locationLat!, detail.locationLng!),
                    initialZoom: 14,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.t3afy.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(detail.locationLat!, detail.locationLng!),
                          width: 36.r,
                          height: 36.r,
                          child: Icon(
                            Icons.location_pin,
                            color: ColorManager.primary500,
                            size: 36.r,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppHeight.s8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: MapButton(
              lat: detail.locationLat,
              lng: detail.locationLng,
              locationName: detail.locationName,
              locationAddress: detail.locationAddress,
            ),
          ),
        ] else if (detail.locationName != null || detail.locationAddress != null) ...[
          SizedBox(height: AppHeight.s16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: MapButton(
              lat: detail.locationLat,
              lng: detail.locationLng,
              locationName: detail.locationName,
              locationAddress: detail.locationAddress,
            ),
          ),
        ],
        if (detail.description != null && detail.description!.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          OverviewSectionCard(title: 'الوصف', body: detail.description!),
        ],
        if (detail.notes != null && detail.notes!.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          OverviewSectionCard(title: 'ملاحظات', body: detail.notes!),
        ],
        if (detail.objectives.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          OverviewListCard(
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
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppRadius.s12),
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
                          color: ColorManager.cyanPrimary,
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
                            color: ColorManager.natural200,
                            borderRadius: BorderRadius.circular(AppRadius.s8),
                          ),
                          child: Text(
                            '${s.quantity}',
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s11,
                              color: ColorManager.natural400,
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
        if (detail.papers.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          _PapersSection(papers: detail.papers),
        ],
        SizedBox(height: AppHeight.s80),
      ],
    );
  }
}

class _AttendanceSummaryCard extends StatelessWidget {
  const _AttendanceSummaryCard({required this.detail});
  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final total = detail.members.length;
    final verified = detail.verifiedAttendanceCount;
    final rate = total > 0 ? verified / total : 0.0;

    return Container(
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الحضور',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: ColorManager.natural900,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الحضور المؤكد: $verified من $total متطوع',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.natural700,
                ),
              ),
              Text(
                '${(rate * 100).round()}%',
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.primary500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s4),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 6.h,
              backgroundColor: ColorManager.natural100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  ColorManager.primary500),
            ),
          ),
          if (detail.totalVerifiedHours > 0) ...[
            SizedBox(height: AppHeight.s8),
            Text(
              'إجمالي الساعات المؤكدة: ${detail.totalVerifiedHours.toStringAsFixed(1)} ساعة',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s11,
                color: ColorManager.natural500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PapersSection extends StatelessWidget {
  const _PapersSection({required this.papers});

  final List<CampaignPaperEntity> papers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أوراق التصاريح',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: ColorManager.natural900,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          SizedBox(
            height: 100.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: papers.length,
              itemBuilder: (context, index) {
                final paper = papers[index];
                final isPdf = paper.fileName.toLowerCase().endsWith('.pdf');
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: AppWidth.s8),
                  child: GestureDetector(
                    onTap: () => _openFullScreen(context, index),
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: ColorManager.natural100,
                        borderRadius: BorderRadius.circular(AppRadius.s12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.s12),
                        child: isPdf
                            ? Icon(
                                Icons.picture_as_pdf_outlined,
                                size: 40.r,
                                color: ColorManager.error,
                              )
                            : CachedNetworkImage(
                                imageUrl: paper.fileUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: ColorManager.natural100,
                                ),
                                errorWidget: (_, __, ___) => Icon(
                                  Icons.broken_image_outlined,
                                  size: 32.r,
                                  color: ColorManager.natural400,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreen(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _PaperFullScreenViewer(
          papers: papers,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _PaperFullScreenViewer extends StatefulWidget {
  const _PaperFullScreenViewer({
    required this.papers,
    required this.initialIndex,
  });

  final List<CampaignPaperEntity> papers;
  final int initialIndex;

  @override
  State<_PaperFullScreenViewer> createState() => _PaperFullScreenViewerState();
}

class _PaperFullScreenViewerState extends State<_PaperFullScreenViewer> {
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        itemCount: widget.papers.length,
        itemBuilder: (context, index) {
          final paper = widget.papers[index];
          return PhotoView(
            imageProvider: CachedNetworkImageProvider(paper.fileUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            errorBuilder: (_, __, ___) => Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 64,
                color: Colors.white38,
              ),
            ),
          );
        },
      ),
    );
  }
}
