import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/core/utils/photo_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:t3afy/base/widgets/after_transition.dart';
import 'qualification_row.dart';

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
    final d = widget.details;
    final isApproved = d.role == 'volunteer';
    final joined = DateAr.tryParse(d.joinedAt);
    return ListView(
      padding: EdgeInsets.only(
        top: Space.vs,
        bottom: Space.vxl + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        const SectionHeader(title: 'صورة الهوية'),
        _IdSection(url: d.idFileUrl),
        SizedBox(height: Space.vm),
        MetaItem(
          icon: isApproved ? AppIcons.commit : AppIcons.alarm,
          text: isApproved ? 'تم التحقق' : 'بانتظار المراجعة',
          color: isApproved ? ColorManager.sproutText : ColorManager.warning,
        ),
        SizedBox(height: Space.vxl),
        const SectionHeader(title: 'البيانات الشخصية'),
        AppCard(
          padding: EdgeInsets.symmetric(
            horizontal: Space.l,
            vertical: Space.vs,
          ),
          child: Column(
            children: [
              _InfoLine(
                icon: AppIcons.phone,
                label: 'رقم الهاتف',
                value: d.phone ?? '—',
                ltr: d.phone != null,
              ),
              const _Divider(),
              _InfoLine(
                icon: AppIcons.email2,
                label: 'البريد',
                value: d.email ?? '—',
                ltr: d.email != null,
              ),
              const _Divider(),
              _InfoLine(
                icon: AppIcons.location,
                label: 'المنطقة',
                value: d.region ?? '—',
              ),
              const _Divider(),
              _InfoLine(
                icon: AppIcons.calendar,
                label: 'تاريخ الانضمام',
                value: joined != null
                    ? '${DateAr.month(joined.month)} ${joined.year}'
                    : '—',
              ),
              const _Divider(),
              _InfoLine(
                icon: AppIcons.hours,
                label: 'آخر ظهور',
                value: d.lastSeenAt != null
                    ? DateAr.timeAgo(d.lastSeenAt)
                    : '—',
              ),
            ],
          ),
        ),
        SizedBox(height: Space.vm),
        QualificationRow(values: d.volunteerAreas),
      ],
    );
  }
}

class _IdSection extends StatelessWidget {
  const _IdSection({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final u = url;
    if (u == null || u.isEmpty) {
      return AppCard(
        child: Row(
          children: [
            const AppIconBadge(
              icon: AppIcons.person,
              color: ColorManager.inkFaint,
            ),
            SizedBox(width: Space.m),
            Expanded(
              child: Text('لم يتم رفع صورة الهوية', style: AppText.label()),
            ),
          ],
        ),
      );
    }
    if (u.toLowerCase().endsWith('.pdf')) {
      return AppCard(
        onTap: () =>
            launchUrl(Uri.parse(u), mode: LaunchMode.externalApplication),
        semanticLabel: 'عرض ملف الهوية',
        child: Row(
          children: [
            const AppIconBadge(icon: AppIcons.pdf, color: ColorManager.error),
            SizedBox(width: Space.m),
            Expanded(
              child: Text('عرض ملف الهوية (PDF)', style: AppText.bodyStrong()),
            ),
            const Icon(AppIcons.chevron, color: ColorManager.inkFaint),
          ],
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        return Semantics(
          button: true,
          label: 'عرض صورة الهوية',
          child: GestureDetector(
            onTap: () => openPhotoViewer(context, u, heroTag: 'id-$u'),
            child: Hero(
              tag: 'id-$u',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.card),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: AfterTransition(
                    placeholder: Skeleton(
                      child: SkeletonBox(
                        height: double.infinity,
                        radius: Radii.card,
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: u,
                      fit: BoxFit.cover,
                      memCacheWidth: (constraints.maxWidth * dpr).round(),
                      placeholder: (_, _) => Skeleton(
                        child: SkeletonBox(
                          height: double.infinity,
                          radius: Radii.card,
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: ColorManager.surfaceSunken,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: AppSizes.iconL * 1.6,
                          color: ColorManager.inkFaint,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
    this.ltr = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Phone / email read left-to-right.
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Space.vs),
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
                  style: AppText.bodyStrong(),
                  textDirection: ltr ? TextDirection.ltr : null,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: ColorManager.line);
}
