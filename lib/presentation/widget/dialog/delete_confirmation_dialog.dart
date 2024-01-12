import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String message;
  final Function onConfirm;

  const DeleteConfirmationDialog(
      {super.key, required this.message, required this.onConfirm});

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
          child: Text(
            'ยกเลิก',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: () => onConfirm(),
          child: Text(
            'ยืนยัน',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
