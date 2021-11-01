import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/pages/folders_page.dart';
import 'package:question_kitchen/pages/questions_page.dart';
import 'package:question_kitchen/providers.dart';
class LandingPage extends HookWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useProvider(authProvider);
    final auth = FirebaseAuth.instance;
    return user.when(
      data: (user) {
        if (user != null) {
          return const FoldersPage();
        }
        return FlutterLogin(
          onSignup: (data) async {
            try {
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
                builder: (context) => const QuestionsPage(),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return Text(error.toString());
      },
    );
  }
}
