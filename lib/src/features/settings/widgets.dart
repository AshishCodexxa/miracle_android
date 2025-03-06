import 'package:flutter/material.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/features/onboarding/widget_info.dart';
import 'package:miracle/src/widget/radio_button.dart';

class Widgets extends StatelessWidget {
  Widgets({Key? key}) : super(key: key);

  final widgetSize = <String, dynamic>{
    'Small': 'small',
    'Medium': 'medium',
    'Large': 'large'
  };
  final widgetUpdate = <String, dynamic>{
    'Never': 0,
    'Once a day': 1,
    'Every 12 hours': 2,
    'Every 6 hours': 4,
    'Every 1 hour': 24,
    'Every 30 minutes': 48,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Widgets',
        style: TextStyle(
          color: Colors.white
        ),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WidgetInfo(),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline))
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select the text size of the widget',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          RadioButton(
            initialValue: 'small',
            items: widgetSize,
            onChanged: (key, value) {},
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Set how often the widget will update',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          RadioButton(
            initialValue: 2,
            items: widgetUpdate,
            onChanged: (key, value) {},
          ),
        ],
      ),
    );
  }
}
