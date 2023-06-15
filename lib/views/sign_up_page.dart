import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phone;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _phone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Register.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            Column(
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 60),
                    child: Container(
                      width: 180,
                      height: 180,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/images/Ditow logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: _name,
                      autocorrect: true,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        hintText: 'name',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: _email,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        hintText: 'email',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        hintText: 'password',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: _phone,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')),
                      ],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(255, 255, 255, 0.8),
                        hintText: 'phone',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextButton(
                      onPressed: () async {
                        final name = _name.text;
                        final email = _email.text;
                        final password = _password.text;
                        final phone = _phone.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          await userCredential.user?.updateDisplayName(name);
                          final user = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .set({});
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('userData')
                              .doc('data')
                              .set({'phone': phone});
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'weak-password':
                              print('Password is weak');
                              break;
                            case 'email-already-in-use':
                              print('Email already exists');
                              break;
                            case 'invalid-email':
                              print('Wrong email format');
                              break;
                          }
                        }
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home/',
                            (route) => false,
                          );
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(223, 195, 194, 1)),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight * 2.1,
                ),
                SizedBox(
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login/',
                          (route) => false,
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(223, 195, 194, 1)),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
