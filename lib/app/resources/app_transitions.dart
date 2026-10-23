import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'tokens.dart';

/// Page factory for every route.
///
/// * Default: [MaterialPage] — the platform transition from the theme
///   (iOS: native slide + swipe-back; Android: [RiseFadePageTransitionsBuilder]).
/// * [fade]: a short crossfade for root switches (splash → onboarding → login
///   → a role's shell), where "forward" has no meaning.
Page<void> appPage({
  required LocalKey key,
  required Widget child,
  bool fade = false,
}) {
  if (!fade) return MaterialPage<void>(key: key, child: child);
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, _, child) {
      if (AppMotion.reduced(context)) return child;
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: AppMotion.enter),
        child: child,
      );
    },
  );
}

/// Theme page transitions: native Cupertino on Apple platforms (keeps the
/// edge swipe-back gesture), [RiseFadePageTransitionsBuilder] elsewhere.
const appPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: RiseFadePageTransitionsBuilder(),
    TargetPlatform.fuchsia: RiseFadePageTransitionsBuilder(),
    TargetPlatform.linux: RiseFadePageTransitionsBuilder(),
    TargetPlatform.windows: RiseFadePageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
  },
);

/// Short directional push: the new screen fades in while sliding 6% from the
/// reading-start side (left in RTL); the old one drifts 3% away.
/// Transform + opacity only — no layout or clipping work per frame. The page
/// already sits behind the route's own RepaintBoundary (ModalRoute wraps
/// `buildPage` in one), so each frame only re-composites a cached layer, and
/// FadeTransition adds no layer once opacity reaches 1.
class RiseFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const RiseFadePageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AppMotion.reduced(context)) return child;
    final dir = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
    final enter = CurvedAnimation(
      parent: animation,
      curve: AppMotion.enter,
      reverseCurve: AppMotion.exit,
    );
    final leave = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AppMotion.enter,
      reverseCurve: AppMotion.exit,
    );
    return SlideTransition(
      position: Tween(
        begin: Offset.zero,
        end: Offset(-0.03 * dir, 0),
      ).animate(leave),
      child: SlideTransition(
        position: Tween(
          begin: Offset(0.06 * dir, 0),
          end: Offset.zero,
        ).animate(enter),
        child: FadeTransition(opacity: enter, child: child),
      ),
    );
  }
}

/// Tab container for [StatefulShellRoute]: keeps every branch alive (state,
/// scroll position) like `indexedStack`, but the newly selected tab fades in
/// with a small upward rise (220 ms).
///
/// Performance: hidden branches are Offstage (not painted) with tickers off,
/// so only one screen is ever drawn; each branch sits behind a
/// [RepaintBoundary]; the animation is opacity + translate only.
class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() =>
      _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: 1,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
  );
  // Starts at 35% (not 0) so the new tab is visible from the first frame —
  // a full 0→1 fade read as a blank "blink" between tabs.
  late final Animation<double> _fade = Tween(
    begin: 0.35,
    end: 1.0,
  ).animate(_curve);
  late final Animation<Offset> _rise = Tween(
    begin: const Offset(0, 0.015),
    end: Offset.zero,
  ).animate(_curve);

  @override
  void didUpdateWidget(AnimatedBranchContainer old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      if (AppMotion.reduced(context)) {
        _controller.value = 1;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          _branch(i, widget.children[i]),
      ],
    );
  }

  // The wrapper structure is identical for every branch and every frame so
  // switching tabs never rebuilds (or loses state of) a branch subtree.
  Widget _branch(int i, Widget child) {
    final active = i == widget.currentIndex;
    return Offstage(
      offstage: !active,
      child: TickerMode(
        enabled: active,
        child: FadeTransition(
          opacity: active ? _fade : kAlwaysCompleteAnimation,
          child: SlideTransition(
            position: active ? _rise : const AlwaysStoppedAnimation(Offset.zero),
            child: RepaintBoundary(child: child),
          ),
        ),
      ),
    );
  }
}
