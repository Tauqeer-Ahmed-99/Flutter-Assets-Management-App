import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Auth extends ChangeNotifier {
  final firebase = FirebaseAuth.instance;

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      await firebase.signInWithEmailAndPassword(
          email: email, password: password);

      // var message = "${res.user?.displayName}, Successfully logged in.";

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       message,
      //       style:
      //           GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      //     ),
      //     duration: const Duration(seconds: 3),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    } on FirebaseAuthException catch (error) {
      var errorMessage = "";
      switch (error.code) {
        case "invalid-credential":
          errorMessage = "Invalid Credentials";
          break;
        case "user-disabled":
          errorMessage = "This user has been banned";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "wrong-password":
          errorMessage = "Wrong password.";
          break;
        case "invalid-verification-code":
          errorMessage = "Invalid Verification code.";
          break;
        case "invalid-verification-id":
          errorMessage = "Invalid Verification id.";
          break;
        default:
          errorMessage = error.message as String;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  Future<void> signUp(BuildContext context, String email, String password,
      String userName) async {
    try {
      var res = await firebase.createUserWithEmailAndPassword(
          email: email, password: password);

      await res.user?.updateDisplayName(userName);

      // var message = "${res.user?.email}, created and logged in succsesful.";

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       message,
      //       style:
      //           GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      //     ),
      //     duration: const Duration(seconds: 3),
      //     backgroundColor: Colors.greenAccent,
      //   ),
      // );
    } on FirebaseAuthException catch (error) {
      var errorMessage = "";

      switch (error.code) {
        case "email-already-in-use":
          errorMessage = "User with this email already exists.";
          break;
        case "invalid-email":
          errorMessage = "Email is invalid.";
          break;
        case "operation-not-allowed":
          errorMessage = "Authentication with email and password is disabled.";
          break;
        case "weak-password":
          errorMessage = "Choose a strong password.";
          break;
        default:
          errorMessage = "Something went wrong! Try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await firebase.signOut();
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message as String,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }
}
