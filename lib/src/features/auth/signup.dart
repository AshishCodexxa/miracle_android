import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/features/auth/google_auth.dart';
import 'package:miracle/src/features/home/main_screen.dart';
import 'package:miracle/src/features/onboarding/select_category.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:miracle/src/utils/sizeConfig.dart';
import 'package:miracle/src/widget/gradient_button.dart';
import 'package:http/http.dart' as http;

class SignUp extends HookWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isObscureText = useState<bool>(true);
    final isConObscureText = useState<bool>(true);
    final errorName = useState<String>('');
    final errorEmail = useState<String>('');
    final errorPassword = useState<String>('');
    final errorConfirmPassword = useState<String>('');
    final nameTextController = useTextEditingController();
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final conPasswordTextController = useTextEditingController();
    final isLoading = useState<bool>(false);

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

      if (conPasswordTextController.text.isEmpty) {
        errorConfirmPassword.value = 'The confirm password field is required';
      }

      if(passwordTextController.text != conPasswordTextController.text){
        errorConfirmPassword.value = 'The confirm password not matched';
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

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile', 'openid'],
      clientId: '894057546171-9okhku93sl9vvqqc5rcq17jlohd3k2ae.apps.googleusercontent.com',
    );

    Future<GoogleSignInAccount?> _handleSignIn() async {
      isLoading.value = true;
      try {
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
            Uri.parse('https://manifest.bizz-manager.com/auth/google-callback?token=$token'),
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
          } else {
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
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextField(
                    controller: conPasswordTextController,
                    obscureText: isConObscureText.value,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      errorText: errorConfirmPassword.value.isNotEmpty
                          ? errorConfirmPassword.value
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConObscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          isConObscureText.value = !isConObscureText.value;
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
                  height: 10,
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
                              'Sign Up with Google',
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


/*
final _auth = FirebaseAuth.instance;

Future<UserCredential?> loginWithGoogle() async {
  try{

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential cred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(cred);

  }catch (e){
    print("Error signing in with Google: $e");
    return null;
  }
}*/
