import 'package:flutter/material.dart';
import 'package:miracle/src/widget/wheel_input.dart';

class InputCard extends StatelessWidget {
  final String heading;
  final List<String> options;
  final String initialValue;
  final void Function(int index, String value) onValueChanged;

  const InputCard({
    Key? key,
    required this.heading,
    required this.options,
    required this.onValueChanged,
    this.initialValue = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 8),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            //set border radius more than 50% of height and width to make circle
          ),
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                heading,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontFamily: 'Roboto_Medium'
                ),
              ),
              WheelInput(
                options: options,
                initialValue: initialValue,
                onValueChanged: onValueChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
