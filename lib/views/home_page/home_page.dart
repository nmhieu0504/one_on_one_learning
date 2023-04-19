// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/home_page/tutor_card_component.dart';
import 'package:one_on_one_learning/views/meeting_page/meeting_page.dart';
import 'package:one_on_one_learning/views/tutor_page/tutors_list_page.dart';
import 'package:http/http.dart' as http;
import '../../utils/backend.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  dynamic _data;

  Future<void> _loadTutorList() async {
    SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http
        .get(Uri.parse(API_URL.GET_TUTOR_LIST), headers: <String, String>{
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      print(response.body);
      _data = jsonDecode(response.body);
      setState(() {
        _loading = false;
      });
    }
  }

  // List<Widget> _showTutorList() {
  //   List<Widget> list = [];
  //   for (int i = 0; i < 10; i++) {
  //     list.add();
  //   }
  //   return list;
  // }

  @override
  void initState() {
    super.initState();
    _loadTutorList();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(children: <Widget>[
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
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
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
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const TutorsListPage();
                        }));
                      },
                      child: const Text('See all >'))
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return TutorCard(
                    userId: _data["tutors"]["rows"][index]["userId"],
                    avatar: _data["tutors"]["rows"][index]["avatar"],
                    name: _data["tutors"]["rows"][index]["name"],
                    country: _data["tutors"]["rows"][index]["country"],
                    rating: _data["tutors"]["rows"][index]["rating"]?.toInt(),
                    specialties: _data["tutors"]["rows"][index]["specialties"],
                    bio: _data["tutors"]["rows"][index]["bio"],
                  );
                },
                itemCount: 10),
          ]);
  }
}
