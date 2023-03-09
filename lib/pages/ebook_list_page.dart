import 'package:flutter/material.dart';
import '../ui_data.dart';

class EBookList extends StatelessWidget {
  const EBookList({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(20),
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
                    Image.asset(UIData.ebook),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 0, left: 10, right: 10),
                      child: const Text("What a world 1",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                          "For teenagers who have an excellent vocabulary background and brilliant communication skills."),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 10, left: 10, right: 10),
                      child: const Text("Beginner",
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
