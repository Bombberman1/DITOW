import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late TextEditingController _service;
  DateTime dateTime = DateTime.now();
  late final dateToday = DateTime.now();
  late TextEditingController _phone;
  late TextEditingController _email;

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
    dateTime = DateTime.now();
    _phone = TextEditingController();
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _service.dispose();
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
        Navigator.of(context, rootNavigator: true).pop(() {
          const AddRecordPage();
        });
      },
      enableOnlySingleSelection: true,
      themeData: FilterListThemeData.light(context).copyWith(
        choiceChipTheme: ChoiceChipThemeData.light(context).copyWith(
          selectedBackgroundColor: const Color.fromRGBO(223, 195, 194, 1),
        ),
        controlBarButtonTheme:
            ControlButtonBarThemeData.light(context).copyWith(
          controlButtonTheme: const ControlButtonThemeData(
            textStyle: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(223, 195, 194, 1),
            ),
            primaryButtonBackgroundColor: Color.fromRGBO(223, 195, 194, 1),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> chooseDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(
          DateTime.now().year,
          DateTime.now().month + 3,
          DateTime.now().day,
        ),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                    primary: Color.fromRGBO(223, 195, 194, 1),
                    onPrimary: Colors.white,
                    onSurface: Colors.black),
                dialogTheme: const DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              child: child!);
        },
      );

  Future<TimeOfDay?> chooseTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute,
        ),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(223, 195, 194, 1),
                ),
              ),
            ),
            child: TimePickerTheme(
              data: TimePickerThemeData(
                hourMinuteShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  side: BorderSide(
                      color: Color.fromRGBO(223, 195, 194, 1), width: 4),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                hourMinuteColor: MaterialStateColor.resolveWith(
                  (states) => states.contains(MaterialState.selected)
                      ? Colors.white
                      : const Color.fromRGBO(223, 195, 194, 1),
                ),
                hourMinuteTextColor: MaterialStateColor.resolveWith(
                  (states) => states.contains(MaterialState.selected)
                      ? const Color.fromRGBO(223, 195, 194, 1)
                      : Colors.white,
                ),
                dialHandColor: const Color.fromRGBO(223, 195, 194, 1),
              ),
              child: child!,
            ),
          );
        },
      );

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
                          const SizedBox(
                            width: 10,
                          ),
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
                          const Spacer(),
                          Text(
                            'selected: ${selectedUserList.length}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
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
                    child: TextButton(
                      style: const ButtonStyle(
                        alignment: Alignment.centerLeft,
                        fixedSize: MaterialStatePropertyAll(Size(300, 61)),
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(0, 0, 100, 0.1),
                        ),
                      ),
                      onPressed: () async {
                        final date = await chooseDate();
                        if (date == null) return;
                        final time = await chooseTime();
                        if (time == null) return;
                        final newDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                        setState(() {
                          dateTime = newDateTime;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            'date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dateTime.month == dateToday.month &&
                                    dateTime.day == dateToday.day &&
                                    dateTime.hour == dateToday.hour &&
                                    dateTime.minute == dateToday.minute
                                ? ''
                                : DateFormat('dd.MM.yyyy HH:mm')
                                    .format(dateTime),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
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

                        if (selectedUserList.isEmpty ||
                            service.isEmpty ||
                            (dateTime.month == dateToday.month &&
                                dateTime.day == dateToday.day &&
                                dateTime.hour == dateToday.hour &&
                                dateTime.minute == dateToday.minute) ||
                            phone.isEmpty) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 50.0,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Error Occurred!',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Field is empty',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                                duration: const Duration(
                                  seconds: 2,
                                ),
                              ),
                            );
                          }
                          return;
                        }

                        map['name'] = selectedUserList[0].name;
                        map['service'] = service;
                        map['time'] =
                            DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                        map['phone'] = phone;
                        map['email'] = email;
                        map['price'] = '200';
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('records')
                            .doc(numbers.toString())
                            .set(map);
                        setState(() {
                          selectedUserList = [];
                          _service = TextEditingController();
                          dateTime = dateToday;
                          _phone = TextEditingController();
                          _email = TextEditingController();
                        });
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
