import 'dart:convert';

import 'package:flutter/material.dart';
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
  late VideoPlayerController _controller;
  late final String video;
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
  late final List<Map<String, dynamic>> courses;
  bool _loadingData = false;

  void onPressed() {}

  Future<void> _loadData() async {
    final response = await http
        .get(Uri.parse(API_URL.GET_TUTOR_DETAIL + "/" + widget.userId));

    if (response.statusCode == 200) {
      print(response.body);
      // ignore: no_leading_underscores_for_local_identifiers
      var _data = jsonDecode(response.body);
      video = _data["video"];
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
      courses = _data["courses"];
      _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize();
      setState(() {});
    }
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
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            'Abby',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _loadingData
            ? const Center(child: CircularProgressIndicator())
            : ListView(children: <Widget>[
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
                              title: const Text(
                                'Abby',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: const Text("(17)"))
                                      ],
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        child: const Text("Philippines")),
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
                              child: const Text.rich(
                                TextSpan(
                                    text:
                                        'Hello! My name is April Baldo, you can just call me Teacher April. I am an English teacher and currently teaching in senior high school. I have been teaching grammar and literature for almost 10 years. I am fond of reading and teaching literature as one way of knowing one’s beliefs and culture. I am friendly and full of positivity. I love teaching because I know each student has something to bring on. Molding them to become an individual is a great success.'),
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
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: OutlinedButton(
                                            onPressed: onPressed,
                                            child: const Text('English'),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: OutlinedButton(
                                            onPressed: onPressed,
                                            child: const Text('Vietnamese'),
                                          ),
                                        ),
                                      ]),
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
                                      child: const Text.rich(
                                        TextSpan(
                                            text:
                                                "Bachelor's Degree in English Language and Literature"),
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
                                      child: const Text.rich(
                                          TextSpan(
                                              text:
                                                  "I have been teaching grammar and literature for almost 10 years. I am fond of reading and teaching literature as one way of knowing one’s beliefs and culture. I am friendly and full of positivity. I love teaching because I know each student has something to bring on. Molding them to become an individual is a great success."),
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
                                    child: const Text(
                                        "Finance, Reading, Writing, Traveling, Cooking, and Music"),
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
                                    child: const Text(
                                        "Bachelor's Degree in English Language and Literature"),
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
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                        "Bachelor's Degree in English Language and Literature"),
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
                                    child: Text('Courses',
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
