import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/auth/login.dart';

import 'package:miracle/src/utils/sizeConfig.dart';
import 'package:miracle/src/widget/gradient_button.dart';

class ConfrimPassword extends HookWidget {
  const ConfrimPassword({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    final isObscureText = useState<bool>(true);
    final passwordController = useTextEditingController();
    final confirmpasswordTextController = useTextEditingController();
    final errorMessage = useState<String>('');

    void save() {
      errorMessage.value = '';
      final data = {
        'email': email,
        'password': passwordController.text,
      };

      DioClient().confirmPassword(data).then((value) {
        final data = value as Map<String, dynamic>;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully.'),
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Login()));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    onDoubleTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Container(
                        padding: const EdgeInsets.only(top: 24),
                        child: const Icon(Icons.arrow_back_ios,
                            size: 25, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5.0,
                          fontFamily: 'Roboto_Medium',
                          fontWeight: FontWeight.w400,
                          color: Colors.transparent),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 12,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
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
                          'Reset Password',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 32),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            errorText: errorMessage.value.isEmpty
                                ? null
                                : errorMessage.value,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: confirmpasswordTextController,
                        obscureText: isObscureText.value,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
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

/*                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgetPassword()));

                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
*/
                      const SizedBox(
                        height: 16,
                      ),
                      GradientButton(
                        label: 'Update',
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
