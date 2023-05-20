// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/controllers/controller.dart';
import 'package:one_on_one_learning/services/course_service.dart';
import 'package:one_on_one_learning/services/tutor_services.dart';
import 'package:one_on_one_learning/views/booking_page/booking_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:one_on_one_learning/views/chat_with_tutor_page/chat_page.dart';
import 'package:one_on_one_learning/views/tutor_page/tutor_video.dart';
import '../../models/course.dart';
import '../../models/tutor.dart';
import '../../utils/countries_lis.dart';
import '../../utils/language_map.dart';
import '../courses_page/course_detail_page.dart';
import '../reviews_page/review_page.dart';
import 'package:get/get.dart';

class TutorPage extends StatefulWidget {
  final String userId;
  const TutorPage({required this.userId, super.key});

  @override
  State<TutorPage> createState() => TutorPageState();
}

class TutorPageState extends State<TutorPage> {
  bool _isAvatarError = false;
  late Tutor tutor;
  bool _loadingData = true;
  final TextEditingController _reportController = TextEditingController();
  Controller controller = Get.find();

  List<Course> tutorCoursesList = [];

  final _reportItems = [
    "reason_report_1".tr,
    "reason_report_2".tr,
    "reason_report_3".tr,
  ];

  List<String> levelList = [
    "Any Level",
    "Beginner",
    "Upper-Beginner",
    "Pre-Intermediate",
    "Intermediate",
    "Upper-Intermediate",
    "Pre-Advanced",
    "Advanced",
    "Very Advanced"
  ];

  List<String> _selectedRepotItems = [];

  void _displayErrorMotionToast(String str) {
    MotionToast.error(
      title: const Text(
        'Invalid',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(str),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  void _displaySuccessMotionToast(String str) {
    MotionToast.success(
      toastDuration: const Duration(milliseconds: 750),
      height: 60,
      width: 300,
      description: Text(str,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 70, 146, 60))),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  Widget _buildAvatar() {
    if (tutor.user.avatar == null) {
      return Image.asset(UIData.logoLogin);
    } else {
      return CircleAvatar(
        radius: 100,
        backgroundColor: Colors.grey[50],
        backgroundImage: _isAvatarError
            ? const AssetImage(UIData.defaultAvatar)
            : NetworkImage(tutor.user.avatar!) as ImageProvider,
        onBackgroundImageError: (exception, stackTrace) {
          setState(() {
            _isAvatarError = true;
          });
        },
      );
    }
  }

  List<Widget> _showRating() {
    List<Widget> list = [];
    for (int i = 0; i < tutor.avgRating.round(); i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    }
    while (list.length < 5) {
      list.add(const Icon(
        Icons.star,
        color: Colors.grey,
      ));
    }
    list.add(Container(
        margin: const EdgeInsets.only(left: 5),
        child: Text("(${tutor.totalFeedback.toString()})")));
    return list;
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

  List<Widget> _showSpecialties() {
    List<Widget> list = [];
    for (int i = 0; i < tutor.specialties.split(",").length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor:
                controller.isDarkTheme ? Colors.white : Colors.blue[700],
            side: BorderSide(
                color: controller.isDarkTheme ? Colors.white : Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Text(specialtiesUltis(tutor.specialties.split(",")[i]),
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  List<Widget> _showLanguage() {
    List<Widget> list = [];
    for (int i = 0; i < tutor.languages.split(",").length; i++) {
      if (languagesMap[tutor.languages.split(",")[i]] == null) continue;
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor:
                controller.isDarkTheme ? Colors.white : Colors.blue[700],
            side: BorderSide(
                color: controller.isDarkTheme ? Colors.white : Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Text(languagesMap[tutor.languages.split(",")[i]]!,
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  List<Widget> _showCourses() {
    List<Widget> list = [];
    for (int i = 0; i < tutor.user.courses.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return CourseDetailPage(
                  course: tutorCoursesList[i],
                );
              }),
            );
          },
          child: Text(tutor.user.courses[i].name ?? "",
              style: TextStyle(
                  color: controller.isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 12)),
        ),
      ));
    }
    if (list.isEmpty) {
      list.add(Text("no_course".tr,
          style: const TextStyle(fontStyle: FontStyle.italic)));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    TutorServices.loadData(widget.userId).then((value) {
      setState(() {
        tutor = value;
        _loadingData = false;
      });
      for (int i = 0; i < tutor.user.courses.length; i++) {
        CoursesService.loadCourseByID(tutor.user.courses[i].id ?? "")
            .then((value) {
          value.level = levelList[int.parse(value.level)];
          tutorCoursesList.add(value);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: controller.isDarkTheme
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: _loadingData
          ? Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
              color: Colors.blue[700],
            )))
          : Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor:
                    controller.isDarkTheme ? Colors.white : Colors.blue[700],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(tutorId: widget.userId)));
                },
                label: Text(
                  "Chat",
                  style: TextStyle(
                      color:
                          controller.isDarkTheme ? Colors.black : Colors.white),
                ),
                icon: Icon(Icons.chat,
                    color:
                        controller.isDarkTheme ? Colors.black : Colors.white),
              ),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                automaticallyImplyLeading: false,
                title: Text(
                  tutor.user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(children: <Widget>[
                  TutorVideo(url: tutor.video ?? ""),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    _buildAvatar(),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        tutor.user.name,
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                          getCountryName(tutor.user.country,
                                              isTutorPage: true),
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic)),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _showRating()),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Column(children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      FilledButton(
                                          style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  controller.isDarkTheme
                                                      ? Colors.white
                                                      : Colors.blue[700]),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookingPage(
                                                          tutorId:
                                                              widget.userId,
                                                        )));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Text('book_a_lesson'.tr,
                                                style: TextStyle(
                                                    color:
                                                        controller.isDarkTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontSize: 16)),
                                          ))
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    TextButton(
                                      child: Column(children: [
                                        Icon(
                                            tutor.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('favorite'.tr,
                                                style: TextStyle(
                                                    color: controller
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.blue[700]))),
                                      ]),
                                      onPressed: () {
                                        setState(() {
                                          tutor.isFavorite = !tutor.isFavorite;
                                        });
                                        TutorServices.modifyFavourite(
                                                widget.userId)
                                            .then((value) {
                                          if (value) {
                                            _displaySuccessMotionToast(tutor
                                                    .isFavorite
                                                ? 'add_to_favorite'.tr
                                                : 'remove_from_favorite'.tr);
                                          }
                                        });
                                        debugPrint('Favourite button pressed.');
                                      },
                                    ),
                                    TextButton(
                                      child: Column(children: <Widget>[
                                        Icon(Icons.star_border_outlined,
                                            color: controller.isDarkTheme
                                                ? Colors.white
                                                : Colors.blue[700]),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('Reviews',
                                                style: TextStyle(
                                                    color: controller
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.blue[700]))),
                                      ]),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewPage(
                                                        userID:
                                                            widget.userId)));
                                      },
                                    ),
                                    TextButton(
                                      child: Column(children: <Widget>[
                                        Icon(Icons.report,
                                            color: controller.isDarkTheme
                                                ? Colors.white
                                                : Colors.blue[700]),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Text('report'.tr,
                                                style: TextStyle(
                                                    color: controller
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.blue[700]))),
                                      ]),
                                      onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Center(
                                                child: SingleChildScrollView(
                                                  child: AlertDialog(
                                                    title: Text(
                                                        '${'report'.tr} ${tutor.user.name}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              "help_us_report"
                                                                  .tr,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: ListBody(
                                                                children:
                                                                    _reportItems
                                                                        .map((item) =>
                                                                            StatefulBuilder(
                                                                              builder: (context, setState) => CheckboxListTile(
                                                                                  activeColor: controller.isDarkTheme ? Colors.white : Colors.blue[700],
                                                                                  value: _selectedRepotItems.contains(item),
                                                                                  title: Text(item, style: const TextStyle(fontWeight: FontWeight.normal)),
                                                                                  controlAffinity: ListTileControlAffinity.leading,
                                                                                  onChanged: (isChecked) => setState(() {
                                                                                        if (isChecked!) {
                                                                                          _selectedRepotItems.add(item);
                                                                                        } else {
                                                                                          _selectedRepotItems.remove(item);
                                                                                        }
                                                                                      })),
                                                                            ))
                                                                        .toList(),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: Theme(
                                                              data: ThemeData(
                                                                primaryColor: controller
                                                                        .isDarkTheme
                                                                    ? Colors
                                                                        .white
                                                                    : Colors.blue[
                                                                        700],
                                                                primaryColorDark:
                                                                    controller
                                                                            .isDarkTheme
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .blue[700],
                                                              ),
                                                              child: TextField(
                                                                cursorColor: controller
                                                                        .isDarkTheme
                                                                    ? Colors
                                                                        .white
                                                                    : Colors.blue[
                                                                        700],
                                                                controller:
                                                                    _reportController,
                                                                maxLines: 3,
                                                                decoration: InputDecoration(
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    hintText:
                                                                        'enter_your_report'
                                                                            .tr),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    actions: <Widget>[
                                                      FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              controller
                                                                      .isDarkTheme
                                                                  ? Colors.white
                                                                  : Colors.blue[
                                                                      700],
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        child: const Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        onPressed: () {
                                                          if (_selectedRepotItems
                                                                  .isEmpty &&
                                                              _reportController
                                                                  .text
                                                                  .isEmpty) {
                                                            _displayErrorMotionToast(
                                                                "error_report"
                                                                    .tr);
                                                          } else {
                                                            _selectedRepotItems.add(
                                                                _reportController
                                                                    .text);
                                                            TutorServices.sendReport(
                                                                    widget
                                                                        .userId,
                                                                    _selectedRepotItems)
                                                                .then((value) {
                                                              _reportController
                                                                  .clear();
                                                              _selectedRepotItems
                                                                  .clear();
                                                              if (value) {
                                                                _displaySuccessMotionToast(
                                                                    'success_report'
                                                                        .tr);
                                                              }
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        },
                                                      ),
                                                      FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.grey[400],
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16)),
                                                        onPressed: () {
                                                          _reportController
                                                              .clear();
                                                          _selectedRepotItems
                                                              .clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(10),
                                child: Text.rich(
                                  TextSpan(text: tutor.bio),
                                  textAlign: TextAlign.justify,
                                )),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('languages'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    Wrap(
                                        alignment: WrapAlignment.start,
                                        children: _showLanguage()),
                                  ]),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('education'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text.rich(
                                          TextSpan(text: tutor.education),
                                        ))
                                  ]),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('experience'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text.rich(
                                            TextSpan(text: tutor.experience),
                                            textAlign: TextAlign.justify))
                                  ]),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('interests'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(tutor.interests),
                                    )
                                  ]),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('profession'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(tutor.profession),
                                    )
                                  ]),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('specialties'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    Wrap(
                                        alignment: WrapAlignment.start,
                                        children: _showSpecialties()),
                                  ]),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text('courses'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: controller.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.blue[700])),
                                    ),
                                    ..._showCourses()
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}
