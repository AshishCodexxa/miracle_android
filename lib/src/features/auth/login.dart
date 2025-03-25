import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:miracle/color.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/auth/signup.dart';
import 'package:miracle/src/features/home/forget_password.dart';
import 'package:miracle/src/features/home/main_screen.dart';
import 'package:miracle/src/features/onboarding/select_category.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/utils/sizeConfig.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:http/http.dart' as http;

class Login extends HookWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isObscureText = useState<bool>(true);
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final errorMessage = useState<String>('');
    final isLoading = useState<bool>(false);

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

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile', 'openid'],
      clientId: '894057546171-9okhku93sl9vvqqc5rcq17jlohd3k2ae.apps.googleusercontent.com',
    );

    Future<void> _handleSignOut() => _googleSignIn.signOut();

    Future<GoogleSignInAccount?> _handleSignIn() async {
      try {
        isLoading.value = true;
        GoogleSignInAccount? user = await _googleSignIn.signIn();

        if (user != null) {

          GoogleSignInAuthentication googleAuth = await user.authentication;

          String token = googleAuth.idToken ?? "";

          print("token $token");


          print("user $user");
          print("User Id: ${user.id}");
          print("User Email: ${user.email}");
          print("User Photo: ${user.photoUrl}");

          final response = await http.get(
            Uri.parse('https://admin.manifestmiracle.net/auth/google-callback?token=$token'),
            // body: {'token': token},
          );

          print("response.statusCode ${response.body}");

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            GetStorage().write(kAccessToken, responseData['user']['token']);
            GetStorage().write(kUserId, responseData['user']['id']);

            print("userExist ${responseData['userExist']}");


            if(responseData['userExist'] == 0){
              isLoading.value = false;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SelectCategory(),
              ));
            }
            else if(responseData['userExist'] == 1){
              isLoading.value = false;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ));
            }

            print('Logged in successfully');
          }
          else {
            isLoading.value = false;
            print('Login failed');
          }

        }
        else{
          isLoading.value = false;
          return null;
        }
        return user;
      } catch (error) {
        isLoading.value = false;
        print("Sign-In Error: $error");
        return null;
      }
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                          height: 130,
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
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                          color: Colors.grey,
                          height: 1,
                          width: 150,
                          child: const Text("HI")
                      ),
                      const Text("OR"),
                      Container(
                          color: Colors.grey,
                          height: 1,
                          width: 150,
                          child: const Text("HI")
                      ),


                    ],
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.05,
                    right: SizeConfig.screenWidth * 0.05,
                  ),
                  child: GestureDetector(
                    onTap: (){
                      _handleSignIn();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0, 111.37],
                          colors: [Color(0xFFA6D7F3), Color(0xff8458bb)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * .9,
                        maxWidth: MediaQuery.of(context).size.width * .9,
                        minHeight: 50.0,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: const AssetImage("assets/images/google.png"),
                            height: SizeConfig.screenHeight * 0.04,),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.02,
                            ),
                            child: const Text(
                              'Sign In with Google',
                              style: TextStyle(color: Colors.white, fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
          Visibility(
              visible: isLoading.value,
              child: const CircularProgressIndicator())
        ],
      ),
    );
  }
}
