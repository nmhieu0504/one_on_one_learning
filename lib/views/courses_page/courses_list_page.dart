import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:one_on_one_learning/services/course_service.dart';
import 'package:one_on_one_learning/views/courses_page/course_card_component.dart';

import '../../models/course.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  List<Course> coursesList = [];
  List<String> courseCategories = [
    "English For Traveling",
    "English For Beginners",
    "Business English",
    "English For Kids",
  ];

  List<String> levelList = [
    "Beginner",
    "Upper-Beginner",
    "Pre-Intermediate",
    "Intermediate",
    "Upper-Intermediate",
    "Pre-Advanced",
    "Advanced",
    "Very Advanced"
  ];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    CoursesService.loadCoursesList().then((value) {
      setState(() {
        coursesList.addAll(value);
        for (var element in coursesList) {
          element.level = levelList[int.parse(element.level)];
          element.topics
              .sort((a, b) => a["orderCourse"].compareTo(b["orderCourse"]));
        }
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : GroupedListView<dynamic, String>(
            elements: coursesList,
            groupBy: (element) => element.categories,
            // groupComparator: (value1, value2) => value2.compareTo(value1),
            // itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']),
            groupSeparatorBuilder: (String value) => Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            itemBuilder: (context, element) {
              return CourseCardComponent(
                course: element,
              );
            },
          );
  }
}
