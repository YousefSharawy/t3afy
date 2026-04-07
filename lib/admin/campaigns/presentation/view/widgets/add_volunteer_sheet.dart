import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/base/primary_widgets.dart';

class AddVolunteerSheet extends StatefulWidget {
  const AddVolunteerSheet({
    super.key,
    required this.taskId,
    required this.volunteers,
  });

  final String taskId;
  final List<VolunteerEntity> volunteers;

  @override
  State<AddVolunteerSheet> createState() => _AddVolunteerSheetState();
}

class _AddVolunteerSheetState extends State<AddVolunteerSheet> {
  final Set<String> _selected = {};
  bool _loading = false;

  bool get _allSelected =>
      widget.volunteers.isNotEmpty &&
      widget.volunteers.every((v) => _selected.contains(v.id));

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected.addAll(widget.volunteers.map((v) => v.id));
      }
    });
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  Future<void> _submit() async {
    if (_selected.isEmpty) return;
    final adminId = LocalAppStorage.getUserId() ?? '';
    final count = _selected.length;
    setState(() => _loading = true);
    final success = await context.read<CampaignDetailCubit>().assignVolunteers(
      taskId: widget.taskId,
      userIds: _selected.toList(),
      adminId: adminId,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (success) {
      Toast.success.show(context, title: 'تم تعيين $count متطوع بنجاح');
      Navigator.pop(context);
    } else {
      final state = context.read<CampaignDetailCubit>().state;
      final message = state is CampaignDetailActionError
          ? state.message
          : 'حدث خطأ';
      Toast.error.show(context, title: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: ColorManager.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: AppHeight.s12),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.natural200,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppHeight.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                child: Row(
                  children: [
                    Text(
                      'إضافة متطوعين',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s16,
                        color: ColorManager.natural700,
                      ),
                    ),
                    const Spacer(),
                    if (_selected.isNotEmpty)
                      Text(
                        'تم تحديد ${_selected.length} متطوع',
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s14,
                          color: ColorManager.primary500,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.volunteers.isNotEmpty) ...[
                SizedBox(height: AppHeight.s8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: _toggleAll,
                      child: Text(
                        _allSelected ? 'إلغاء التحديد' : 'تحديد الكل',
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s13,
                          color: ColorManager.primary500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppHeight.s8),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary500,
                        ),
                      )
                    : widget.volunteers.isEmpty
                    ? Center(
                        child: Text(
                          'لا يوجد متطوعون متاحون',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s14,
                            color: ColorManager.natural400,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                        itemCount: widget.volunteers.length,
                        itemBuilder: (context, i) {
                          final v = widget.volunteers[i];
                          final isSelected = _selected.contains(v.id);
                          return GestureDetector(
                            onTap: () => _toggle(v.id),
                            child: Container(
                              margin: EdgeInsets.only(bottom: AppHeight.s10),
                              padding: EdgeInsets.all(AppSize.s12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorManager.primary500.withValues(
                                        alpha: 0.08,
                                      )
                                    : ColorManager.white,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.s12,
                                ),
                                border: isSelected
                                    ? Border.all(
                                        color: ColorManager.primary500
                                            .withValues(alpha: 0.4),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          color: ColorManager.primary500,
                                          size: 22.r,
                                        )
                                      : Container(
                                          width: AppWidth.s32,
                                          height: AppHeight.s32,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.5.sp,
                                              color: ColorManager.primary500,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.s8,
                                            ),
                                            color: ColorManager.primary50,
                                          ),
                                          child: Image.asset(IconAssets.vol2),
                                        ),
                                  SizedBox(width: AppWidth.s12),
                                  Expanded(
                                    child: Text(
                                      v.name,
                                      style: getMediumStyle(
                                        fontFamily: FontConstants.fontFamily,
                                        fontSize: FontSize.s13,
                                        color: ColorManager.natural900,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 13.r,
                                        color: const Color(0xFFFBBF24),
                                      ),
                                      SizedBox(width: AppWidth.s2),
                                      Text(
                                        v.rating.toStringAsFixed(1),
                                        style: getRegularStyle(
                                          fontFamily: FontConstants.fontFamily,
                                          fontSize: FontSize.s11,
                                          color: ColorManager.natural400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppWidth.s16,
                  AppHeight.s8,
                  AppWidth.s16,
                  AppHeight.s16 + MediaQuery.of(context).padding.bottom,
                ),
                child: PrimaryElevatedButton(
                  title: _selected.isEmpty
                      ? 'تعيين'
                      : 'تعيين (${_selected.length})',
                  onPress: _selected.isEmpty ? () {} : _submit,
                  backGroundColor: _selected.isEmpty
                      ? ColorManager.natural300
                      : ColorManager.primary500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
