import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfcarenotes/views/menus/clients_page.dart';
import 'package:table_calendar/table_calendar.dart';

List<Client> clients = [];

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  late final User? user;
  late List<Client> selectedUserList;
  late final TextEditingController _service;
  late final TextEditingController _date;
  late final TextEditingController _phone;
  late final TextEditingController _email;

  void dbGet() async {
    clients = [];
    int numbers = 0;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('clients')
        .get()
        .then((value) {
      numbers = value.docs.length;
    });

    for (int i = 0; i < numbers; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('clients')
          .doc(i.toString())
          .get()
          .then(
        (doc) {
          final data = doc.data() as Map<String, dynamic>;
          var client = Client(data['name'], data['email'], data['phone']);
          clients.add(client);
        },
        onError: (e) => print(e),
      );
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    dbGet();
    selectedUserList = [];
    _service = TextEditingController();
    _date = TextEditingController();
    _phone = TextEditingController();
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _service.dispose();
    _date.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void openFilterDialog() async {
    await FilterListDialog.display<Client>(
      context,
      listData: clients,
      selectedListData: selectedUserList,
      choiceChipLabel: (client) => client!.name,
      validateSelectedItem: (clients, val) => clients!.contains(val),
      onItemSearch: (client, query) {
        return client.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (clients) {
        setState(() {
          selectedUserList = List.from(clients!);
        });
      },
    );
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
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Opacity(
            opacity: 0.8,
            child: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Add Record',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                SizedBox(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TextButton(
                      style: const ButtonStyle(
                        alignment: Alignment.centerLeft,
                        fixedSize: MaterialStatePropertyAll(Size(300, 61)),
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(0, 0, 100, 0.1),
                        ),
                      ),
                      onPressed: () {
                        openFilterDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          Text(
                            'clients',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Text(
                            'selected: ${selectedUserList.length}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
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
                      controller: _service,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(0, 0, 100, 0.1),
                        hintText: 'service',
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
                      controller: _date,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(0, 0, 100, 0.1),
                        hintText: 'date',
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
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromRGBO(0, 0, 100, 0.1),
                        hintText: 'phone',
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
                        fillColor: Color.fromRGBO(0, 0, 100, 0.1),
                        hintText: 'email',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextButton(
                      onPressed: () async {
                        final service = _service.text;
                        final date = _date.text;
                        final phone = _phone.text;
                        final email = _email.text;
                        var map = <String, String?>{};
                        int numbers = 0;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('records')
                            .get()
                            .then((value) {
                          numbers = value.docs.length;
                          print(numbers);
                        });

                        map['name'] = selectedUserList[0].name;
                        map['service'] = service;
                        map['time'] = date;
                        map['phone'] = phone;
                        map['email'] = email;
                        map['price'] = '200';
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('records')
                            .doc(numbers.toString())
                            .set(map);
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(223, 195, 194, 1)),
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
