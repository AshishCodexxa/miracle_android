import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key, required this.label, required this.onPressed});
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0, 111.37],
            colors: [Color(0xFFA6D7F3), Color(0xff8458bb)],
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * .9,
            maxWidth: MediaQuery.of(context).size.width * .9,
            minHeight: 50.0,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
