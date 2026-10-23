import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';

/// The one volunteer multi-select sheet, used by the campaign form (pick the
/// team) and by the detail Team tab (assign more volunteers).
class VolunteerPickerSheet extends StatefulWidget {
  const VolunteerPickerSheet({
    super.key,
    required this.volunteers,
    required this.onConfirm,
    required this.confirmLabel,
    this.initialSelected = const {},
    this.onRefresh,
  });

  final List<VolunteerEntity> volunteers;
  final Set<String> initialSelected;

  /// Button label without the count, e.g. "تأكيد" / "تعيين".
  final String confirmLabel;

  /// Returns true when the sheet should close.
  final Future<bool> Function(Set<String> ids) onConfirm;

  /// Pull-to-refresh source (always bypasses caches).
  final Future<List<VolunteerEntity>> Function()? onRefresh;

  static Future<void> show(
    BuildContext context, {
    required List<VolunteerEntity> volunteers,
    required Future<bool> Function(Set<String> ids) onConfirm,
    required String confirmLabel,
    Set<String> initialSelected = const {},
    Future<List<VolunteerEntity>> Function()? onRefresh,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VolunteerPickerSheet(
        volunteers: volunteers,
        initialSelected: initialSelected,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        onRefresh: onRefresh,
      ),
    );
  }

  @override
  State<VolunteerPickerSheet> createState() => _VolunteerPickerSheetState();
}

class _VolunteerPickerSheetState extends State<VolunteerPickerSheet> {
  late List<VolunteerEntity> _volunteers = widget.volunteers;
  late final Set<String> _selected = Set.of(widget.initialSelected);
  bool _submitting = false;

  bool get _allSelected =>
      _volunteers.isNotEmpty && _volunteers.every((v) => _selected.contains(v.id));

  void _toggle(String id) => setState(() {
    if (!_selected.remove(id)) _selected.add(id);
  });

  void _toggleAll() => setState(() {
    if (_allSelected) {
      _selected.removeAll(_volunteers.map((v) => v.id));
    } else {
      _selected.addAll(_volunteers.map((v) => v.id));
    }
  });

  Future<void> _refresh() async {
    final fresh = await widget.onRefresh!();
    if (mounted) setState(() => _volunteers = fresh);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final close = await widget.onConfirm(Set.of(_selected));
    if (!mounted) return;
    if (close) {
      Navigator.pop(context);
    } else {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.35,
      expand: false,
      builder: (context, controller) {
        final list = _volunteers.isEmpty
            ? ListView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  AppEmptyState(
                    title: 'لا يوجد متطوعون متاحون',
                    icon: AppIcons.vol2,
                    compact: true,
                  ),
                ],
              )
            : ListView.separated(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Space.gutter),
                itemCount: _volunteers.length,
                separatorBuilder: (_, _) => SizedBox(height: Space.vs),
                itemBuilder: (context, i) {
                  final v = _volunteers[i];
                  return VolunteerRow(
                    key: ValueKey(v.id),
                    volunteer: v,
                    selected: _selected.contains(v.id),
                    onTap: () => _toggle(v.id),
                  );
                },
              );

        return Container(
          decoration: BoxDecoration(
            color: ColorManager.canvas,
            borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
          ),
          child: Column(
            children: [
              SizedBox(height: Space.vm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorManager.line,
                  borderRadius: BorderRadius.circular(Radii.chip),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  Space.gutter,
                  Space.vm,
                  Space.s,
                  Space.vxs,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('اختيار المتطوعين', style: AppText.title()),
                    ),
                    if (_volunteers.isNotEmpty)
                      TextButton(
                        onPressed: _toggleAll,
                        style: TextButton.styleFrom(
                          foregroundColor: ColorManager.brand,
                          minimumSize: Size(AppSizes.touch, AppSizes.touch),
                        ),
                        child: Text(_allSelected ? 'إلغاء التحديد' : 'تحديد الكل'),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: widget.onRefresh == null
                    ? list
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        color: ColorManager.brand,
                        backgroundColor: ColorManager.surface,
                        child: list,
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Space.gutter,
                  Space.vs,
                  Space.gutter,
                  Space.vl + MediaQuery.paddingOf(context).bottom,
                ),
                child: PrimaryElevatedButton(
                  title: _selected.isEmpty
                      ? widget.confirmLabel
                      : '${widget.confirmLabel} (${_selected.length})',
                  isLoading: _submitting,
                  onPress: _submit,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Volunteer row: avatar, name, region and rating, with a trailing control
/// (a check mark in the picker, a remove button in the form's team list).
class VolunteerRow extends StatelessWidget {
  const VolunteerRow({
    super.key,
    required this.volunteer,
    this.selected = false,
    this.onTap,
    this.trailing,
    this.color = ColorManager.surface,
  });

  final VolunteerEntity volunteer;
  final bool selected;
  final Color color;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: color,
      padding: EdgeInsetsDirectional.fromSTEB(Space.m, Space.vs, Space.s, Space.vs),
      border: Border.all(
        color: selected ? ColorManager.brand : ColorManager.transparent,
      ),
      semanticLabel: onTap == null ? null : volunteer.name,
      child: Row(
        children: [
          VolunteerAvatar(url: volunteer.avatarUrl, size: 40),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer.name,
                  style: getMediumStyle(fontSize: FontSize.s14, color: ColorManager.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Space.vxs * 0.5),
                Wrap(
                  spacing: Space.m,
                  children: [
                    MetaItem(
                      icon: AppIcons.star,
                      text: volunteer.rating.toStringAsFixed(1),
                    ),
                    if ((volunteer.region ?? '').isNotEmpty)
                      MetaItem(icon: AppIcons.location, text: volunteer.region!),
                  ],
                ),
              ],
            ),
          ),
          trailing ??
              SizedBox.square(
                dimension: AppSizes.touch,
                child: AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.fast),
                  child: Icon(
                    selected ? AppIcons.done : Icons.radio_button_unchecked_rounded,
                    key: ValueKey(selected),
                    color: selected ? ColorManager.brand : ColorManager.line,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class VolunteerAvatar extends StatelessWidget {
  const VolunteerAvatar({super.key, required this.url, this.size = 40});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(AppIcons.person, color: ColorManager.brand, size: size * 0.5);
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: ColorManager.brandSoft,
        alignment: Alignment.center,
        child: (url == null || url!.isEmpty)
            ? fallback
            : CachedNetworkImage(
                imageUrl: url!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                memCacheWidth: (size * 3).round(),
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
