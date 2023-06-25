import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

User? user = FirebaseAuth.instance.currentUser;

class Event {
  final String clientName;
  final String phone;
  final String email;
  final DateTime time;
  final String service;
  final double price;

  const Event(this.clientName, this.phone, this.email, this.time, this.service,
      this.price);

  @override
  String toString() =>
      '$clientName    $phone    $service\n${time.day}.${time.month}.${time.year} ${time.hour}:${time.minute}';
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var kEvents = LinkedHashMap<DateTime, List<Event>>();

Map<DateTime, List<Event>> dataEvents = {};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  void dbGet() async {
    kEvents = LinkedHashMap<DateTime, List<Event>>();
    dataEvents = {};
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
    for (int i = 0; i < numbers; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('records')
          .doc(i.toString())
          .get()
          .then(
        (doc) {
          final data = doc.data() as Map<String, dynamic>;
          var event = Event(
              data['name'],
              data['phone'],
              data['email'],
              DateTime.parse(data['time']),
              data['service'],
              double.parse(data['price']));
          if (dataEvents[DateTime(
                  DateTime.parse(data['time']).year,
                  DateTime.parse(data['time']).month,
                  DateTime.parse(data['time']).day)] ==
              null) {
            dataEvents[DateTime(
                    DateTime.parse(data['time']).year,
                    DateTime.parse(data['time']).month,
                    DateTime.parse(data['time']).day)] =
                List.generate(1, (index) => event);
          } else if (dataEvents[DateTime(
                  DateTime.parse(data['time']).year,
                  DateTime.parse(data['time']).month,
                  DateTime.parse(data['time']).day)] !=
              null) {
            List<Event> list = [];
            for (Event obj in dataEvents[DateTime(
                DateTime.parse(data['time']).year,
                DateTime.parse(data['time']).month,
                DateTime.parse(data['time']).day)]!) {
              list.add(obj);
            }
            list.add(event);
            dataEvents[DateTime(
                DateTime.parse(data['time']).year,
                DateTime.parse(data['time']).month,
                DateTime.parse(data['time']).day)] = list;
          }
          kEvents = LinkedHashMap<DateTime, List<Event>>(
            equals: isSameDay,
            hashCode: getHashCode,
          )..addAll(dataEvents);
        },
        onError: (e) => print(e),
      );
    }
    setState(() {});
  }

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    dbGet();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
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
                'Records',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    itemCount: value.length,
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
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(16)),
                                          title: SelectableText(
                                            value[index].clientName,
                                          ),
                                          content: SizedBox(
                                            height: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SelectableText(
                                                  value[index].phone,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      value[index].email != ''
                                                          ? 20
                                                          : null,
                                                ),
                                                Container(
                                                  child: value[index].email !=
                                                          ''
                                                      ? SelectableText(
                                                          value[index].email,
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SelectableText(
                                                  DateFormat('dd.MM.yyyy HH:mm')
                                                      .format(
                                                    value[index].time,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SelectableText(
                                                  value[index].service,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                SelectableText(
                                                  '${value[index].price} UAH',
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(() {
                                                    const RecordsPage();
                                                  });
                                                },
                                                child: const Text(
                                                  'BACK',
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        223, 195, 194, 1),
                                                  ),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  },
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
                                            value[index].clientName,
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Text(
                                            value[index].phone,
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
                                            DateFormat('dd.MM.yyyy HH:mm')
                                                .format(
                                              value[index].time,
                                            ),
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color:
                                                Colors.black.withOpacity(0.6),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
