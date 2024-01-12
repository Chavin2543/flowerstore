import 'package:flutter/material.dart';

class HeaderBillHistoryItem extends StatefulWidget {
  const HeaderBillHistoryItem( {Key? key}) : super(key: key);

  @override
  State<HeaderBillHistoryItem> createState() => _HeaderBillHistoryItemState();
}

class _HeaderBillHistoryItemState extends State<HeaderBillHistoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return MouseRegion(
          onHover: (event) => setState(() => _isHovered = true),
          onExit: (event) => setState(() => _isHovered = false),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: _isHovered ? Colors.grey : Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(
                        border: Border.all(),
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      "หมายเลขบิล",
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(
                        border: Border.all(),
                        color: Theme.of(context).colorScheme.secondary
                    ),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      "วันที่",
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(
                        border: Border.all(),
                        color: Theme.of(context).colorScheme.secondary
                    ),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      "ยอดรวม",
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
