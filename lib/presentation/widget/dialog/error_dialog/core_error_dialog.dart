import 'package:flutter/material.dart';

class CoreErrorDialog extends StatelessWidget {
  const CoreErrorDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonTitle,
  });

  final String title;
  final String message;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(buttonTitle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
