import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Label above an auth form field — one size and one gap for every field.
class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key, this.topGap = true});

  final String text;

  /// Adds the section gap above the label (off for the first field).
  final bool topGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: topGap ? Space.vl : 0,
        bottom: Space.vs,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: getSemiBoldStyle(
            fontSize: FontSize.s14,
            color: ColorManager.ink,
          ),
        ),
      ),
    );
  }
}
