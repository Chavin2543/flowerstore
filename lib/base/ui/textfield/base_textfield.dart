import 'package:flutter/material.dart';

class BaseTextfield extends StatelessWidget {
  final Function(String) onTextChange;

  const BaseTextfield({
    required this.onTextChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: TextField(
        onChanged: (text) => onTextChange(text),
        style: Theme.of(context).textTheme.labelLarge,
        decoration: const InputDecoration(
          hintText: 'ค้นหาโรงแรม',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}
