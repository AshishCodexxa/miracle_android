import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:miracle/src/features/home/Confirm_password.dart';

import 'package:miracle/src/widget/gradient_button.dart';
import 'package:pinput/pinput.dart';

class GetOtpScreen extends HookWidget {
  const GetOtpScreen({
    Key? key,
    required this.otpCode,
    required this.email,
  }) : super(key: key);

  final String otpCode;
  final String email;

  @override
  Widget build(BuildContext context) {
    final isObscureText = useState<bool>(true);
    final emailTextController = useTextEditingController();
    final errorMessage = useState<String>('');

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black /* Color.fromRGBO(30, 60, 87, 1)*/,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.deepOrange),
      ),
    );
    final pinController = TextEditingController();
    final focusNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    var code = "";

    void save() {
      print("Otp---->$email");

      final userOtp = pinController.value.text.toString();
      if (userOtp == otpCode.replaceAll("(", "").replaceAll(")", "")) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ConfrimPassword(
                  email: email,
                )));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //         builder: (context) => const ConfrimPassword(sangharsh:email),)
        //     ));
      } else {
        _showToast(context);
      }
      // final data = {
      //   'email': emailTextController.text,
      //   /*'password': passwordTextController.text,*/
      // };
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => const ConfrimPassword()
      // ));

      /*  DioClient().ConfrimPassword(data).then((value) {
        if (value == null) return;

        final data = value['data'] as Map<String, dynamic>;

        //GetStorage().write(kAccessToken, data['token']);

       // GetStorage().write(kSelectedCategories, data['preferences']);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ConfrimPassword(),
        ));
      }).onError((error, stackTrace) {
        if (error is DioError) {
          final errors = error.response?.data as Map<String, dynamic>;

          if (errors['message'] != null) {
            errorMessage.value = errors['message'];
          }
        }
      });
*/
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
                          'Enter OTP',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 32),
                        ),
                      ),
                      //const Spacer(),
                      /*        Text(
                        'Sent To +91',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),*/
                      // const Spacer(),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 40, right: 20, left: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Directionality(
                                // Specify direction if desired
                                textDirection: TextDirection.ltr,

                                child: Pinput(
                                  length: 4,
                                  controller: pinController,
                                  focusNode: focusNode,
                                  onClipboardFound: (value) {
                                    debugPrint('onClipboardFound: $value');
                                    pinController.setText(value);
                                  },
                                  hapticFeedbackType:
                                      HapticFeedbackType.lightImpact,
                                  onCompleted: (pin) {
                                    debugPrint('onCompleted: $pin');
                                  },
                                  onChanged: (value) {
                                    debugPrint('onChanged: $value');
                                    code = value;
                                  },
                                  cursor: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 9),
                                        width: 20,
                                        height: 2,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  focusedPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                        defaultPinTheme.decoration!.copyWith(
                                      //  borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  submittedPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                        defaultPinTheme.decoration!.copyWith(
                                      // color: fillColor,
                                      //borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  errorPinTheme: defaultPinTheme.copyBorderWith(
                                    border: Border.all(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      GradientButton(
                        label: 'Confrim',
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text(
          'Enter valid OTP Number',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
