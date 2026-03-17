import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';

/// A centered empty-state message displayed when a list has no items.
class EmptyStateText extends StatelessWidget {
  const EmptyStateText({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: getMediumStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
