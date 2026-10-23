import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'objective_field.dart';

class SupplyField extends StatelessWidget {
  const SupplyField({
    super.key,
    required this.nameController,
    required this.quantityController,
    required this.onRemove,
    required this.index,
  });

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final VoidCallback onRemove;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Space.vs),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PrimaryTextFF(controller: nameController, hint: 'اسم المستلزم'),
          ),
          SizedBox(width: Space.s),
          Expanded(
            child: PrimaryTextFF(
              controller: quantityController,
              hint: 'الكمية',
              keyboardType: TextInputType.number,
            ),
          ),
          RemoveFieldButton(onPressed: onRemove),
        ],
      ),
    );
  }
}
