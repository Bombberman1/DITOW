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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 130,
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
                      fillColor: Color.fromARGB(80, 0, 0, 100),
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
                      fillColor: Color.fromARGB(80, 0, 0, 100),
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
                      fillColor: Color.fromARGB(80, 0, 0, 100),
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
                      fillColor: Color.fromARGB(80, 0, 0, 100),
                      hintText: 'phone',
                    ),
                  ),
                ),
              ),
              TextButton(
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
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (route) => false,
                  );
                },
                child: const Text('Registered ? Log In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
