import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:question_kitchen/pages/folders_page.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onSignup: (data) async {
        try {
          final auth = FirebaseAuth.instance;
          await auth.createUserWithEmailAndPassword(
            email: data.name,
            password: data.password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-email') {
            return 'Invalid email address';
          } else if (e.code == 'weak-password') {
            return 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            return 'The account already exists for that email.';
          }
        }
        return null;
      },
      onLogin: (data) async {
        try {
          final auth = FirebaseAuth.instance;
          await auth.signInWithEmailAndPassword(
            email: data.name,
            password: data.password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-email') {
            return 'Invalid email address';
          } else if (e.code == 'user-not-found') {
            return 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            return 'Wrong password provided for that user.';
          }
          return 'Login failed!';
        }
        return null;
      },
      onRecoverPassword: (data) {},
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FoldersPage(),
          ),
        );
      },
      userValidator: MultiValidator(
        [
          RequiredValidator(errorText: 'This field is required'),
          EmailValidator(errorText: 'Enter a valid email address'),
        ],
      ),
      passwordValidator: RequiredValidator(errorText: 'This field is required'),
    );
  }
}
