import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'clients_page.dart';

var fireStore = FirebaseFirestore.instance;

class SalonPage extends StatefulWidget {
  const SalonPage({super.key});

  @override
  State<SalonPage> createState() => _SalonPageState();
}

class _SalonPageState extends State<SalonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Manage'),
      ),
      body: TextButton(
        onPressed: () {},
        child: const Text('Send to FireStore'),
      ),
    );
  }
}
