import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/lesson_page.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

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
                    fontSize: 20,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: const Text(
                  "Our world is rapidly changing thanks to new technology, and the vocabulary needed to discuss modern life is evolving almost daily. In this course you will learn the most up-to-date terminology from expertly crafted lessons as well from your native-speaking tutor.")),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ]),
          ),
          Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: const Text(
                  "You will learn vocabulary related to timely topics like remote work, artificial intelligence, online privacy, and more. In addition to discussion questions, you will practice intermediate level speaking tasks such as using data to describe trends.")),
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
                    fontSize: 20,
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
                  child: const Text(
                    'Intermediate',
                    style: TextStyle(
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
                    fontSize: 20,
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
                  child: const Text(
                    '9 topics',
                    style: TextStyle(
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
                    fontSize: 20,
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
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const LessonPage();
                  }),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '1. The Internet',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '2. Artificial Intelligence (AI)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '3. Social Media',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '4. Internet Privacy',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '5. Live Streaming',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '6. Coding',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '7. Technology Transforming Healthcare',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '8. Smart Home Technology',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) {
                //     return const TeacherPage();
                //   }),
                // );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        '9. Remote Work - A Dream Job?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
