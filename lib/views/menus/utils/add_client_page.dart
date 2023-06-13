import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:selfcarenotes/views/menus/clients_page.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  late final User? user;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phoneNumber;

  /*void dbAdd() async {
    var map = <String, String?>{};
    for (int i = 0; i < clients.length; i++) {
      map[i.toString()] = clients[i].name;
      print(i);
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('userData')
        .doc('clients')
        .set(map);
  }*/

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _name = TextEditingController();
    _email = TextEditingController();
    _phoneNumber = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Opacity(
            opacity: 0.8,
            child: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              title: const Text(
                'Add Client',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 200,
                ),
                SizedBox(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: _name,
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
                      controller: _phoneNumber,
                      keyboardType: TextInputType.phone,
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
                const SizedBox(
                  height: 120,
                ),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextButton(
                      onPressed: () async {
                        final name = _name.text;
                        final email = _email.text;
                        final phone = _phoneNumber.text;
                        var map = <String, String?>{};
                        for (int i = 0; i < clients.length; i++) {
                          map[i.toString()] = clients[i].name;
                          print(i);
                        }
                        map[clients.length.toString()] = name;
                        print(clients.length.toString());
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('userData')
                            .doc('clients')
                            .set(map);
                        if (context.mounted) {
                          Navigator.of(context).pop(context);
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(160, 0, 0, 100),
                        ),
                      ),
                      child: const Text(
                        'Add',
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
