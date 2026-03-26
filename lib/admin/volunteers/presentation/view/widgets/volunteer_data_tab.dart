import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/section_label.dart';
import 'package:url_launcher/url_launcher.dart';
import 'qualification_row.dart';
import 'package:t3afy/base/widgets/info_row.dart';

class VolunteerDataTab extends StatefulWidget {
  const VolunteerDataTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<VolunteerDataTab> createState() => _VolunteerDataTabState();
}

class _VolunteerDataTabState extends State<VolunteerDataTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        // ── ID photo section ──
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              AppWidth.s16, AppHeight.s12, AppWidth.s16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(label: 'صورة الهوية'),
              SizedBox(height: AppHeight.s8),
              _buildIdSection(),
              SizedBox(height: AppHeight.s12),
              _buildStatusBadge(),
              SizedBox(height: AppHeight.s8),
            ],
          ),
        ),
        InfoRow(
          icon: IconAssets.phone,
          label: 'رقم الهاتف',
          value: widget.details.phone ?? '—',
        ),
        InfoRow(
          icon: IconAssets.email2,
          label: 'البريد',
          value: widget.details.email ?? '—',
        ),
        InfoRow(
          icon: IconAssets.location,
          label: 'المنطقة',
          value: widget.details.region ?? '—',
        ),
        InfoRow(
          icon: IconAssets.calendar,
          label: 'تاريخ الانضمام',
          value: widget.details.joinedAt != null
              ? _formatArabicMonth(widget.details.joinedAt!)
              : '—',
        ),
        InfoRow(
          icon: IconAssets.hours,
          label: 'آخر ظهور',
          value: widget.details.lastSeenAt != null
              ? _timeAgo(widget.details.lastSeenAt!)
              : '—',
        ),
        QualificationRow(
          values: widget.details.volunteerAreas,
        ),
      ],
    );
  }

  Widget _buildIdSection() {
    final url = widget.details.idFileUrl;
    if (url == null || url.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppHeight.s16),
        decoration: BoxDecoration(
          color: ColorManager.natural100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          'لم يتم رفع صورة الهوية',
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.natural400,
            fontSize: FontSize.s13,
          ),
        ),
      );
    }
    final isPdf = url.toLowerCase().endsWith('.pdf');
    if (isPdf) {
      return GestureDetector(
        onTap: () => launchUrl(Uri.parse(url),
            mode: LaunchMode.externalApplication),
        child: Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: ColorManager.natural100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf_outlined,
                  size: 48.r, color: ColorManager.error),
              SizedBox(height: AppHeight.s8),
              Text(
                'عرض الهوية',
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.primary500,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () => _openFullscreen(url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: url,
          width: double.infinity,
          height: 200.h,
          fit: BoxFit.cover,
          placeholder: (context, url) => CustomShimmerWrapW(
            width: double.infinity,
            height: 200.h,
            itemCount: 1,
            borderRadius: BorderRadius.circular(12.r),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 200.h,
            color: ColorManager.natural100,
            child: Icon(Icons.broken_image_outlined,
                size: 40.r, color: ColorManager.natural300),
          ),
        ),
      ),
    );
  }

  void _openFullscreen(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PhotoView(
            imageProvider: CachedNetworkImageProvider(url),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final role = widget.details.role;
    final isApproved = role == 'volunteer';
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppWidth.s12, vertical: AppHeight.s4),
          decoration: BoxDecoration(
            color: isApproved
                ? ColorManager.successLight
                : ColorManager.warningLight,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isApproved ? ColorManager.success : ColorManager.warning,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isApproved ? Icons.verified_outlined : Icons.hourglass_empty,
                size: 14.r,
                color: isApproved ? ColorManager.success : ColorManager.warning,
              ),
              SizedBox(width: AppWidth.s4),
              Text(
                isApproved ? 'تم التحقق' : 'بانتظار المراجعة',
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color:
                      isApproved ? ColorManager.success : ColorManager.warning,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatArabicMonth(DateTime dt) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'منذ لحظات';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
    return 'منذ أكثر من شهر';
  }
}
