import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Base surface for every card. Tappable cards get a 0.97 press scale and
/// ink ripple within one frame (tap feedback < 100 ms).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.color = ColorManager.surface,
    this.accent,
    this.border,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final Color color;

  /// Optional status accent drawn as a thin bar on the leading edge (RTL-aware).
  final Color? accent;
  final BoxBorder? border;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(Radii.card);
    Widget body = Padding(
      padding: padding ?? EdgeInsets.all(Space.l),
      child: child,
    );
    if (accent != null) {
      body = Stack(
        children: [
          body,
          PositionedDirectional(
            start: 0,
            top: Space.vl,
            bottom: Space.vl,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadiusDirectional.horizontal(
                  end: Radius.circular(3),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final card = Material(
      color: color,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(borderRadius: radius, border: border),
        child: onTap == null && onLongPress == null
            ? body
            : InkWell(
                onTap: onTap == null
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        onTap!();
                      },
                onLongPress: onLongPress,
                child: body,
              ),
      ),
    );

    final wrapped = onTap == null ? card : PressableScale(child: card);
    return semanticLabel == null
        ? wrapped
        : Semantics(
            button: onTap != null,
            label: semanticLabel,
            child: wrapped,
          );
  }
}

/// Scales its child to [AppMotion.pressScale] while pressed.
class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child});
  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? AppMotion.pressScale : 1,
        duration: AppMotion.of(context, AppMotion.fast),
        curve: AppMotion.enter,
        child: widget.child,
      ),
    );
  }
}

/// Section title with an optional trailing action ("عرض الكل").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Space.vm),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.title())),
          ?trailing,
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.brand,
                padding: EdgeInsets.symmetric(horizontal: Space.s),
                minimumSize: Size(AppSizes.touch, AppSizes.touch * 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppText.label(color: ColorManager.brand),
                  ),
                  const Icon(AppIcons.chevron, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Small icon in a tinted rounded square — used for meta rows and list leads.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    required this.icon,
    this.color = ColorManager.brand,
    this.size = 36,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

/// Icon + text meta line (time, date, location, points…).
class MetaItem extends StatelessWidget {
  const MetaItem({
    super.key,
    required this.icon,
    required this.text,
    this.color = ColorManager.inkMuted,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconS, color: ColorManager.inkFaint),
        SizedBox(width: Space.xs),
        Flexible(
          child: Text(
            text,
            style: getNumericStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
