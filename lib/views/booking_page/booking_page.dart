// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_learning/services/schedule_services.dart';
import 'package:one_on_one_learning/services/tutor_services.dart';
import 'package:one_on_one_learning/services/user_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import '../../controllers/controller.dart';
import '../../models/user.dart';
import '../../services/utils_services.dart';
import 'package:get/get.dart';

class BookingPage extends StatefulWidget {
  final String tutorId;
  const BookingPage({super.key, required this.tutorId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Controller controller = Get.find();

  late User user;
  late int priceOfSession;
  bool _loading = true;

  final kToday = DateTime.now();
  late final kFirstDay = kToday;
  late final kLastDay = DateTime(kToday.year, 12, kToday.day);
  late ValueNotifier<List<Schedule>> _selectedEvents;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late LinkedHashMap<DateTime, List<Schedule>> kSchedules;

  final TextEditingController _noteController = TextEditingController();

  void _displaySuccessMotionToast(String str) {
    Get.snackbar(
      "",
      "",
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      duration: const Duration(milliseconds: 750),
      titleText: const Text("Ok",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      messageText: Text(str,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white)),
    );
  }

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

  List<Schedule> _getEventsForDay(DateTime day) {
    // Implementation example
    return kSchedules[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _loadData() {
    DateTime now = DateTime.now();

    TutorServices.getTutorSchedule(
            startTimestamp: DateTime(now.year, now.month, now.day, 0, 0, 0),
            endTimestamp:
                DateTime(now.year, now.month + 3, now.day, 23, 59, 59),
            tutorId: widget.tutorId)
        .then((value) {
      if (value == null) {
        return;
      }

      UserService.loadUserInfo().then((value) {
        setState(() {
          user = value;
        });
      });

      UtilsService.getSessionPrice().then((value) {
        setState(() {
          priceOfSession = value;
        });
      });

      setState(() {
        value
            .sort((a, b) => a['startTimestamp'].compareTo(b['startTimestamp']));

        Map<DateTime, List<Schedule>> kEventSource = {};
        for (var element in value) {
          DateTime startTimestamp =
              DateTime.fromMillisecondsSinceEpoch(element['startTimestamp']);
          DateTime endTimestamp =
              DateTime.fromMillisecondsSinceEpoch(element['endTimestamp']);
          DateTime date = DateTime(
              startTimestamp.year, startTimestamp.month, startTimestamp.day);

          String time =
              '${DateFormat.Hm().format(startTimestamp)} - ${DateFormat.Hm().format(endTimestamp)}';
          element['isBooked'] = DateTime.now().isAfter(startTimestamp)
              ? true
              : element['isBooked'];
          Schedule schedule = Schedule(
              time, element['isBooked'], element["scheduleDetailIds"],
              startTimestamp: startTimestamp.millisecondsSinceEpoch,
              endTimestamp: endTimestamp.millisecondsSinceEpoch);
          if (kEventSource.containsKey(date)) {
            kEventSource[date]!.add(schedule);
          } else {
            kEventSource[date] = [schedule];
          }
        }

        kSchedules = LinkedHashMap<DateTime, List<Schedule>>(
          equals: isSameDay,
          hashCode: getHashCode,
        )..addAll(kEventSource);
        _selectedDay = _focusedDay;
        _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

        _loading = false;
      });
    });
  }

  void _showBookingDialog(
      String scheduleDetailIds, int startTimestamp, int endTimestamp) {
    showDialog(
        context: context,
        builder: ((BuildContext context) => Center(
                child: AlertDialog(
              title: Text("booking_detail".tr),
              content: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(children: [
                      Row(children: [
                        Text(
                          'booking_time'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 50),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: controller.green_RGB_and_white.value,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                                "${DateFormat("EEE, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(startTimestamp))}  ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(startTimestamp))} - ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(endTimestamp))}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        controller.black_and_white_card.value,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                      )
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'balance'.tr,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Text("balance_left".trParams({
                              "balance":
                                  (int.parse(user.walletInfo["amount"]) ~/
                                          priceOfSession)
                                      .toString()
                            }))
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'price'.tr,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("1 ${'lesson'.tr}")
                          ]),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(children: [
                      Row(children: [
                        Text(
                          'note'.tr,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ]),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Theme(
                          data: ThemeData(
                            useMaterial3: true,
                            colorScheme: ColorScheme.fromSwatch().copyWith(
                              primary: controller.blue_700_and_white.value,
                              secondary: controller.black_and_white_text.value,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color:
                                        controller.black_and_white_text.value),
                              ),
                            ),
                          ),
                          child: TextField(
                            cursorColor: controller.blue_700_and_white.value,
                            style: TextStyle(
                                color: controller.black_and_white_text.value),
                            maxLines: 2,
                            controller: _noteController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color:
                                        controller.black_and_white_text.value,
                                    fontWeight: FontWeight.normal),
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'enter_note'.tr),
                          ),
                        ),
                      )
                    ]),
                  ),
                ]),
              ),
              actions: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: controller.green_RGB_and_white.value),
                  onPressed:
                      int.parse(user.walletInfo["amount"]) < priceOfSession
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              setState(() {
                                _loading = true;
                              });
                              ScheduleServices.bookAClass(
                                      scheduleDetailIds, _noteController.text)
                                  .then((value) {
                                _displaySuccessMotionToast('book_success'.tr);
                                _noteController.clear();
                                _loadData();
                                debugPrint("BOOKED");
                              });
                            },
                  icon: Icon(Icons.keyboard_double_arrow_right_outlined,
                      color: controller.black_and_white_card.value),
                  label: Text("book_lesson".tr,
                      style: TextStyle(
                          color: controller.black_and_white_card.value)),
                ),
                OutlinedButton(
                  child: Text(
                    "cancel".tr,
                    style:
                        TextStyle(color: controller.blue_700_and_white.value),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _noteController.clear();
                  },
                ),
              ],
            ))));
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('booking'.tr),
      ),
      body: _loading
          ? Center(
              child: Obx(() => CircularProgressIndicator(
                  color: controller.blue_700_and_white.value)),
            )
          : Column(
              children: [
                TableCalendar<Schedule>(
                  locale: controller.isEnglish ? 'en_US' : 'vi_VN',
                  calendarBuilders:
                      CalendarBuilders(markerBuilder: (context, day, events) {
                    if (events.isEmpty) {
                      return Container();
                    }
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      width: 7.0,
                      height: 7.0,
                    );
                  }),
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: RangeSelectionMode.disabled,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
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
                  child: ValueListenableBuilder<List<Schedule>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 66, 218, 93)),
                              onPressed: value[index].isBooked
                                  ? null
                                  : () {
                                      _showBookingDialog(
                                          value[index].scheduleDetailIds,
                                          value[index].startTimestamp,
                                          value[index].endTimestamp);
                                    },
                              child: Text('${value[index]}',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/// Example event class.
class Schedule {
  final String title;
  final bool isBooked;
  final String scheduleDetailIds;
  final int startTimestamp;
  final int endTimestamp;
  const Schedule(this.title, this.isBooked, this.scheduleDetailIds,
      {required this.startTimestamp, required this.endTimestamp});

  @override
  String toString() => title;
}
