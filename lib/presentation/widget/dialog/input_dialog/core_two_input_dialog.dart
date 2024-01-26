import 'package:flutter/material.dart';

enum TwoAutoFocusPosition {
  one,
  two,
}

class CoreTwoInputResponse {
  CoreTwoInputResponse({
    required this.input1,
    required this.input2,
  });

  final String input1;
  final String input2;
}

class CoreTwoInputDialog extends StatefulWidget {
  final Function(CoreTwoInputResponse) onSubmit;
  final String title;
  final String input1Placeholder;
  final String? prefillInput1;
  final String input2Placeholder;
  final String? prefillInput2;
  final String primaryButtonTitle;
  final String secondaryButtonTitle;
  final TwoAutoFocusPosition autoFocusPosition;

  const CoreTwoInputDialog({
    super.key,
    required this.onSubmit,
    required this.title,
    required this.input1Placeholder,
    this.prefillInput1,
    required this.input2Placeholder,
    this.prefillInput2,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.autoFocusPosition,
  });

  @override
  CoreTwoInputDialogState createState() => CoreTwoInputDialogState();
}

class CoreTwoInputDialogState extends State<CoreTwoInputDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController input1Controller = TextEditingController();
  TextEditingController input2Controller = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String input1 = input1Controller.text;
      String input2 = input2Controller.text;
      widget.onSubmit(
        CoreTwoInputResponse(
          input1: input1,
          input2: input2,
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
    if (widget.prefillInput2 != null) {
      input2Controller.text = widget.prefillInput2!;
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
                autofocus: widget.autoFocusPosition == TwoAutoFocusPosition.one,
              ),
              TextField(
                controller: input2Controller,
                decoration: InputDecoration(
                  labelText: widget.input2Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocusPosition == TwoAutoFocusPosition.two,
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
