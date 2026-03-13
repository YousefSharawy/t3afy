import 'package:flutter/material.dart';

/// Centered loading indicator for BLoC loading states.
/// Use in content area only (e.g. inside Expanded), not over full scaffold.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF00ABD2),
        strokeWidth: 3,
      ),
    );
  }
}
