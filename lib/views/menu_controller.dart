import 'package:flutter/material.dart';
import 'package:selfcarenotes/views/menus/add_record_page.dart';
import 'package:selfcarenotes/views/menus/clients_page.dart';
import 'package:selfcarenotes/views/menus/records_page.dart';
import 'package:selfcarenotes/views/menus/salon_manage_page.dart';
import 'package:selfcarenotes/views/menus/settings_page.dart';

class MenuManager extends StatefulWidget {
  const MenuManager({super.key});

  @override
  State<MenuManager> createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
  int _selectedIndex = 2;

  final List<Widget> _widgetOptions = <Widget>[
    const RecordsPage(),
    const SalonPage(),
    const AddRecordPage(),
    const ClientsPage(),
    const SettingsPage(),
  ];
  void click(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: click,
      ),
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (context) => _widgetOptions.elementAt(_selectedIndex));
        },
      ),
    );
  }
}
