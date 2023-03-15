import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/home_page/tutor_card_component.dart';
import 'package:one_on_one_learning/pages/meeting_page/meeting_page.dart';
import 'package:one_on_one_learning/pages/tutor_page/tutors_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        color: Colors.purple[900],
        child: Center(
          child: SizedBox(
            height: 300,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Welcome to LetLearn!',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const MeetingPage();
                          }),
                        );
                      },
                      child: const Text(
                        'Book a lesson',
                      ))
                ]),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Recommended Tutors',
              style:
                  TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const TutorsPage();
                  }));
                },
                child: const Text('See all >'))
          ],
        ),
      ),
      const TutorCard(),
      const TutorCard(),
      const TutorCard(),
    ]);
  }
}
