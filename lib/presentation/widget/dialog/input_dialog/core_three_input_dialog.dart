import 'package:flutter/material.dart';

enum ThreeAutoFocusPosition {
  one,
  two,
  three,
}

class CoreThreeInputResponse {
  CoreThreeInputResponse({
    required this.input1,
    required this.input2,
    required this.input3,
  });

  final String input1;
  final String input2;
  final String input3;
}

class CoreThreeInputDialog extends StatefulWidget {
  final Function(CoreThreeInputResponse) onSubmit;
  final String title;
  final String input1Placeholder;
  final String? prefillInput1;
  final String input2Placeholder;
  final String? prefillInput2;
  final String input3Placeholder;
  final String? prefillInput3;
  final String primaryButtonTitle;
  final String secondaryButtonTitle;
  final ThreeAutoFocusPosition autoFocusPosition;

  const CoreThreeInputDialog({
    super.key,
    required this.onSubmit,
    required this.title,
    required this.input1Placeholder,
    this.prefillInput1,
    required this.input2Placeholder,
    this.prefillInput2,
    required this.input3Placeholder,
    this.prefillInput3,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.autoFocusPosition,
  });

  @override
  CoreThreeInputDialogState createState() => CoreThreeInputDialogState();
}

class CoreThreeInputDialogState extends State<CoreThreeInputDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController input1Controller = TextEditingController();
  TextEditingController input2Controller = TextEditingController();
  TextEditingController input3Controller = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String input1 = input1Controller.text;
      String input2 = input2Controller.text;
      String input3 = input3Controller.text;

      Navigator.of(context).pop();
      await Future.delayed(const Duration(milliseconds: 300));

      widget.onSubmit(
        CoreThreeInputResponse(
          input1: input1,
          input2: input2,
          input3: input3,
        ),
      );
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
    if (widget.prefillInput3 != null) {
      input3Controller.text = widget.prefillInput3!;
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
                autofocus: widget.autoFocusPosition == ThreeAutoFocusPosition.one,
              ),
              TextField(
                controller: input2Controller,
                decoration: InputDecoration(
                  labelText: widget.input2Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocusPosition == ThreeAutoFocusPosition.two,
              ),
              TextField(
                controller: input3Controller,
                decoration: InputDecoration(
                  labelText: widget.input3Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocusPosition == ThreeAutoFocusPosition.three,
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
