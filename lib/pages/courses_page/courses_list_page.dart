import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/courses_page/course_detail_page.dart';
import 'package:one_on_one_learning/ui_data/ui_data.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("English For Traveling",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Card(
              margin: const EdgeInsets.all(20),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CourseDetailPage();
                    }),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(UIData.course),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 0, left: 10, right: 10),
                      child: const Text("Life in the Internet Age",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Let's discuss how technology is changing the way we live",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 10, left: 10, right: 10),
                      child: const Text("Intermerdiate - 10 lessons",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("English For Beginners",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Card(
              margin: const EdgeInsets.all(20),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CourseDetailPage();
                    }),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(UIData.course),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 0, left: 10, right: 10),
                      child: const Text("Life in the Internet Age",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Let's discuss how technology is changing the way we live",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 10, left: 10, right: 10),
                      child: const Text("Intermerdiate - 10 lessons",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("Business English",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Card(
              margin: const EdgeInsets.all(20),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CourseDetailPage();
                    }),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(UIData.course),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 0, left: 10, right: 10),
                      child: const Text("Life in the Internet Age",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Let's discuss how technology is changing the way we live",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 10, left: 10, right: 10),
                      child: const Text("Intermerdiate - 10 lessons",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("English For Kids",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Card(
              margin: const EdgeInsets.all(20),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const CourseDetailPage();
                    }),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(UIData.course),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 0, left: 10, right: 10),
                      child: const Text("Life in the Internet Age",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Let's discuss how technology is changing the way we live",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 10, left: 10, right: 10),
                      child: const Text("Intermerdiate - 10 lessons",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
