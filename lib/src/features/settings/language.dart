import 'package:flutter/material.dart';
import 'package:miracle/src/widget/radio_button.dart';

class Language extends StatelessWidget {
  Language({Key? key}) : super(key: key);

  final systemLanguage = {
    'English': 'en',
    'Spanish': 'es',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Deutsche': 'de',
    'French': 'f',
    'Chinese': 'ch',
    'Japanese': 'jn',
    'Korean': 'kr',
    'Russian': 'rs',
    'Arabic': 'ar',
    'Dutch': 'du',
    'Swedish': 'sw',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Language'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          RadioButton(
            items: systemLanguage,
            initialValue: 'English',
            onChanged: (key, value) {},
          ),
        ],
      ),
    );
  }
}
