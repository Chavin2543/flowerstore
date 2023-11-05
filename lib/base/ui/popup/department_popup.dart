import 'package:flutter/material.dart';

class DepartmentSelectorButton extends StatelessWidget {
  final Function(String?) onSelect;

  const DepartmentSelectorButton({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final departments = ['HR', 'Engineering', 'Marketing', 'Sales'];

    return ElevatedButton(
      onPressed: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) {
            String? selectedDepartment = departments[0];

            return AlertDialog(
              title: Text('Select Department'),
              content: DropdownButton<String>(
                isExpanded: true,
                value: selectedDepartment,
                items: departments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDepartment = value;
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedDepartment);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        if (selected != null) {
          onSelect(selected);
        }
      },
      child: Text('Select Department'),
    );
  }
}
