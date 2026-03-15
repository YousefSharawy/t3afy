import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';

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
  bool _loading = false;

  Future<void> _assign(VolunteerEntity v) async {
    final adminId = LocalAppStorage.getUserId() ?? '';
    setState(() => _loading = true);
    await context.read<CampaignDetailCubit>().assignVolunteer(
          taskId: widget.taskId,
          userId: v.id,
          adminId: adminId,
        );
    if (mounted) Navigator.pop(context);
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
            color: ColorManager.blueOne900,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: AppHeight.s12),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.blueOne700,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppHeight.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                child: Text(
                  'إضافة متطوع',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: AppHeight.s12),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00ABD2),
                        ),
                      )
                    : widget.volunteers.isEmpty
                        ? Center(
                            child: Text(
                              'لا يوجد متطوعون متاحون',
                              style: getMediumStyle(
                                fontFamily: FontConstants.fontFamily,
                                fontSize: FontSize.s14,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppWidth.s16,
                            ),
                            itemCount: widget.volunteers.length,
                            itemBuilder: (context, i) {
                              final v = widget.volunteers[i];
                              return GestureDetector(
                                onTap: () => _assign(v),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: AppHeight.s10,
                                  ),
                                  padding: EdgeInsets.all(AppSize.s12),
                                  decoration: BoxDecoration(
                                    color: ColorManager.blueOne800,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.s12),
                                    border: Border.all(
                                      color: ColorManager.blueOne700,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor:
                                            ColorManager.blueOne700,
                                        backgroundImage: v.avatarUrl != null
                                            ? NetworkImage(v.avatarUrl!)
                                            : null,
                                        child: v.avatarUrl == null
                                            ? Icon(
                                                Icons.person,
                                                color: ColorManager.blueTwo200,
                                                size: 18.r,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: AppWidth.s12),
                                      Expanded(
                                        child: Text(
                                          v.name,
                                          style: getMediumStyle(
                                            fontFamily:
                                                FontConstants.fontFamily,
                                            fontSize: FontSize.s13,
                                            color: Colors.white,
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
                                              fontFamily:
                                                  FontConstants.fontFamily,
                                              fontSize: FontSize.s11,
                                              color: Colors.white
                                                  .withValues(alpha: 0.6),
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
            ],
          ),
        );
      },
    );
  }
}
