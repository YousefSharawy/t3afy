import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/core/utils/photo_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PermitPapersSection extends StatelessWidget {
  const PermitPapersSection({super.key, required this.papers});

  final List<CampaignPaperEntity> papers;

  static const double _thumb = 96;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'أوراق التصاريح'),
          SizedBox(
            height: _thumb,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: papers.length,
              separatorBuilder: (_, _) => SizedBox(width: Space.s),
              itemBuilder: (context, index) {
                final paper = papers[index];
                final isPdf = paper.fileName.toLowerCase().endsWith('.pdf');
                return Semantics(
                  key: ValueKey(paper.id),
                  button: true,
                  label: paper.fileName,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.input),
                    onTap: () => isPdf
                        ? _openPdf(paper.fileUrl)
                        : openPhotoViewer(context, paper.fileUrl),
                    child: Container(
                      width: _thumb,
                      height: _thumb,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ColorManager.surfaceSunken,
                        borderRadius: BorderRadius.circular(Radii.input),
                        border: Border.all(color: ColorManager.line),
                      ),
                      child: isPdf
                          ? const Icon(
                              AppIcons.pdf,
                              size: 36,
                              color: ColorManager.error,
                            )
                          : CachedNetworkImage(
                              imageUrl: paper.fileUrl,
                              fit: BoxFit.cover,
                              memCacheWidth: (_thumb * dpr).round(),
                              placeholder: (_, _) => const Skeleton(
                                child: SkeletonBox(height: _thumb),
                              ),
                              errorWidget: (_, _, _) => const Icon(
                                Icons.broken_image_rounded,
                                size: 28,
                                color: ColorManager.inkFaint,
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

  Future<void> _openPdf(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
