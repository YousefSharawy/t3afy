import 'package:flutter/material.dart';

class OverviewInfoCard extends StatelessWidget {
  const OverviewInfoCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}
