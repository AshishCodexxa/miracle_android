import 'package:flutter/material.dart';
import 'package:miracle/src/features/onboarding/select_category.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class WhatsName extends StatefulWidget {
  const WhatsName({Key? key}) : super(key: key);

  @override
  State<WhatsName> createState() => _WhatsNameState();
}

class _WhatsNameState extends State<WhatsName> {
  late TextEditingController nameTextController;

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.asset(
                'assets/images/img-1.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'What is your Name ?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  labelText: 'Your Name',
                ),
              ),
            ),
            const Spacer(),
            GradientButton(
              label: 'Continue',
              onPressed: () {
                if (nameTextController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name  is required'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectCategory(),
                ));
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectCategory(),
                ));
              },
              child: const Text(
                'Skip for now',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
