import 'package:flutter/material.dart';

class CoreConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonTitle;
  final String secondaryButtonTitle;
  final Function onConfirm;

  const CoreConfirmDialog({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => onConfirm(),
          child: Text(
            primaryButtonTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            secondaryButtonTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
