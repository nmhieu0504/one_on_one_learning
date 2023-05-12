// ignore_for_file: avoid_debugPrint, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_learning/services/schedule_services.dart';
import 'package:one_on_one_learning/views/home_page/tutor_card_component.dart';
import 'package:one_on_one_learning/views/meeting_page/meeting_page.dart';
import '../../utils/ui_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFilter = false;
  bool _loading = true;
  bool _getMoreData = false;
  bool _isUpcoming = false;

  int _page = 1;
  final int _perPage = 10;
  late int _totalTimeLearn;

  bool _vietnameseTutorChip = false;
  bool _nativeTutorChip = false;
  bool _foreignTutorChip = false;

  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  Map<String, dynamic> _upComingInfo = {};

  final List<String> _specialtiesList = [
    'ALL',
    'business-english',
    'conversational-english',
    'english-for-kids',
    'ielts',
    'starters',
    'movers',
    'flyers',
    'ket',
    'pet',
    'toefl',
    'toeic'
  ];
  String _selectedSpecialties = 'ALL';

  final List<String> _nationalityTutorList = [
    "Vietnamese Tutor",
    "Foreign Tutor",
    "Native English Tutor"
  ];

  final List<TutorCard> _tutorList = [];
  final ScrollController _scrollController = ScrollController();

  Map<dynamic, dynamic> checkNationality() {
    if (_vietnameseTutorChip == _nativeTutorChip &&
        _nativeTutorChip == _foreignTutorChip) {
      return {};
    } else if (_vietnameseTutorChip) {
      if (_nativeTutorChip) {
        return {"isVietNamese": true, "isNative": true};
      } else {
        if (_foreignTutorChip) {
          return {"isNative": false};
        } else {
          return {"isVietNamese": true};
        }
      }
    } else if (!_vietnameseTutorChip) {
      if (_nativeTutorChip) {
        if (!_foreignTutorChip) {
          return {"isNative": true};
        } else {
          return {"isVietNamese": false};
        }
      } else {
        return {"isVietNamese": false, "isNative": false};
      }
    }
    return {};
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _getMoreData ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  String specialtiesUltis(String text) {
    if (!text.contains("-")) {
      return text.toUpperCase();
    }
    List<String> words = text.split("-");
    String result = "";
    for (String word in words) {
      result += "${word.substring(0, 1).toUpperCase()}${word.substring(1)} ";
    }
    return result.trim();
  }

  Widget _specialtiesFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: _specialtiesList.map((value) {
            return FilterChip(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(specialtiesUltis(value)),
              onSelected: (bool isSlected) {
                setState(() {
                  if (isSlected) {
                    _selectedSpecialties = value;
                  } else {
                    _selectedSpecialties = "";
                  }
                });
              },
              selected: _selectedSpecialties == value,
            );
          }).toList(),
        ));
  }

  Widget _nationalityTutorFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
            spacing: 10,
            children: _nationalityTutorList.map((value) {
              return FilterChip(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  label: Text(value),
                  onSelected: (bool isSlected) {
                    setState(() {
                      switch (value) {
                        case "Vietnamese Tutor":
                          _vietnameseTutorChip = isSlected;
                          break;
                        case "Native English Tutor":
                          _nativeTutorChip = isSlected;
                          break;
                        case "Foreign Tutor":
                          _foreignTutorChip = isSlected;
                          break;
                      }
                    });
                  },
                  selected: value == "Vietnamese Tutor"
                      ? _vietnameseTutorChip
                      : value == "Foreign Tutor"
                          ? _foreignTutorChip
                          : _nativeTutorChip);
            }).toList()));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _datePickerController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget _buildFilter() {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Text(
                "Tutor Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'Search',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(15),
                      width: 18,
                      child: Image.asset(UIData.searchIcon),
                    )),
              ),
            ),
          ),
          _nationalityTutorFilter(),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: const Text(
                "Select available tutoring time",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SizedBox(
              height: 40,
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                textAlign: TextAlign.center,
                controller: _datePickerController,
                onTap: () {
                  _selectDate(context);
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  hintText: "Pick a date",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                readOnly: true,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: const Text(
                "Specialties",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
          _specialtiesFilter(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSpecialties = "ALL";
                        _vietnameseTutorChip = false;
                        _nativeTutorChip = false;
                        _foreignTutorChip = false;
                        _datePickerController.text = "";
                        _selectedDate = null;
                        _searchController.text = "";
                      });
                    },
                    child: const Text(
                      'Reset Filter',
                    )),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: FilledButton(
                    onPressed: () {
                      _page = 1;
                      _tutorList.clear();
                      setState(() {
                        _isFilter = false;
                        _loading = true;
                      });
                      ScheduleServices.loadTutorList(
                              _selectedSpecialties,
                              _searchController.text,
                              checkNationality(),
                              _page++,
                              _perPage)
                          .then((value) {
                        setState(() {
                          _tutorList.addAll(
                              value.map((e) => TutorCard.fromJson(e)).toList());
                          _loading = false;
                        });
                      });
                    },
                    child: const Text(
                      'Apply',
                    )),
              ),
            ],
          )
        ]));
  }

  String _upcomingLessonTime() {
    debugPrint(
        "Start time: ${DateTime.fromMillisecondsSinceEpoch(_upComingInfo["startTimestamp"])}");
    debugPrint("End time: ${_upComingInfo["endTimestamp"]}");
    return "${DateFormat("EEE, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(_upComingInfo["startTimestamp"]))} ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(_upComingInfo["startTimestamp"]))} - ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(_upComingInfo["endTimestamp"]))}";
  }

  Widget _buildTutorList() {
    return ListView(controller: _scrollController, children: <Widget>[
      Container(
        color: Colors.purple[900],
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _isUpcoming
                          ? "Upcoming Lesson"
                          : "You have no upcoming lessons",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: _isUpcoming ? 30 : 24, color: Colors.white),
                    ),
                  ),
                  _isUpcoming
                      ? Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(_upcomingLessonTime(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white))),
                            Center(
                              child: CountdownTimer(
                                widgetBuilder: (_, CurrentRemainingTime? time) {
                                  if (time == null) return Container();
                                  String days = time.days == null
                                      ? "00"
                                      : time.days! < 10
                                          ? "0${time.days}"
                                          : "${time.days}";
                                  String hours = time.hours == null
                                      ? "00"
                                      : time.hours! < 10
                                          ? "0${time.hours}"
                                          : "${time.hours}";
                                  String min = time.min == null
                                      ? "00"
                                      : time.min! < 10
                                          ? "0${time.min}"
                                          : "${time.min}";
                                  String sec = time.sec == null
                                      ? "00"
                                      : time.sec! < 10
                                          ? "0${time.sec}"
                                          : "${time.sec}";
                                  return Text(
                                      '(Start in $days : $hours : $min : $sec)',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellow[300],
                                      ));
                                },
                                controller: CountdownTimerController(
                                    endTime: _upComingInfo["startTimestamp"]),
                                endTime: _upComingInfo["startTimestamp"],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsetsDirectional.symmetric(
                                  vertical: 10),
                              child: FilledButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return MeetingPage(
                                          roomNameOrUrl:
                                              _upComingInfo["roomNameOrUrl"],
                                        );
                                      }),
                                    );
                                  },
                                  icon: const Icon(Icons.ondemand_video_sharp),
                                  label: const Text(
                                    'Enter lesson room',
                                  )),
                            )
                          ],
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: _totalTimeLearn == 0
                        ? const Text(
                            "Welcome to LetLearn!",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        : Text(
                            "Total lesson time: ${_totalTimeLearn ~/ 60} hours ${_totalTimeLearn % 60} minutes",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                  )
                ]),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'All Tutors',
              style:
                  TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _isFilter = true;
                  });
                },
                child: const Text('Filters >'))
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return index == _tutorList.length
              ? _buildProgressIndicator()
              : _tutorList[index];
        },
        itemCount: _tutorList.length + 1,
      ),
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ScheduleServices.loadNextScheduleData().then((value) {
      if (value == null) return;
      setState(() {
        _isUpcoming = true;
        _upComingInfo = value;
      });
    });
    ScheduleServices.getTotalTimeLearn().then((value) {
      setState(() {
        _totalTimeLearn = value;
      });
    });
    ScheduleServices.loadTutorList(_selectedSpecialties, _searchController.text,
            checkNationality(), _page++, _perPage)
        .then((value) {
      setState(() {
        _tutorList.addAll(value.map((e) => TutorCard.fromJson(e)).toList());
        _loading = false;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _getMoreData = true;
        });
        ScheduleServices.loadTutorList(_selectedSpecialties,
                _searchController.text, checkNationality(), _page++, _perPage)
            .then((value) {
          setState(() {
            _tutorList.addAll(value.map((e) => TutorCard.fromJson(e)).toList());
            _getMoreData = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _isFilter
            ? _buildFilter()
            : _buildTutorList();
  }
}
