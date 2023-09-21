import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/auth/signup.dart';
import 'package:miracle/src/features/home/forget_password.dart';
import 'package:miracle/src/features/home/main_screen.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/utils/sizeConfig.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class Login extends HookWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isObscureText = useState<bool>(true);
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final errorMessage = useState<String>('');

    void save() {
      errorMessage.value = '';
      final data = {
        'email': emailTextController.text,
        'password': passwordTextController.text,
      };
      DioClient().login(data).then((value) {
        if (value == null) return;

        final data = value['data'] as Map<String, dynamic>;

        GetStorage().write(kAccessToken, data['token']);

        GetStorage().write(kUserId, data['id']);

        print("user IDsss ${GetStorage().read(kUserId)}");


        GetStorage().write(kSelectedCategories, data['preferences']);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ));
      }).onError((error, stackTrace) {
        if (error is DioError) {
          final errors = error.response?.data as Map<String, dynamic>;

          if (errors['message'] != null) {
            errorMessage.value = errors['message'];
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
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText:
                      errorMessage.value.isEmpty ? null : errorMessage.value,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: TextField(
                controller: passwordTextController,
                obscureText: isObscureText.value,
                decoration: InputDecoration(
                  hintText: 'Password',
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPassword()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto-Regular',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GradientButton(
              label: 'Login',
              onPressed: save,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' Sign up',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: EDIT_ICON_COLOR,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Continue as Guest",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto-Regular',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
