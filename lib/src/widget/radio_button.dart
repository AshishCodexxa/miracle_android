import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  final Map<String, dynamic> items;
  final void Function(String key, dynamic value) onChanged;
  final dynamic initialValue;

  const RadioButton({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  String _selectedKey = '';

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.items.keys
        .firstWhere((key) => widget.items[key] == widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var key in widget.items.keys)
          ListTile(
            onTap: () {
              widget.onChanged(key, widget.items[key]);
              setState(() {
                _selectedKey = key;
              });
            },
            title: Text(key),
            trailing: _selectedKey == key
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  )
                : null,
          ),
      ],
    );
  }
}
