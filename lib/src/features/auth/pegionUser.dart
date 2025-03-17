import 'package:firebase_auth/firebase_auth.dart';

class PigeonUserDetails {
  final String uid;
  final String email;
  final String name;

  PigeonUserDetails({required this.uid, required this.email, required this.name});
}

// Convert Firebase User to PigeonUserDetails
PigeonUserDetails convertToPigeonUser(User user) {
  return PigeonUserDetails(
    uid: user.uid,
    email: user.email ?? "",
    name: user.displayName ?? "",
  );
}