import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:miracle/src/data/network/dio_client.dart';

import 'package:miracle/src/features/home/getOtp.dart';

import 'package:miracle/src/widget/gradient_button.dart';

class ForgetPassword extends HookWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final isObscureText = useState<bool>(true);
    final emailTextController = useTextEditingController();
    final errorMessage = useState<String>('');
    final isLoading = useState<bool>(false);

    void save() {
      errorMessage.value = '';
      final data = {
        'email': emailTextController.text,
        /*'password': passwordTextController.text,*/
      };
      print("email---->${emailTextController.value.text}");

      DioClient().sendOtp(data).then((value) {
        if (value == null) return;

        final data = value['data'] as Map<String, dynamic>;
        if (isLoading.value) {
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GetOtpScreen(
                  otpCode: data.values.toString(),
                  email: emailTextController.value.text.toString(),
                )));
      }).onError((error, stackTrace) {
        if (!isLoading.value) if (error is DioError) {
          final errors = error.response?.data as Map<String, dynamic>;
          if (errors['message'] != null) {
            errorMessage.value = errors['message'];
          }
        }
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: .3,
                  child: Image.asset('assets/images/brand-logo.png'),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 112),
                        child: Text(
                          'Forgot Password',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextField(
                          controller: emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            errorText: errorMessage.value.isEmpty
                                ? null
                                : errorMessage.value,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GradientButton(
                        label: 'Send Otp',
                        onPressed: save,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
