import 'package:flutter/material.dart';
import '../../utils/ui_data.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 74, 20, 140)),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Tue, 07 Mar 2023',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: const Text(
                        '19:00 - 21:00',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
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
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //       return const TeacherPage();
                  //     }),
                  //   );
                  // },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      leading: Image.asset(UIData.logoLogin),
                      title: const Text(
                        'Abby',
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(children: <Widget>[
                          const Icon(
                            Icons.flag,
                            color: Colors.blue,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: const Text(
                              'Philippines',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                // padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: const Text(
                        'Lesson review',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        // height: 100,
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 25, bottom: 30, left: 10, right: 10),
                            child: const Text(
                                'Review from tutor\nSession 1: 16:30 - 16:55\nNice to see you again in my class I really like her she is smart and attentive she loves participating in the class she can speak confidently she is comfortable in the class. today we study plants and their needs we stop at page 12')),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 0),
                      elevation: 0,
                      child: SizedBox(
                        width: double.infinity,
                        // height: 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: TextButton(
                                    onPressed: onPressed,
                                    child: const Text('Rating')),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: TextButton(
                                    onPressed: onPressed,
                                    child: const Text('Report')),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
