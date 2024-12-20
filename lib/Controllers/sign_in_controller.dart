import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return "Email cannot be empty";
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }

  Future<String?> signIn() async {
    if (!formKey.currentState!.validate()) {
      return 'FormValidationError';
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user == null) {
        return 'Something went wrong. Please try again.';
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
