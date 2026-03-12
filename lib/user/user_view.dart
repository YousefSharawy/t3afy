import 'package:flutter/material.dart';
import 'package:t3afy/base/components.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrimaryScaffold(body: Column(children: [Text("user")]));
  }
}
