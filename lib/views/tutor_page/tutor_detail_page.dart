// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/booking_page/booking_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;
import 'package:one_on_one_learning/views/tutor_page/tutor_video.dart';
import '../../utils/backend.dart';
import '../../utils/countries_lis.dart';
import '../../utils/language_map.dart';
import '../reviews_page/review_page.dart';

class TutorPage extends StatefulWidget {
  final String userId;
  const TutorPage({required this.userId, super.key});

  @override
  State<TutorPage> createState() => TutorPageState();
}

class TutorPageState extends State<TutorPage> {
  final SharePref sharePref = SharePref();
  late final String videoURL;
  late final String? avatar;
  late final String name;
  late final String? country;
  late final int? rating;
  late final String bio;
  late final String languages;
  late final String education;
  late final String experience;
  late final String interests;
  late final String profession;
  late final String specialties;
  late final List<dynamic> courses;
  late final int? totalFeedback;
  late bool isFavorite = false;
  bool _loadingData = true;
  final TextEditingController _reportController = TextEditingController();

  final _reportItems = [
    "This tutor is annoying me",
    "This profile is pretending be someone or is fake",
    "Inappropriate profile photo"
  ];

  List<String> _selectedRepotItems = [];

  Future<void> _loadData() async {
    String? token = await sharePref.getString("access_token");

    final response = await http.get(
        Uri.parse(API_URL.GET_TUTOR_DETAIL + widget.userId),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      print(response.body);
      // ignore: no_leading_underscores_for_local_identifiers
      var _data = jsonDecode(response.body);
      videoURL = _data["video"];
      avatar = _data["User"]["avatar"];
      name = _data["User"]["name"];
      country = _data["User"]["country"];
      rating = _data["rating"]?.toInt();
      bio = _data["bio"];
      languages = _data["languages"];
      education = _data["education"];
      experience = _data["experience"];
      interests = _data["interests"];
      profession = _data["profession"];
      specialties = _data["specialties"];
      courses = _data["User"]["courses"];
      totalFeedback = _data["totalFeedback"];
      isFavorite = _data["isFavorite"];

      setState(() {
        _loadingData = false;
      });
    }
  }

  Future<void> _sendReport() async {
    String? token = await sharePref.getString("access_token");

    _selectedRepotItems.add(_reportController.text);
    final response = await http.post(Uri.parse(API_URL.REPORT_TUTOR),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "tutorId": widget.userId,
          "content": _selectedRepotItems.join("\n")
        }));

    _reportController.clear();
    _selectedRepotItems.clear();
    if (response.statusCode == 200) {
      print(response.body);
      // ignore: no_leading_underscores_for_local_identifiers
      _displaySuccessMotionToast('Your report has been sent');
    }
  }

  Future<void> _modifyFavourite() async {
    String? token = await sharePref.getString("access_token");

    final response = await http.post(Uri.parse(API_URL.ADD_TO_FAVOURITE),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"tutorId": widget.userId}));

    if (response.statusCode == 200) {
      print(response.body);
      // ignore: no_leading_underscores_for_local_identifiers
      _displaySuccessMotionToast(
          isFavorite ? 'Add to favourite' : 'Remove from favourite');
    }
  }

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
    if (avatar == null) {
      return Image.asset(UIData.logoLogin);
    } else {
      return Avatar(
        loader: Container(),
        sources: [NetworkSource(avatar!)],
        name: name,
        shape: AvatarShape.rectangle(
            50, 50, const BorderRadius.all(Radius.circular(20.0))),
      );
    }
  }

  List<Widget> _showRating() {
    List<Widget> list = [];
    for (int i = 0; i < rating!; i++) {
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
        child: Text("(${totalFeedback.toString()})")));
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
    for (int i = 0; i < specialties.split(",").length; i++) {
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
          child: Text(specialtiesUltis(specialties.split(",")[i]),
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  List<Widget> _showLanguage() {
    List<Widget> list = [];
    for (int i = 0; i < languages.split(",").length; i++) {
      if (languagesMap[languages.split(",")[i]] == null) continue;
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
          child: Text(languagesMap[languages.split(",")[i]]!,
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  List<Widget> _showCourses() {
    List<Widget> list = [];
    for (int i = 0; i < courses.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
          onPressed: () {},
          child: Text(courses[i]["name"], style: const TextStyle(fontSize: 12)),
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
    _loadData();
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
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(children: <Widget>[
                  TutorVideo(url: videoURL),
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
                                  name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      rating != null
                                          ? Row(children: _showRating())
                                          : Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              child: const Text(
                                                  'Rating not available',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic)),
                                            ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          child: Text(getCountryName(country),
                                              style: const TextStyle(
                                                  fontStyle:
                                                      FontStyle.italic))),
                                    ]),
                                trailing: IconButton(
                                  iconSize: 35,
                                  icon: Icon(Icons.favorite_sharp,
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                    _modifyFavourite();
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
                                                      const BookingPage()));
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
                                        const Icon(Icons.reviews_sharp),
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
                                                    title: Text('Report $name',
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
                                                            _sendReport();
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
                                  TextSpan(text: bio),
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
                                          TextSpan(text: education),
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
                                            TextSpan(text: experience),
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
                                      child: Text(interests),
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
                                      child: Text(profession),
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
