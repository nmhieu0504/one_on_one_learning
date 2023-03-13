import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/tutor_page/teacher_detail_page.dart';
import '../../ui_data/ui_data.dart';

class TutorsPage extends StatefulWidget {
  const TutorsPage({super.key});

  @override
  State<TutorsPage> createState() => _TutorsPageState();
}

class _TutorsPageState extends State<TutorsPage> {
  void onPressed() {
    debugPrint("Pressed");
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        // Setting floatHeaderSlivers to true is required in order to float
        // the outer slivers over the inner scrollable.
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Container(
                  margin: const EdgeInsets.all(20),
                  height: 40,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        hintText: 'Search',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(15),
                          width: 18,
                          child: Image.asset(UIData.searchIcon),
                        )),
                  ),
                ),
                floating: true,
                expandedHeight: 100.0,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: SizedBox(
                        height: 50,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            children: <Widget>[
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'English',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Vietnamese',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Chinese',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Japanese',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Korean',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'French',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'German',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Spanish',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Italian',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: onPressed,
                                  child: const Text(
                                    'Russian',
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ]))))
          ];
        },
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Card(
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          leading: Image.asset(UIData.logoLogin),
                          title: const Text('Abby'),
                          subtitle: Row(
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
                          trailing: RichText(
                              text: const TextSpan(
                                  text: '5.0  ',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                  children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 18,
                                ))
                              ]))),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                            'I was a customer service sales executive for 3 years before I become an ESL teacher I am trained to deliver excellent service to my clients so I can help you with business English dealing with customers or in sales-related jobs and a lot'),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
