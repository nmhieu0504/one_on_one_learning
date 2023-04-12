import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/lesson_page/lesson_page.dart';

class TopicCardComponent extends StatelessWidget {
  const TopicCardComponent(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
