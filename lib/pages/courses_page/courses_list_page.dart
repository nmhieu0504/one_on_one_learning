import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/courses_page/course_card_component.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("English For Traveling",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const CourseCardComponent()
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("English For Beginners",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const CourseCardComponent()
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("Business English",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const CourseCardComponent()
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("English For Kids",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            const CourseCardComponent()
          ],
        ),
      )
    ]);
  }
}
