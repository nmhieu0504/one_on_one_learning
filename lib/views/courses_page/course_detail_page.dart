import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text(
          "course_detail".tr,
          style: const TextStyle(
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
            child: Row(children: <Widget>[
              const Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("overview".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const Expanded(
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
                  child: Text(
                    'why_choose_this_course'.tr,
                    style: const TextStyle(
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
                  child: Text(
                    'what_will_you_learn'.tr,
                    style: const TextStyle(
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
            child: Row(children: <Widget>[
              const Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("experience_level".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const Expanded(
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
            child: Row(children: <Widget>[
              const Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("course_length".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const Expanded(
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
                    "${course.numberOfTopics} ${'topics'.tr}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(children: <Widget>[
              const Expanded(
                flex: 1,
                child: Divider(
                  endIndent: 10,
                  color: Colors.black,
                ),
              ),
              Text("list_topics".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const Expanded(
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
