import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Defers a heavy subtree (maps, charts, large images) until the enclosing
/// route's push transition has finished, so the first animated frames only
/// build the light parts of the screen.
///
/// While the route animates, [placeholder] is shown (default: a sunken fill
/// that takes the parent's bounded size, or nothing when unbounded) — callers
/// keep the same height around it so nothing jumps. Then [child] crossfades in
/// over 150 ms. If there is no route animation, or it already completed (tab
/// branches, rebuilds, pops back), [child] is built immediately and the
/// wrapper adds nothing.
class AfterTransition extends StatefulWidget {
  const AfterTransition({super.key, required this.child, this.placeholder});

  final Widget child;
  final Widget? placeholder;

  @override
  State<AfterTransition> createState() => _AfterTransitionState();
}

class _AfterTransitionState extends State<AfterTransition> {
  Animation<double>? _route;
  bool _ready = false;
  // Decided on the first dependency pass and never changes, so the widget
  // structure (and the child's state) stays stable for the State's lifetime.
  bool? _deferred;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      _detach();
      _deferred ??= false;
      _ready = true;
      return;
    }
    _deferred ??= true;
    if (!identical(animation, _route)) {
      _detach();
      _route = animation..addStatusListener(_onStatus);
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    _detach();
    setState(() => _ready = true);
  }

  void _detach() {
    _route?.removeStatusListener(_onStatus);
    _route = null;
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_deferred == false) return widget.child;
    return AnimatedSwitcher(
      duration: AppMotion.of(context, const Duration(milliseconds: 150)),
      child: _ready
          ? KeyedSubtree(key: const ValueKey(true), child: widget.child)
          : KeyedSubtree(
              key: const ValueKey(false),
              child: widget.placeholder ?? const _DefaultPlaceholder(),
            ),
    );
  }
}

class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const LimitedBox(
      maxWidth: 0,
      maxHeight: 0,
      child: SizedBox.expand(
        child: ColoredBox(color: ColorManager.surfaceSunken),
      ),
    );
  }
}
