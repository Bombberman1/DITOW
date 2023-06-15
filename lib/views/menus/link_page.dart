import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'clients_page.dart';

var fireStore = FirebaseFirestore.instance;

class SalonPage extends StatefulWidget {
  const SalonPage({super.key});

  @override
  State<SalonPage> createState() => _SalonPageState();
}

class _SalonPageState extends State<SalonPage> {
  late final linkUrl = 'https://selfcare-notes/Pd8khriHqyc';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/AfterRegisterBackground.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Opacity(
            opacity: 0.8,
            child: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Link',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: kTextTabBarHeight * 2),
              Container(
                width: 180,
                height: 180,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/Ditow logo.png'),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 340,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 100, 0.1),
                    border: Border.all(
                      width: 2,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    borderRadius: BorderRadiusDirectional.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SelectableText(
                        linkUrl,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: linkUrl));
                        },
                        child: Text(
                          'Copy',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
