import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_on_one_learning/models/course.dart';
import 'package:one_on_one_learning/views/courses_page/course_detail_page.dart';

import '../../controllers/controller.dart';

class CourseCardComponent extends StatelessWidget {
  Controller controller = Get.find();
  final Course course;

  CourseCardComponent({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: controller.black_and_white_card.value,
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
              return CourseDetailPage(
                course: course,
              );
            }),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              course.imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return Container();
              },
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 10, right: 10),
              child: Text(course.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                course.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 10, right: 10),
              child: Text("${course.level} - ${course.numberOfTopics} lessons",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
