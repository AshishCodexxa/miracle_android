import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle/src/features/onboarding/select_category.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class Intro extends ConsumerWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Image(
                  image: AssetImage('assets/images/brand-logo.png'),
                ),
              ),
              const Spacer(flex: 1),
              Text(
                'Self Care.\nSelf Love.\nSelf Growth.',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              GradientButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectCategory(),
                    ),
                  );
                },
                label: 'Continue',
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
