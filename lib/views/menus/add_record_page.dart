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
  late final TextEditingController _date;

  void dbGet() async {
    clients = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('userData')
        .doc('clients')
        .get()
        .then(
      (doc) {
        final data = doc.data() as Map<String, dynamic>;
        for (int i = 0; i < data.length; i++) {
          var client = Client(data[i.toString()], data.values.elementAt(i));
          clients.add(client);
        }
      },
      onError: (e) => print(e),
    );
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    dbGet();
    selectedUserList = [];
    _date = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _date.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Record'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 200,
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
                        Color.fromARGB(80, 0, 0, 100),
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
                    controller: _date,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20.0),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color.fromARGB(80, 0, 0, 100),
                      hintText: 'date',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
