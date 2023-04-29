import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/course.dart';
import 'package:one_on_one_learning/views/courses_page/course_topic_component.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Course Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(children: const <Widget>[
              Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("Overview",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                flex: 5,
                child: Divider(
                  indent: 10,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: <Widget>[
              const Icon(
                Icons.question_mark_rounded,
                size: 20,
                color: Color.fromARGB(255, 244, 30, 151),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Why Did You Choose This Course?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: Text.rich(
                TextSpan(text: course.reason),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: <Widget>[
              const Icon(
                Icons.question_mark_rounded,
                size: 20,
                color: Color.fromARGB(255, 244, 30, 151),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Why Will You Learn?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: Text.rich(
                TextSpan(text: course.purpose),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )),
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(children: const <Widget>[
              Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("Experience Level",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                flex: 5,
                child: Divider(
                  indent: 10,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: <Widget>[
              const Icon(
                Icons.group_sharp,
                size: 20,
                color: Color.fromARGB(255, 244, 30, 151),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    course.level,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(children: const <Widget>[
              Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("Course Length",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                flex: 5,
                child: Divider(
                  indent: 10,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: <Widget>[
              const Icon(
                Icons.topic,
                size: 20,
                color: Color.fromARGB(255, 244, 30, 151),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${course.numberOfTopics} topics",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(children: const <Widget>[
              Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("List Topics",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                flex: 5,
                child: Divider(
                  indent: 10,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: course.topics.length,
              itemBuilder: (context, index) {
                return TopicCardComponent(
                  title:
                      "${course.topics[index]["orderCourse"] + 1}. ${course.topics[index]["name"]}",
                  url: course.topics[index]["nameFile"],
                );
              }),
        ],
      ),
    );
  }
}
