import 'package:flutter/material.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class NoCollection extends StatelessWidget {
  const NoCollection({
    Key? key,
    required this.title,
    this.subTitle,
    this.btnLabel,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final String? subTitle;
  final String? btnLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const Image(
            image: AssetImage('assets/images/no-collection.png'),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (subTitle != null)
            Text(
              subTitle!,
              textAlign: TextAlign.center,
            ),
          const Spacer(),
          if (onPressed != null)
            GradientButton(
              onPressed: onPressed!,
              label: btnLabel!,
            ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
