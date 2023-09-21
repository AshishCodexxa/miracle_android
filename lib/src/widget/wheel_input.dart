import 'package:flutter/material.dart';

class WheelInput extends StatefulWidget {
  const WheelInput({
    Key? key,
    required this.options,
    this.initialValue = '',
    required this.onValueChanged,
  }) : super(key: key);

  final List<String> options;
  final String initialValue;
  final void Function(int, String) onValueChanged;

  @override
  State<WheelInput> createState() => _WheelInputState();
}

class _WheelInputState extends State<WheelInput> {
  int _position = 0;
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNotEmpty) {
      _position = widget.options.indexOf(widget.initialValue);
    }
    controller = FixedExtentScrollController(initialItem: _position);
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

    final unselected = style?.copyWith(
      color: style.color?.withAlpha(150),
      fontWeight: FontWeight.w400,
    );
    return SizedBox(
      height: 60,
      width: 50,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 20,
        clipBehavior: Clip.antiAlias,
        magnification: 1,
        perspective: 0.01,
        controller: controller,
        physics: const BouncingScrollPhysics(),
        useMagnifier: true,
        onSelectedItemChanged: (value) {
          widget.onValueChanged(value, widget.options[value]);
          setState(() {
            _position = value;
          });
        },
        squeeze: 1.0,
        childDelegate: ListWheelChildListDelegate(
          children: List<Widget>.generate(
            widget.options.length,
            (index) => Text(
              widget.options[index],
              style: _position == index ? style : unselected,
            ),
          ),
        ),
      ),
    );
  }
}
