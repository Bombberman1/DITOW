import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:selfcarenotes/views/menus/utils/add_client_page.dart';

class Client {
  final String? name;
  final String? email;
  final String? phone;
  Client(this.name, this.email, this.phone);
}

List<Client> clients = [];

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.showList});

  final VoidCallback showList;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 280,
        height: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: TextButton(
            onPressed: showList,
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
              Color.fromRGBO(0, 0, 100, 0.2),
            )),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.black.withOpacity(0.6),
                ),
                Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
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
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  itemBuilder: (context, index) {
                    return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: 320,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: TextButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                  Color.fromRGBO(0, 0, 100, 0.1),
                                )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedUserList[index].name!,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          selectedUserList[index].phone!,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          selectedUserList[index].email!,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                  itemCount: selectedUserList.length,
                ),
        ),
      ),
    );
  }
}
