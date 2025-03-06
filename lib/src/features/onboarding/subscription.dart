import 'package:flutter/material.dart';
import 'package:miracle/src/features/home/home.dart';

class Subscription extends StatelessWidget {
  Subscription({Key? key}) : super(key: key);

  final features = [
    // 'Enjoy your first 3 days, it\'s free',
    'Cancel anytime from the app or Google Play',
    'Quotes you can\'t find anywhere else',
    'Categories for any situation',
    '3 days FREE trial! with Anna',
    'Only Rs 125.00/month, billed annually from Anna'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/img-5.png'),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Subscription Plan',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              for (String feature in features)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 16,
                  ),
                  child: Row(children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ]),
                ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '3 days free, then just Rs1,500/year',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.6,
                    40,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text('Continue'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Already a Member?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
