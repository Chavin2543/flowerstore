import 'package:flutter/material.dart';

class CoreSelectionDialog extends StatefulWidget {
  final Function(String) onSelect;
  final List<String> items;
  final String title;
  final String searchHint;
  final String closeButtonTitle;
  final String? existingSelection;

  const CoreSelectionDialog({
    Key? key,
    required this.onSelect,
    required this.items,
    this.title = "เลือกสิ่งที่คุณต้องการ",
    this.searchHint = "ค้นหา",
    this.closeButtonTitle = "ปิด",
    this.existingSelection,
  }) : super(key: key);

  @override
  CoreSelectionDialogState createState() => CoreSelectionDialogState();
}

class CoreSelectionDialogState extends State<CoreSelectionDialog> {
  String searchQuery = '';
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<String> filteredItems = widget.items
        .where(
          (item) =>
              item.toLowerCase().contains(searchQuery.toLowerCase()) ||
              searchQuery.isEmpty,
        )
        .toList();
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: widget.searchHint,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
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
              itemCount: filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                return MouseRegion(
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = -1),
                  child: ListTile(
                    title: Text(filteredItems[index]),
                    tileColor: widget.existingSelection == filteredItems[index]  ? Colors.amberAccent : hoveredIndex == index
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    onTap: () {
                      widget.onSelect(filteredItems[index]);
                    },
                  ),
                );
              },
            ),
          ),
          TextButton(
            child: Text(widget.closeButtonTitle),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
