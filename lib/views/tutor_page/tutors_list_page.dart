import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/tutor_page/tutor_detail_page.dart';
import '../../utils/ui_data.dart';

class TutorsListPage extends StatefulWidget {
  const TutorsListPage({super.key});

  @override
  State<TutorsListPage> createState() => _TutorsListPageState();
}

class _TutorsListPageState extends State<TutorsListPage> {
  void onPressed() {
    debugPrint("Pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          // Setting floatHeaderSlivers to true is required in order to float
          // the outer slivers over the inner scrollable.
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  title: SizedBox(
                    height: 40,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[200],
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
                  forceElevated: innerBoxIsScrolled,
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(40),
                      child: SizedBox(
                          height: 30,
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: ElevatedButton(
                                      onPressed: onPressed,
                                      child: const Text(
                                        'English',
                                      )),
                                );
                              },
                              // SegmentedButton(segments: segments, selected: selected),
                            ),
                          ))))
            ];
          },
          body: Container(
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const TutorPage(userId: "THIS IS THE ID",);
                          }),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: ListTile(
                                leading: Image.asset(UIData.logoLogin),
                                title: const Text(
                                  'Abby',
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Row(children: <Widget>[
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
                                ]),
                                trailing: RichText(
                                    text: TextSpan(
                                        text: '5.0 ',
                                        style: TextStyle(
                                            color: Colors.purple[800],
                                            fontSize: 18),
                                        children: const [
                                      WidgetSpan(
                                          child: Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 18,
                                      ))
                                    ]))),
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
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10, top: 10),
                              child: const Text.rich(
                                TextSpan(
                                    text:
                                        'I was a customer service sales executive for 3 years before I become an ESL teacher I am trained to deliver excellent service to my clients so I can help you with business English dealing with customers or in sales-related jobs and a lot'),
                                textAlign: TextAlign.justify,
                              ))
                        ],
                      ),
                    ),
                  );
                }),
          )),
    );
  }
}
