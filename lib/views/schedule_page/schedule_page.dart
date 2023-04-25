import 'package:flutter/material.dart';
import '../../utils/ui_data.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
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
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        '1 lesson',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            '19:00 - 21:00',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: Row(children: const <Widget>[
                              Icon(Icons.delete, color: Colors.red),
                              Text('Cancel',
                                  style: TextStyle(color: Colors.red)),
                            ]),
                            onPressed: () {},
                          ),
                        ]),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: const Text(
                        'Lesson request',
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
                                top: 30, bottom: 30, left: 10, right: 10),
                            child: const Text('I want to learn English')),
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
