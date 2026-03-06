import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
class CustomShimmerWrapW extends StatelessWidget {
  const CustomShimmerWrapW({
    super.key,
    this.spacing,
    this.runSpacing,
    required this.width,
    required this.height,
    this.borderRadius,
    required this.itemCount,
    this.direction,
    this.padding,
  });
  final double? spacing;
  final double? runSpacing;
  final double width;
  final double height;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final Axis? direction;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        direction: direction ?? Axis.horizontal,
        spacing: spacing ?? AppWidth.s16,
        runSpacing: runSpacing ?? AppHeight.s16,
        children: List.generate(
          itemCount,
          (index) => CustomShimmerCardW(
              width: width, height: height, borderRadius: borderRadius),
        ),
      ),
    );
  }
}

class CustomShimmerCardW extends StatelessWidget {
  const CustomShimmerCardW({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.padding,
    this.circler = false,
  });

  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool circler;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: AppWidth.s6),
      child: Shimmer(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEBEBF4),
              Color(0xFFF4F4F4),
              Color(0xFFEBEBF4),
            ],
            stops: [
              0.1,
              0.3,
              0.4,
            ],
            begin: Alignment(-1.0, -0.3),
            end: Alignment(1.0, 0.3),
            tileMode: TileMode.clamp,
          ),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: circler ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: circler
                  ? null
                  : borderRadius ?? BorderRadius.circular(AppRadius.s8),
              color: ColorManager.black,
            ),
          )),
    );
  }
}
