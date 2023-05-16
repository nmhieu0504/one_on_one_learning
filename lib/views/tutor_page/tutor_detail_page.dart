// ignore_for_file: avoid_print

import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/services/course_service.dart';
import 'package:one_on_one_learning/services/tutor_services.dart';
import 'package:one_on_one_learning/views/booking_page/booking_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:one_on_one_learning/views/tutor_page/tutor_video.dart';
import '../../models/course.dart';
import '../../models/tutor.dart';
import '../../utils/countries_lis.dart';
import '../../utils/language_map.dart';
import '../courses_page/course_detail_page.dart';
import '../reviews_page/review_page.dart';

class TutorPage extends StatefulWidget {
  final String userId;
  const TutorPage({required this.userId, super.key});

  @override
  State<TutorPage> createState() => TutorPageState();
}

class TutorPageState extends State<TutorPage> {
  late Tutor tutor;
  bool _loadingData = true;
  final TextEditingController _reportController = TextEditingController();

  List<Course> tutorCoursesList = [];

  final _reportItems = [
    "This tutor is annoying me",
    "This profile is pretending be someone or is fake",
    "Inappropriate profile photo"
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
      title: const Text(
        'Success',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(str),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  Widget _buildAvatar() {
    if (tutor.user.avatar == null) {
      return Image.asset(UIData.logoLogin);
    } else {
      return Avatar(
        loader: Container(),
        sources: [NetworkSource(tutor.user.avatar ?? "")],
        name: tutor.user.name,
        shape: AvatarShape.rectangle(
            50, 50, const BorderRadius.all(Radius.circular(20.0))),
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
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
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
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
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
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    if (list.isEmpty) {
      list.add(const Text("No courses",
          style: TextStyle(fontStyle: FontStyle.italic)));
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
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _loadingData
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
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
                    color: Colors.black,
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
                      // splashcolor: Colors.purple[900].withAlpha(30),
                      // onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                                leading: _buildAvatar(),
                                title: Text(
                                  tutor.user.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: _showRating()),
                                      Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          child: Text(
                                              getCountryName(
                                                  tutor.user.country),
                                              style: const TextStyle(
                                                  fontStyle:
                                                      FontStyle.italic))),
                                    ]),
                                trailing: IconButton(
                                  iconSize: 35,
                                  icon: Icon(Icons.favorite_sharp,
                                      color: tutor.isFavorite
                                          ? Colors.red
                                          : Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      tutor.isFavorite = !tutor.isFavorite;
                                    });
                                    TutorServices.modifyFavourite(widget.userId)
                                        .then((value) {
                                      if (value) {
                                        _displaySuccessMotionToast(
                                            tutor.isFavorite
                                                ? 'Add to favourite'
                                                : 'Remove from favourite');
                                      }
                                    });
                                    debugPrint('Favourite button pressed.');
                                  },
                                )),
                            Center(
                              child: Column(children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingPage(
                                                        tutorId: widget.userId,
                                                      )));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: const Text('Book Now')),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    TextButton(
                                      child: Column(children: <Widget>[
                                        const Icon(Icons.chat),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: const Text('Chat')),
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
                                        const Icon(Icons.star_border_outlined),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: const Text('Reviews')),
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
                                        const Icon(Icons.report),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: const Text('Report')),
                                      ]),
                                      onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Center(
                                                child: SingleChildScrollView(
                                                  child: AlertDialog(
                                                    title: Text(
                                                        'Report ${tutor.user.name}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Text(
                                                              "Help us understand what's happening?",
                                                              style: TextStyle(
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
                                                            child: TextField(
                                                              controller:
                                                                  _reportController,
                                                              maxLines: 3,
                                                              decoration: const InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Enter your report here'),
                                                            ),
                                                          ),
                                                        ]),
                                                    actions: <Widget>[
                                                      FilledButton(
                                                        style: FilledButton
                                                            .styleFrom(
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
                                                                "Please give us more information about your report.");
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
                                                                    'Your report has been sent');
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
                                                              Colors.grey,
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
                                      child: Text('Languages',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
                                      child: Text('Education',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
                                      child: Text('Experience',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
                                      child: Text('Interests',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
                                      child: Text('Profession',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
                                      child: Text('Specialties',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
                                      child: Text('Courses',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purple[900])),
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
