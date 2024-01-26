import 'package:flutter/material.dart';

class CoreOneInputResponse {
  CoreOneInputResponse({
    required this.input1,
  });

  final String input1;
}

class CoreOneInputDialog extends StatefulWidget {
  final Function(CoreOneInputResponse) onSubmit;
  final String title;
  final String input1Placeholder;
  final String primaryButtonTitle;
  final String secondaryButtonTitle;
  final String? prefillInput1;
  final bool autoFocus;

  const CoreOneInputDialog({
    super.key,
    required this.onSubmit,
    required this.title,
    required this.input1Placeholder,
    this.prefillInput1,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.autoFocus,
  });

  @override
  CoreOneInputDialogState createState() => CoreOneInputDialogState();
}

class CoreOneInputDialogState extends State<CoreOneInputDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController input1Controller = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String input1 = input1Controller.text;
      widget.onSubmit(
        CoreOneInputResponse(
          input1: input1,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.prefillInput1 != null) {
      input1Controller.text = widget.prefillInput1!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: input1Controller,
                decoration: InputDecoration(
                  labelText: widget.input1Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocus,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitForm,
          child: Text(
            widget.primaryButtonTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            widget.secondaryButtonTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
