import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

class RoleSwitcher extends StatelessWidget {
  const RoleSwitcher(this.isVolunteer,{super.key});
  final bool isVolunteer;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.s47,
      decoration: BoxDecoration(
        color: ColorManager.lightGrey,
        borderRadius: BorderRadius.circular(AppRadius.s10),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            alignment: isVolunteer
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                height: AppHeight.s47,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: ColorManager.blue600,
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.blue600.withAlpha(80),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                onTap: () => context.read<AuthCubit>().toggleRole(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: AppWidth.s5),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: getBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            color: !isVolunteer
                                ? ColorManager.white
                                : ColorManager.blue100,
                            fontSize: FontSize.s14,
                          ),
                          child: const Text("Admin"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                onTap: () => context.read<AuthCubit>().toggleRole(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: isVolunteer
                            ? ColorManager.white
                            : ColorManager.blue100,
                        fontSize: FontSize.s14,
                      ),
                      child: const Text("volunteer"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}