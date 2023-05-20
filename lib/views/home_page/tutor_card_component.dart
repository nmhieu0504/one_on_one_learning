// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_on_one_learning/views/tutor_page/tutor_detail_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;

import '../../controllers/controller.dart';
import '../../utils/backend.dart';
import '../../utils/countries_lis.dart';
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
    super.key,
    required this.userId,
    required this.avatar,
    required this.name,
    required this.country,
    required this.rating,
    required this.specialties,
    required this.bio,
    required this.isFavourite,
  });

  factory TutorCard.fromJson(Map<String, dynamic> json) {
    return TutorCard(
      userId: json["userId"],
      avatar: json["avatar"],
      name: json["name"],
      country: json["country"],
      rating: json["rating"]?.toInt(),
      specialties: json["specialties"],
      bio: json["bio"],
      isFavourite: json["isFavourite"],
    );
  }

  @override
  State<TutorCard> createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  Controller controller = Get.find();

  final SharePref sharePref = SharePref();
  bool _isAvatarError = false;

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
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[50],
        backgroundImage: _isAvatarError
            ? const AssetImage(UIData.defaultAvatar)
            : NetworkImage(widget.avatar!) as ImageProvider,
        onBackgroundImageError: (exception, stackTrace) {
          setState(() {
            _isAvatarError = true;
          });
        },
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
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: controller.blue_700_and_white.value,
            side: BorderSide(
                color: controller.blue_700_and_white.value ?? Colors.blue),
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
    return Obx(() => Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 0,
                color: controller.black_and_white_card.value,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
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
                            isThreeLine: true,
                            leading: _buildAvatar(),
                            title: Text(widget.name,
                                style: const TextStyle(fontSize: 18)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          : widget.country!.length > 2
                                              ? widget.country!
                                              : getCountryName(widget.country!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ]),
                                widget.rating == null
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: const Text(
                                            'Rating not available',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic)),
                                      )
                                    : Row(
                                        children: _showRating(),
                                      ),
                              ],
                            ),
                            trailing: IconButton(
                              iconSize: 35,
                              icon: Icon(
                                  widget.isFavourite
                                      ? Icons.favorite_sharp
                                      : Icons.favorite_border,
                                  color: Colors.red),
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
        ));
  }
}
