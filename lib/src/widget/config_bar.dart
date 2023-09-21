import 'package:flutter/material.dart';

class ConfigBar extends StatefulWidget {
  final bool isFullWidth;
  final List<Widget> items;
  final void Function(int index) onTap;
  final int selectedItem;

  const ConfigBar(
      {Key? key,
      required this.items,
      required this.onTap,
      this.isFullWidth = false,
      this.selectedItem = 0})
      : super(key: key);

  @override
  State<ConfigBar> createState() => _ConfigBarState();
}

class _ConfigBarState extends State<ConfigBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, maxHeight: 52),
      child: Row(
        mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: widget.isFullWidth
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.items.length; i++)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _selectedIndex = i;
                  widget.onTap(i);
                });
              },
              child: Opacity(
                opacity: _selectedIndex == i ? 1 : 0.4,
                child: SizedBox(
                  height: 48,
                  width: 62,
                  child: Center(
                    child: widget.items[i],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
