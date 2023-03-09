import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/teacher_detail_page.dart';
import '../../ui_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        color: Colors.blue[800],
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const TeacherPage();
                          }),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.blue)))),
                      child: const Text(
                        'Book a lesson',
                        style: TextStyle(color: Colors.blue),
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
            TextButton(onPressed: onPressed, child: const Text('See all >'))
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget>[
            Card(
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
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset(UIData.logoLogin),
                        title: const Text('Abby'),
                        subtitle: Column(children: <Widget>[
                          Row(
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
                          Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: onPressed,
                                child: const Text('English'),
                              ),
                              TextButton(
                                onPressed: onPressed,
                                child: const Text('Vietnamese'),
                              ),
                            ],
                          ),
                        ]),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite_border_rounded),
                          onPressed: () {
                            debugPrint('Favorite button pressed.');
                          },
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                          'I was a customer service sales executive for 3 years before I become an ESL teacher I am trained to deliver excellent service to my clients so I can help you with business English dealing with customers or in sales-related jobs and a lot'),
                    )
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
