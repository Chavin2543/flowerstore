import 'package:flutter/material.dart';

class CompanySelectionDialog extends StatefulWidget {
  final Function(String) onSelect;
  const CompanySelectionDialog({Key? key, required this.onSelect})
      : super(key: key);

  @override
  CompanySelectionDialogState createState() => CompanySelectionDialogState();
}

class CompanySelectionDialogState extends State<CompanySelectionDialog> {
  String searchQuery = '';
  int hoveredIndex = -1;
  List<String> companies = ["Company 1", "Company 2", "Company 3", "Company 4"];

  @override
  Widget build(BuildContext context) {
    List<String> filteredCompany = companies
        .where((company) =>
            company.toLowerCase().contains(searchQuery.toLowerCase()) ||
            searchQuery.isEmpty)
        .toList();
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCompany.length,
              itemBuilder: (BuildContext context, int index) {
                return MouseRegion(
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = -1),
                  child: ListTile(
                    title: Text(companies[index]),
                    tileColor: hoveredIndex == index
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    onTap: () {
                      widget.onSelect(companies[index]);
                    },
                  ),
                );
              },
            ),
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
