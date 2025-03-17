import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/di/app_module.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/widget/radio_button.dart';

class ThemeSetting extends ConsumerWidget {
  const ThemeSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,
            color: Colors.white,),
        ),
        backgroundColor: primaryColor,
        title: const Text('Dark Mode',
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          RadioButton(
            initialValue: ref.read(themeModeProvider.notifier).state,
            items: systemTheme,
            onChanged: (key, value) {
              ref.read(themeModeProvider.notifier).state = value;
              GetStorage().write(kActiveThemeMode, themeModes.indexOf(value));
            },
          ),
        ],
      ),
    );
  }
}
