import 'package:flowerstore/domain/entity/mainmenu_type.dart';
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
  MainMenuItemState createState() => MainMenuItemState();
}

class MainMenuItemState extends State<MainMenuItem> {
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
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.secondary),
              color: !_isHovering
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
                  size: MediaQuery.of(context).size.width * 0.05,
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
