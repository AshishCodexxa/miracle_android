import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:miracle/src/features/auth/pegionUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

 getCurrentUser() async {
   print("_auth.currentUser ${_auth.currentUser}");
   return await _auth.currentUser;
 }


 /*signInWithGoogle() async {

   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   final GoogleSignIn googleSignIn = GoogleSignIn();

   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

   final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

   final AuthCredential credential = GoogleAuthProvider.credential(
     idToken: googleSignInAuthentication?.idToken,
     accessToken: googleSignInAuthentication?.accessToken
   );

   return firebaseAuth.signInWithCredential(credential);

 }*/

 signInWithGoogle() async {

   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   final GoogleSignIn googleSignIn = GoogleSignIn();
   User? user;

   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

   final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

   print("credentialcredential ${googleSignInAuthentication?.idToken}  \n ${googleSignInAuthentication?.accessToken}");

   final AuthCredential credential = GoogleAuthProvider.credential(
     idToken: googleSignInAuthentication?.idToken,
     accessToken: googleSignInAuthentication?.accessToken
   );

   try{
     final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
     user = userCredential.user;
     if (user != null) {
       PigeonUserDetails userDetails = convertToPigeonUser(user);
       print("Converted User Details: ${userDetails.uid}");
       print("User UID: ${user.uid}");
     } else {
       print("User sign-in failed.");
     }
   }catch (e){
     print("eeee $e");
   }

 }

}