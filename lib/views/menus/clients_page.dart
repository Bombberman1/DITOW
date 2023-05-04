import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:selfcarenotes/views/menus/utils/add_client_page.dart';

class Client {
  final String? name;
  final String? email;
  Client(this.name, this.email);
}

final user = FirebaseAuth.instance.currentUser;

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late List<Client> clients = [];
  late List<Client> selectedUserList;

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
          var client = Client(data[i.toString()], 'test');
          clients.add(client);
        }
      },
      onError: (e) => print(e),
    );
  }

  void dbAdd() async {
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
  }

  @override
  void initState() {
    dbGet();
    selectedUserList = clients;
    super.initState();
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
        title: const Text('Clients'),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AddClientPage()),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openFilterDialog,
          child: const Icon(Icons.add),
        ),
        body: selectedUserList == null || selectedUserList.length == 0
            ? const Center(child: Text('No clients selected'))
            : ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedUserList[index].name!),
                  );
                },
                itemCount: selectedUserList.length,
              ),
      ),
    );
  }
}
