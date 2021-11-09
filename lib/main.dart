import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:question_kitchen/pages/folders_page.dart';
import 'package:question_kitchen/pages/login_page.dart';
import 'package:question_kitchen/pages/settings_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<User?> getFirebaseUser() async {
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  firebaseUser ??= await FirebaseAuth.instance.userChanges().first;

  return firebaseUser;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = await getFirebaseUser();
  if (user == null) {
    runApp(const MyApp(home: LoginPage()));
  } else {
    runApp(
      const MyApp(
        home: FoldersPage(),
      ),
    );
  }
}

class MyApp extends HookWidget {
  const MyApp({Key? key, required this.home}) : super(key: key);
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        settingsControllerProvider.overrideWithValue(
          SettingsController(),
        ),
      ],
      child: ScreenUtilInit(
        builder: () {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.montserratTextTheme(),
            ),
            home: home,
            routes: {
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
