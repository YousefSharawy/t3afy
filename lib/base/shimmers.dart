import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';

/// Skeletons that mirror the real layout, so first loads don't jump.
/// Wrap any group of [SkeletonBox]es in one [Skeleton] (single pulse).
///
/// The pulse is a plain opacity animation behind a [RepaintBoundary]: the
/// boxes are rasterized once and only re-composited with a new alpha each
/// frame (a shader-mask shimmer re-painted an offscreen layer every frame,
/// which spiked the first frames of every route transition).
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.child});
  final Widget child;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    value: 1,
  );
  late final Animation<double> _opacity = Tween(
    begin: 0.55,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _controller
        ..stop()
        ..value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: _opacity,
        child: RepaintBoundary(child: widget.child),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius,
    this.circle = false,
  });

  final double? width;
  final double height;
  final double? radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circle ? height : width,
      height: height,
      decoration: BoxDecoration(
        color: ColorManager.shimmerBaseColor,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle
            ? null
            : BorderRadius.circular(radius ?? Radii.small),
      ),
    );
  }
}

/// Card-shaped list skeleton (task / campaign / volunteer / report rows).
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.count = 4,
    this.itemHeight,
    this.padding,
    this.shrinkWrap = false,
  });

  final int count;
  final double? itemHeight;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: ListView.separated(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        padding:
            padding ??
            EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.vl),
        itemCount: count,
        separatorBuilder: (_, _) => SizedBox(height: Space.vm),
        itemBuilder: (_, _) => SkeletonCard(height: itemHeight),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppHeight.s100,
      padding: EdgeInsets.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(height: AppHeight.s32, circle: true),
              SizedBox(width: Space.m),
              Expanded(child: SkeletonBox(height: AppHeight.s14)),
              SizedBox(width: Space.xl),
              SkeletonBox(width: AppWidth.s56, height: AppHeight.s20),
            ],
          ),
          const Spacer(),
          SkeletonBox(width: AppWidth.s200, height: AppHeight.s12),
          SizedBox(height: Space.vs),
          SkeletonBox(width: AppWidth.s120, height: AppHeight.s12),
        ],
      ),
    );
  }
}

/// Grid of KPI tile skeletons.
class SkeletonStats extends StatelessWidget {
  const SkeletonStats({super.key, this.count = 4, this.columns = 2});
  final int count;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: GridView.count(
        crossAxisCount: columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: Space.vm,
        crossAxisSpacing: Space.m,
        childAspectRatio: 1.6,
        children: List.generate(
          count,
          (_) => SkeletonBox(height: AppHeight.s90, radius: Radii.card),
        ),
      ),
    );
  }
}
