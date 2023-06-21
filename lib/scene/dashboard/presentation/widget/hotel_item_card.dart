import 'package:flutter/material.dart';

class HotelItemCard extends StatefulWidget {
  final String name;
  final VoidCallback onTap;

  const HotelItemCard({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  _HotelItemCardState createState() => _HotelItemCardState();
}

class _HotelItemCardState extends State<HotelItemCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _isHovering ? Theme.of(context).colorScheme.surface : Colors.grey[300],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
