import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:selfcarenotes/firebase_options.dart';
import 'package:selfcarenotes/views/log_in_page.dart';
import 'package:selfcarenotes/views/log_out_page.dart';
import 'package:selfcarenotes/views/menu_controller.dart';
import 'package:selfcarenotes/views/sign_up_page.dart';
import 'package:selfcarenotes/views/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'SelfCare-Notes',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Scaffold(
      body: HomePage(),
    ),
    routes: {
      '/home/': (context) => const HomePage(),
      '/login/': (context) => const LogInPage(),
      '/signup/': (context) => const SignUpPage(),
      '/verifyemail/': (context) => const VerifyEmailView(),
      '/logout/': (context) => const LogOutPage(),
      '/menucontroller/': (context) => const MenuManager(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if (user != null) {
              if (user.emailVerified) {
                print('User Verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LogInPage();
            }
            return const MenuManager();
          default:
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Register.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Scaffold(
                backgroundColor: Colors.transparent,
              ),
            );
        }
      },
    );
  }
}
