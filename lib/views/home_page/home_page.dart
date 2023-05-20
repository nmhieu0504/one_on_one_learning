// ignore_for_file: avoid_debugPrint, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_learning/controllers/controller.dart';
import 'package:one_on_one_learning/services/schedule_services.dart';
import 'package:one_on_one_learning/views/home_page/tutor_card_component.dart';
import 'package:one_on_one_learning/views/meeting_page/meeting_page.dart';
import '../../services/tutor_services.dart';
import '../../utils/ui_data.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Controller controller = Get.find();

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
    "vietnamese_tutor".tr,
    "foreign_tutor".tr,
    "english_tutor".tr
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
          child: const CircularProgressIndicator(
            color: Colors.blue,
          ),
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
            return Obx(() => FilterChip(
                  backgroundColor: controller.black_and_white_card.value,
                  selectedColor: controller.blue_100_and_blue_400.value,
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
                ));
          }).toList(),
        ));
  }

  Widget _nationalityTutorFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
            spacing: 10,
            children: _nationalityTutorList.asMap().entries.map((value) {
              return Obx(() => FilterChip(
                  backgroundColor: controller.black_and_white_card.value,
                  selectedColor: controller.blue_100_and_blue_400.value,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  label: Text(_nationalityTutorList[value.key]),
                  onSelected: (bool isSlected) {
                    setState(() {
                      switch (value.key) {
                        case 0:
                          _vietnameseTutorChip = isSlected;
                          break;
                        case 1:
                          _foreignTutorChip = isSlected;
                          break;
                        case 2:
                          _nativeTutorChip = isSlected;
                          break;
                      }
                    });
                  },
                  selected: value.key == 0
                      ? _vietnameseTutorChip
                      : value.key == 1
                          ? _foreignTutorChip
                          : _nativeTutorChip));
            }).toList()));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(now.year, 12, 31));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _datePickerController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget _buildFilter() {
    return Obx(() => Container(
          height: double.infinity,
          color: controller.black_and_white_card.value,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Text(
                      "tutor_name".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SizedBox(
                    height: 40,
                    child: Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: controller.blue_700_and_white.value,
                          secondary: controller.black_and_white_text.value,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: TextField(
                        cursorColor: controller.blue_700_and_white.value,
                        style: TextStyle(
                          color: controller.black_and_white_text.value,
                          decorationColor: controller.blue_700_and_white.value,
                        ),
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            hintText: 'search'.tr,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(15),
                              width: 18,
                              child: Image.asset(UIData.searchIcon,
                                  color: controller.black_and_white_text.value),
                            )),
                      ),
                    ),
                  ),
                ),
                _nationalityTutorFilter(),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      "available_time".tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SizedBox(
                    height: 40,
                    child: Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: controller.blue_700_and_white.value,
                          secondary: controller.black_and_white_text.value,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: controller.black_and_white_text.value,
                          decorationColor: controller.blue_700_and_white.value,
                        ),
                        cursorColor: controller.blue_700_and_white.value,
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.center,
                        controller: _datePickerController,
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_month_outlined,
                            color: controller.black_and_white_text.value,
                          ),
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          hintText: "pick_a_date".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      "specialties".tr,
                      style: const TextStyle(
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
                          child: Text(
                            'reset_filter'.tr,
                            style: TextStyle(
                                color: controller.blue_700_and_white.value),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                          ),
                          onPressed: () {
                            _page = 1;
                            _tutorList.clear();
                            setState(() {
                              _isFilter = false;
                              _loading = true;
                            });
                            TutorServices.loadTutorList(
                                    _selectedSpecialties,
                                    _searchController.text,
                                    checkNationality(),
                                    _page++,
                                    _perPage,
                                    pickedDate: _selectedDate)
                                .then((value) {
                              setState(() {
                                _tutorList.addAll(value
                                    .map((e) => TutorCard.fromJson(e))
                                    .toList());
                                _loading = false;
                              });
                            });
                          },
                          child: Text(
                            'apply_filter'.tr,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                )
              ])),
        ));
  }

  String _upcomingLessonTime() {
    debugPrint(
        "Start time: ${DateTime.fromMillisecondsSinceEpoch(_upComingInfo["startTimestamp"])}");
    debugPrint("End time: ${_upComingInfo["endTimestamp"]}");
    return "${DateFormat("EEE, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(_upComingInfo["startTimestamp"]))} ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(_upComingInfo["startTimestamp"]))} - ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(_upComingInfo["endTimestamp"]))}";
  }

  Widget _buildTutorList() {
    return ListView(controller: _scrollController, children: <Widget>[
      Obx(() => Container(
            color: controller.bannerBackground.value,
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
                              ? "upcoming_lesson".tr
                              : "you_have_no_upcoming_lesson".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: _isUpcoming ? 30 : 24,
                              color: Colors.white),
                        ),
                      ),
                      _isUpcoming
                          ? Column(
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(_upcomingLessonTime(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white))),
                                Center(
                                  child: CountdownTimer(
                                    widgetBuilder:
                                        (_, CurrentRemainingTime? time) {
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
                                          '(${'start_in'.tr}$days : $hours : $min : $sec)',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.yellow[300],
                                          ));
                                    },
                                    controller: CountdownTimerController(
                                        endTime:
                                            _upComingInfo["startTimestamp"]),
                                    endTime: _upComingInfo["startTimestamp"],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsetsDirectional.symmetric(
                                      vertical: 10),
                                  child: FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                            return MeetingPage(
                                              roomNameOrUrl: _upComingInfo[
                                                  "roomNameOrUrl"],
                                            );
                                          }),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.ondemand_video_sharp,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                        'enter_lesson_room'.tr,
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      )),
                                )
                              ],
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: _totalTimeLearn == 0
                            ? Text(
                                "welcome".tr,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            : Text(
                                "${'total_lesson_time'.tr}${_totalTimeLearn ~/ 60}${'hours'.tr}${_totalTimeLearn % 60}${'minutes'.tr}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      )
                    ]),
              ),
            ),
          )),
      Obx(() => Container(
            color: controller.black_and_white_card.value,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'all_tutors'.tr,
                  style: const TextStyle(
                      fontSize: 18, decoration: TextDecoration.underline),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isFilter = true;
                      });
                    },
                    child: Obx(() => Text(
                          '${'filter'.tr} >',
                          style: TextStyle(
                              color: controller.blue_700_and_white.value),
                        )))
              ],
            ),
          )),
      _tutorList.isEmpty
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 140),
              Image.asset(UIData.noDataFound, width: 100, height: 100),
              const SizedBox(height: 10),
              Text(
                "no_data".tr,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 100),
            ])
          : Obx(() => Container(
                color: controller.black_and_grey_200.value,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return index == _tutorList.length
                        ? _buildProgressIndicator()
                        : _tutorList[index];
                  },
                  itemCount: _tutorList.length + 1,
                ),
              )),
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
    TutorServices.loadTutorList(_selectedSpecialties, _searchController.text,
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
        TutorServices.loadTutorList(_selectedSpecialties,
                _searchController.text, checkNationality(), _page++, _perPage,
                pickedDate: _selectedDate)
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
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isFilter
            ? _buildFilter()
            : _buildTutorList();
  }
}
