import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/onboarding/select_category.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/utils/sizeConfig.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class SignUp extends HookWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isObscureText = useState<bool>(true);
    final errorName = useState<String>('');
    final errorEmail = useState<String>('');
    final errorPassword = useState<String>('');
    final nameTextController = useTextEditingController();
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();

    void save() {
      errorEmail.value = '';
      errorPassword.value = '';
      errorName.value = '';
      if (nameTextController.text.isEmpty) {
        errorName.value = 'The name field is required';
      }

      if (emailTextController.text.isEmpty) {
        errorEmail.value = 'The email field is required';
      }

      if (passwordTextController.text.isEmpty) {
        errorPassword.value = 'The password field is required';
      }

      if (errorEmail.value.isNotEmpty ||
          errorPassword.value.isNotEmpty ||
          errorName.value.isNotEmpty) return;

      final data = {
        'name': nameTextController.text,
        'email': emailTextController.text,
        'password': passwordTextController.text,
      };

      DioClient().signUp(data).then((value) {
        if (value == null) return;

        final data = value['data'] as Map<String, dynamic>;
        GetStorage().write(kAccessToken, data['token']);
        GetStorage().write(kUserId, data['id']);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SelectCategory(),
        ));
      }).onError((error, stackTrace) {
        if (error is DioError) {
          final errors = error.response?.data as Map<String, dynamic>;

          if (errors['errors']['name'] != null) {
            errorName.value = errors['errors']['name'][0];
          }
          if (errors['errors']['email'] != null) {
            errorEmail.value = errors['errors']['email'][0];
          }
          if (errors['errors']['password'] != null) {
            errorPassword.value = errors['errors']['password'][0];
          }
        }
      });
    }

    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color(0xFFA6D7F3).withAlpha(150),
              const Color(0xff8458bb).withAlpha(150),
            ],
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    'Miracle Manifest',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/brand-logo.png',
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: TextField(
                controller: nameTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Name',
                  errorText:
                      errorName.value.isNotEmpty ? errorName.value : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
              child: TextField(
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText:
                      errorEmail.value.isNotEmpty ? errorEmail.value : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: TextField(
                controller: passwordTextController,
                obscureText: isObscureText.value,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: errorPassword.value.isNotEmpty
                      ? errorPassword.value
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscureText.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      isObscureText.value = !isObscureText.value;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GradientButton(
              label: 'Sign Up',
              onPressed: save,
            ),
          ],
        ),
      ),
    );
  }
}
