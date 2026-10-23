import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';

enum AppToastType { success, error, warning, info }

class AppToast {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String message,
    required AppToastType type,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AppToastWidget(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

class _AppToastWidget extends StatefulWidget {
  const _AppToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final AppToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  late final AnimationController _countdownCtrl;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _fade = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);

    _countdownCtrl = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideCtrl.forward();
    _countdownCtrl.forward();

    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _slideCtrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _countdownCtrl.dispose();
    super.dispose();
  }

  // Calm, consistent toast: Deep Root surface, meaning carried by the icon.
  (Color bg, Color border, Color icon, IconData iconData) get _theme {
    return switch (widget.type) {
      AppToastType.success => (
        ColorManager.ink,
        ColorManager.ink,
        ColorManager.sprout,
        Icons.check_circle_rounded,
      ),
      AppToastType.error => (
        ColorManager.ink,
        ColorManager.ink,
        const Color(0xFFFF8A80),
        Icons.error_rounded,
      ),
      AppToastType.warning => (
        ColorManager.ink,
        ColorManager.ink,
        ColorManager.star,
        Icons.warning_rounded,
      ),
      AppToastType.info => (
        ColorManager.ink,
        ColorManager.ink,
        ColorManager.primary200,
        Icons.info_rounded,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (bg, border, iconColor, iconData) = _theme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      bottom: bottomPadding + 80.h,
      left: 20.w,
      right: 20.w,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: bg.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 16.h),
                        child: Row(
                          children: [
                            Icon(iconData, color: iconColor, size: 22.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                widget.message,
                                style: getMediumStyle(
                                  fontSize: 13.sp,
                                  color: ColorManager.onInk,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _dismiss,
                              child: Padding(
                                padding: EdgeInsets.all(6.r),
                                child: Icon(
                                  Icons.close,
                                  color: ColorManager.onInkMuted,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _countdownCtrl,
                          builder: (_, _) {
                            return LayoutBuilder(
                              builder: (_, constraints) => Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  height: 2.sp,
                                  width:
                                      constraints.maxWidth *
                                      (1 - _countdownCtrl.value),
                                  color: ColorManager.onInkMuted,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
