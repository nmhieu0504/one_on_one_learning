import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/meeting_page/meeting_page.dart';
import 'package:one_on_one_learning/pages/tutor_page/teacher_detail_page.dart';
import 'package:one_on_one_learning/pages/tutor_page/tutors_page.dart';
import 'package:one_on_one_learning/ui_data/ui_data.dart';

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
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const TeacherPage();
                    }),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                          leading: Image.asset(UIData.logoLogin),
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Abby',
                                    style: TextStyle(fontSize: 18)),
                                Row(children: <Widget>[
                                  const Icon(
                                    Icons.flag,
                                    color: Colors.blue,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: const Text(
                                      'Philippines',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ])
                              ]),
                          subtitle: Row(
                            children: const <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite_border_rounded),
                            onPressed: () {
                              debugPrint('Favorite button pressed.');
                            },
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                onPressed: onPressed,
                                child: const Text('English'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: OutlinedButton(
                                onPressed: onPressed,
                                child: const Text('Vietnamese'),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                        padding: const EdgeInsets.all(15),
                        child: const Text.rich(
                          TextSpan(
                              text:
                                  'I was a customer service sales executive for 3 years before I become an ESL teacher I am trained to deliver excellent service to my clients so I can help you with business English dealing with customers or in sales-related jobs and a lot'),
                          textAlign: TextAlign.justify,
                        ))
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
