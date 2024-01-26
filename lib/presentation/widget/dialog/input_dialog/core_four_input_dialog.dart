import 'package:flutter/material.dart';

enum FourAutoFocusPosition {
  one,
  two,
  three,
  four
}

class CoreFourInputResponse {
  CoreFourInputResponse({
    required this.input1,
    required this.input2,
    required this.input3,
    required this.input4,
  });

  final String input1;
  final String input2;
  final String input3;
  final String input4;
}

class CoreFourInputDialog extends StatefulWidget {
  final Function(CoreFourInputResponse) onSubmit;
  final String title;
  final String input1Placeholder;
  final String? prefillInput1;
  final String input2Placeholder;
  final String? prefillInput2;
  final String input3Placeholder;
  final String? prefillInput3;
  final String input4Placeholder;
  final String? prefillInput4;
  final String primaryButtonTitle;
  final String secondaryButtonTitle;
  final FourAutoFocusPosition autoFocusPosition;

  const CoreFourInputDialog({
    super.key,
    required this.onSubmit,
    required this.title,
    required this.input1Placeholder,
    this.prefillInput1,
    required this.input2Placeholder,
    this.prefillInput2,
    required this.input3Placeholder,
    this.prefillInput3,
    required this.input4Placeholder,
    this.prefillInput4,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.autoFocusPosition,
  });

  @override
  CoreFourInputDialogState createState() => CoreFourInputDialogState();
}

class CoreFourInputDialogState extends State<CoreFourInputDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController input1Controller = TextEditingController();
  TextEditingController input2Controller = TextEditingController();
  TextEditingController input3Controller = TextEditingController();
  TextEditingController input4Controller = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String input1 = input1Controller.text;
      String input2 = input2Controller.text;
      String input3 = input3Controller.text;
      String input4 = input3Controller.text;
      widget.onSubmit(
        CoreFourInputResponse(
          input1: input1,
          input2: input2,
          input3: input3,
          input4: input4,
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
    if (widget.prefillInput3 != null) {
      input3Controller.text = widget.prefillInput3!;
    }
    if (widget.prefillInput4 != null) {
      input4Controller.text = widget.prefillInput4!;
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
                autofocus: widget.autoFocusPosition == FourAutoFocusPosition.one,
              ),
              TextField(
                controller: input2Controller,
                decoration: InputDecoration(
                  labelText: widget.input2Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocusPosition == FourAutoFocusPosition.two,
              ),
              TextField(
                controller: input3Controller,
                decoration: InputDecoration(
                  labelText: widget.input3Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocusPosition == FourAutoFocusPosition.three,
              ),
              TextField(
                controller: input4Controller,
                decoration: InputDecoration(
                  labelText: widget.input4Placeholder,
                ),
                onSubmitted: (_) => _submitForm(),
                autofocus: widget.autoFocusPosition == FourAutoFocusPosition.four,
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
