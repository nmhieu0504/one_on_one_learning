import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/courses_page/course_detail_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';

class CourseCardComponent extends StatelessWidget {
  const CourseCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 0,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Let's discuss how technology is changing the way we live",
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 10, right: 10),
              child: const Text("Intermerdiate - 10 lessons",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
