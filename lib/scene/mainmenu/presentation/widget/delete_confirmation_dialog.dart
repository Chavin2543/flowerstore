import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String message;
  final Function onConfirm;

  DeleteConfirmationDialog({super.key, required this.message, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ยืนยันว่าจะลบ'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () => onConfirm(),
          child: const Text('ยืนยัน'),
        ),
      ],
    );
  }
}
