import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/booking_page/booking_page.dart';
import 'package:video_player/video_player.dart';
import 'package:one_on_one_learning/ui_data/ui_data.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  late VideoPlayerController _controller;

  void onPressed() {}

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Video Demo',
      home: Scaffold(
        body: ListView(children: <Widget>[
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Card(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              // splashColor: Colors.blue.withAlpha(30),
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
                          style: TextStyle(),
                        ),
                        subtitle: Column(children: <Widget>[
                          Row(children: const <Widget>[Text("Teacher")]),
                          Row(
                            children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text('English')),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Text('Vietnamese')),
                            ],
                          ),
                        ]),
                        trailing: Column(
                          children: <Widget>[
                            // Container(
                            //   child: Row(
                            //     children: const <Widget>[
                            //       Icon(
                            //         Icons.star,
                            //         color: Colors.yellow,
                            //       ),
                            //       Icon(
                            //         Icons.star,
                            //         color: Colors.yellow,
                            //       ),
                            //       Icon(
                            //         Icons.star,
                            //         color: Colors.yellow,
                            //       ),
                            //       Icon(
                            //         Icons.star,
                            //         color: Colors.yellow,
                            //       ),
                            //       Icon(
                            //         Icons.star,
                            //         color: Colors.yellow,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border_rounded),
                              onPressed: () {
                                debugPrint('Favorite button pressed.');
                              },
                            )
                          ],
                        )),
                    Center(
                      child: Column(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ElevatedButton(
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        child: const Text(
                            "Hello! My name is April Baldo, you can just call me Teacher April. I am an English teacher and currently teaching in senior high school. I have been teaching grammar and literature for almost 10 years. I am fond of reading and teaching literature as one way of knowing one’s beliefs and culture. I am friendly and full of positivity. I love teaching because I know each student has something to bring on. Molding them to become an individual is a great success.")),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text('Languages',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: onPressed,
                                      child: const Text(
                                        'English',
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: onPressed,
                                      child: const Text(
                                        'Vietnamese',
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                ],
                              ),
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
                              child: const Text('Education',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
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
                              child: const Text('Experience',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                  "I have been teaching grammar and literature for almost 10 years. I am fond of reading and teaching literature as one way of knowing one’s beliefs and culture. I am friendly and full of positivity. I love teaching because I know each student has something to bring on. Molding them to become an individual is a great success."),
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
                              child: const Text('Intersts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
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
                              child: const Text('Profession',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
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
                              child: const Text('Specialties',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
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
                              child: const Text('Courses',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
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
                              child: const Text('Rating and Comments (0)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue)),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
