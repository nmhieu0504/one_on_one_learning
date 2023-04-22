// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/tutor_page/tutor_detail_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;

import '../../utils/backend.dart';
import '../../utils/share_pref.dart';

class TutorCard extends StatefulWidget {
  final String userId;
  final String? avatar;
  final String name;
  final String? country;
  final int? rating;
  final String specialties;
  final String bio;
  bool isFavourite;

  TutorCard({
    Key? key,
    required this.userId,
    required this.avatar,
    required this.name,
    required this.country,
    required this.rating,
    required this.specialties,
    required this.bio,
    required this.isFavourite,
  }) : super(key: key);

  @override
  State<TutorCard> createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  final SharePref sharePref = SharePref();

  void onPressed() {}

  Future<void> _modifyFavourite() async {
    String? token = await sharePref.getString("access_token");

    final response = await http.post(Uri.parse(API_URL.ADD_TO_FAVOURITE),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"tutorId": widget.userId}));

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  List<Widget> _showRating() {
    List<Widget> list = [];
    for (int i = 0; i < widget.rating!; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    }
    while (list.length < 5) {
      list.add(const Icon(
        Icons.star,
        color: Colors.grey,
      ));
    }
    return list;
  }

  Widget _buildAvatar() {
    if (widget.avatar == null) {
      return Image.asset(UIData.logoLogin);
    } else {
      return Avatar(
        sources: [NetworkSource(widget.avatar!)],
        name: widget.name,
        shape: AvatarShape.rectangle(
            50, 50, const BorderRadius.all(Radius.circular(20.0))),
      );
    }
  }

  String specialtiesUltis(String text) {
    if (!text.contains("-")) {
      return text.toUpperCase();
    }
    List<String> words = text.split("-");
    String result = "";
    for (String word in words) {
      result += "${word.substring(0, 1).toUpperCase()}${word.substring(1)} ";
    }
    return result.trim();
  }

  List<Widget> _showSpecialties() {
    List<Widget> list = [];
    for (int i = 0; i < widget.specialties.split(",").length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Text(specialtiesUltis(widget.specialties.split(",")[i]),
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    return TutorPage(userId: widget.userId);
                  }),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ListTile(
                        leading: _buildAvatar(),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.name,
                                  style: const TextStyle(fontSize: 18)),
                              Row(children: <Widget>[
                                const Icon(
                                  Icons.flag,
                                  color: Colors.blue,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    widget.country == null
                                        ? 'No information'
                                        : widget.country!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ])
                            ]),
                        subtitle: widget.rating == null
                            ? Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: const Text('Rating not available',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic)),
                              )
                            : Row(
                                children: _showRating(),
                              ),
                        trailing: IconButton(
                          iconSize: 35,
                          icon: Icon(Icons.favorite_sharp,
                              color: widget.isFavourite
                                  ? Colors.red
                                  : Colors.grey),
                          onPressed: () {
                            setState(() {
                              widget.isFavourite = !widget.isFavourite;
                            });
                            _modifyFavourite();
                            debugPrint('Favourite button pressed.');
                          },
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        children: _showSpecialties()),
                  ),
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Text.rich(
                        TextSpan(
                            text:
                                // '${widget.bio.substring(0, 100)}... See more'),
                                widget.bio),
                        textAlign: TextAlign.justify,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
