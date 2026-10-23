import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';

/// The standard loading → data contract for every screen.
///
/// * First load (no data yet): skeleton shaped like the content.
/// * Refresh with data on screen: data stays, a thin progress line shows on top
///   ([isRefreshing]). Never swap good data for a spinner.
/// * Error with no data: [ErrorState] with retry.
/// * Empty: [AppEmptyState] (give it an action when one exists).
///
/// Transitions between these crossfade (200 ms, disabled under reduced motion).
class AppAsyncBody extends StatelessWidget {
  const AppAsyncBody({
    super.key,
    required this.hasData,
    required this.builder,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.onRetry,
    this.isEmpty = false,
    this.empty,
    this.skeleton,
  });

  final bool hasData;
  final WidgetBuilder builder;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isEmpty;
  final Widget? empty;
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    final String key;
    if (hasData && !isEmpty) {
      key = 'data';
      child = Stack(
        children: [
          Positioned.fill(child: builder(context)),
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: RefreshingBar(visible: isRefreshing),
          ),
        ],
      );
    } else if (hasData && isEmpty) {
      key = 'empty';
      child = empty ?? const AppEmptyState(title: 'لا توجد بيانات بعد');
    } else if (errorMessage != null) {
      key = 'error';
      child = ErrorState(message: errorMessage!, onRetry: onRetry ?? () {});
    } else {
      key = 'loading';
      child = skeleton ?? const SkeletonList();
    }

    return AnimatedSwitcher(
      duration: AppMotion.of(context),
      switchInCurve: AppMotion.enter,
      switchOutCurve: AppMotion.exit,
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }
}

/// 2 px progress line shown while data on screen is being refreshed.
class RefreshingBar extends StatelessWidget {
  const RefreshingBar({super.key, required this.visible});
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.of(context, AppMotion.fast),
        child: const SizedBox(
          height: 2,
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: ColorManager.brand,
          ),
        ),
      ),
    );
  }
}
