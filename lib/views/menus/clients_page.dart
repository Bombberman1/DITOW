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

List<Client> clients = [];

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.showList});

  final VoidCallback showList;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 200, 200, 200),
          boxShadow: List.filled(
            1,
            const BoxShadow(blurRadius: 3),
            growable: true,
          ),
        ),
        alignment: Alignment.center,
        width: 280,
        height: 40,
        child: TextButton(
          onPressed: showList,
          child: Row(
            children: const <Widget>[
              Icon(
                Icons.search,
                color: Colors.white,
              ),
              Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(280, 40);
}

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late final User? user;
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
          var client = Client(data[i.toString()], data.values.elementAt(i));
          clients.add(client);
        }
      },
      onError: (e) => print(e),
    );
  }

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
              centerTitle: true,
              backgroundColor: Colors.white,
              title: const Text(
                'Clients',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                                builder: (context) => const AddClientPage()),
                          )
                          .then((value) => setState(() {
                                dbGet();
                              }));
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight * 2),
            child: CustomAppBar(
              showList: () {
                openFilterDialog();
              },
            ),
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
      ),
    );
  }
}
