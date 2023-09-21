import 'package:flutter/material.dart';

class LearnSection extends StatelessWidget {
  const LearnSection(
      {super.key,
      required this.label,
      required this.onSeeAllClicked,
      required this.itemBuilder,
      required this.itemCount});

  final String label;
  final void Function() onSeeAllClicked;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.7),
            ),
            const Spacer(),
            TextButton(
              onPressed: onSeeAllClicked,
              child: const Text('See All',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600
              ),),
            )
          ],
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (context, index) => const SizedBox(
                    width: 16,
                  ),
              itemBuilder: itemBuilder),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
