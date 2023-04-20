// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/home_page/tutor_card_component.dart';
import 'package:one_on_one_learning/views/meeting_page/meeting_page.dart';
import 'package:http/http.dart' as http;
import '../../utils/backend.dart';
import '../../utils/ui_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFilter = false;
  bool _loading = true;
  bool _getMoreData = false;
  int _page = 1;

  final List<TutorCard> _tutorList = [];
  ScrollController _scrollController = ScrollController();

  Future<void> _loadTutorList() async {
    SharePref sharePref = SharePref();
    String? token = await sharePref.getString("access_token");
    final response = await http.get(
        Uri.parse(API_URL.GET_TUTOR_LIST + _page.toString()),
        headers: <String, String>{
          "Authorization": "Bearer $token",
        });
    _page++;

    if (response.statusCode == 200) {
      print(response.body);
      var _data = jsonDecode(response.body);

      setState(() {
        for (int index = 0; index < _data["tutors"]["rows"].length; index++) {
          _tutorList.add(TutorCard(
            userId: _data["tutors"]["rows"][index]["userId"],
            avatar: _data["tutors"]["rows"][index]["avatar"],
            name: _data["tutors"]["rows"][index]["name"],
            country: _data["tutors"]["rows"][index]["country"],
            rating: _data["tutors"]["rows"][index]["rating"]?.toInt(),
            specialties: _data["tutors"]["rows"][index]["specialties"],
            bio: _data["tutors"]["rows"][index]["bio"],
          ));
        }
        _loading = false;
      });
    }
    setState(() {
      _getMoreData = false;
    });
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _getMoreData ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Text("Tutor Name"),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SizedBox(
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
          ),
        ]));
  }

  Widget _buildTutorList() {
    return ListView(controller: _scrollController, children: <Widget>[
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
              'All Tutors',
              style:
                  TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _isFilter = true;
                  });
                },
                child: const Text('Filters >'))
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return index == _tutorList.length
              ? _buildProgressIndicator()
              : _tutorList[index];
        },
        itemCount: _tutorList.length + 1,
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _loadTutorList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _getMoreData = true;
        });
        _loadTutorList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _isFilter
            ? _buildFilter()
            : _buildTutorList();
  }
}
