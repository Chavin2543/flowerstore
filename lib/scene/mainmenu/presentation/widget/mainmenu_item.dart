import 'package:flowerstore/scene/mainmenu/domain/entity/mainmenu_type.dart';
import 'package:flutter/material.dart';

class MainMenuItem extends StatefulWidget {
  final MainMenuType type;
  final VoidCallback onTap;

  const MainMenuItem({
    required this.type,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _MainMenuItemState createState() => _MainMenuItemState();
}

class _MainMenuItemState extends State<MainMenuItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: _isHovering
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.type.icon,
                  color: Colors.black,
                  size: 96,
                ),
                Text(
                  widget.type.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
