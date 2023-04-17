import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/booking_page/booking_page.dart';
import 'package:video_player/video_player.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;
import '../../utils/backend.dart';

class TutorPage extends StatefulWidget {
  final String userId;
  const TutorPage({required this.userId, super.key});

  @override
  State<TutorPage> createState() => TutorPageState();
}

class TutorPageState extends State<TutorPage> {
  final SharePref sharePref = SharePref();
  late VideoPlayerController _controller;
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
  bool _loadingData = true;

  void onPressed() {}

  Future<void> _loadData() async {
    print(API_URL.GET_TUTOR_DETAIL + widget.userId);

    String? token = await sharePref.getString("access_token");

    final response = await http.get(
        Uri.parse(API_URL.GET_TUTOR_DETAIL + widget.userId),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      print(response.body);
      // ignore: no_leading_underscores_for_local_identifiers
      var _data = jsonDecode(response.body);
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

      _initVideo(_data["video"]);
      setState(() {
        _loadingData = false;
      });
    }
  }

  void _initVideo(String url) {
    _controller = VideoPlayerController.network(
      url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.setLooping(true);
    _controller.initialize().then((value) => setState(() {}));
  }

  List<Widget> _showRating() {
    List<Widget> list = [];
    for (int i = 0; i < rating!; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    }
    list.add(Container(
        margin: const EdgeInsets.only(left: 5),
        child: Text("(${totalFeedback.toString()})")));
    return list;
  }

  List<Widget> _showSpecialties() {
    List<Widget> list = [];
    for (int i = 0; i < specialties.split(",").length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Text(specialties.split(",")[i],
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  List<Widget> _showLanguage() {
    List<Widget> list = [];
    for (int i = 0; i < languages.split(",").length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Text(languages.split(",")[i],
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
          onPressed: onPressed,
          child: Text(courses[i]["name"], style: const TextStyle(fontSize: 12)),
        ),
      ));
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
    _controller.dispose();
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
              body: ListView(children: <Widget>[
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_controller),
                            ClosedCaption(text: _controller.value.caption.text),
                            _ControlsOverlay(controller: _controller),
                            VideoProgressIndicator(_controller,
                                allowScrubbing: true),
                          ],
                        ),
                      )
                    : Container(),
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
                              leading: Image.asset(UIData.logoLogin),
                              title: Text(
                                name,
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: Text(country ?? "")),
                                  ]),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite_border_rounded),
                                onPressed: () {
                                  debugPrint('Favorite button pressed.');
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
                                      const Icon(Icons.message),
                                      Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: const Text('Message')),
                                    ]),
                                    onPressed: () {},
                                  ),
                                  TextButton(
                                    child: Column(children: <Widget>[
                                      const Icon(Icons.report),
                                      Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: const Text('Report')),
                                    ]),
                                    onPressed: () {},
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
                                      margin: const EdgeInsets.only(bottom: 10),
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
                                      margin: const EdgeInsets.only(bottom: 10),
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
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text('Rating and Comments (0)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.purple[900])),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                        "Bachelor's Degree in English Language and Literature"),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     setState(() {
              //       _controller.value.isPlaying
              //           ? _controller.pause()
              //           : _controller.play();
              //     });
              //   },
              //   child: Icon(
              //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              //   ),
              // ),
            ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
