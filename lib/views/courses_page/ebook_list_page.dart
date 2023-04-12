import 'package:flutter/material.dart';
import 'package:one_on_one_learning/ui_data/ui_data.dart';

class EBookList extends StatelessWidget {
  const EBookList({super.key});

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                elevation: 0,
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
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "For teenagers who have an excellent vocabulary background and brilliant communication skills.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 0, bottom: 10, left: 10, right: 10),
                        child: const Text("Beginner",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}