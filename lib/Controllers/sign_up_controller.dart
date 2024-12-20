import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_management_app/Models/firebase_db.dart';
import 'package:gift_management_app/Models/hedieaty_user.dart';
import 'package:gift_management_app/Models/local_db.dart';

class SignUpController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return "Name cannot be empty";
    }
    if (name.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  String? phoneValidator(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Phone number cannot be empty";
    }
    if (phone.length != 11) {
      return "Phone number must be 11 digits";
    }
    return null;
  }

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
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  Future<String?> signUp() async {
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
      final user = HedieatyUser(
        id: FirebaseAuth.instance.currentUser!.uid,
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
      );
      UserFirebaseDAO.insertUser(user);
      UserLocalDAO.insertUser(user);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
