import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/tutor_page/tutor_detail_page.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';

class TutorCard extends StatefulWidget {
  final String userId;
  final String? avatar;
  final String name;
  final String? country;
  final int? rating;
  final String specialties;
  final String bio;
  const TutorCard({
    Key? key,
    required this.userId,
    required this.avatar,
    required this.name,
    required this.country,
    this.rating,
    required this.specialties,
    required this.bio,
  }) : super(key: key);

  @override
  State<TutorCard> createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  void onPressed() {}

  List<Widget> _showRating() {
    List<Widget> list = [];
    for (int i = 0; i < widget.rating!; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    }
    return list;
  }

  String specialtiesUltis(String text) {
    if(!text.contains("-")){
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
          child: Text(specialtiesUltis( widget.specialties.split(",")[i]),
              style: const TextStyle(fontSize: 12)),
        ),
      ));
    }
    return list;
  }

  Widget validateImage() {
    try {
      return Image.network(
        widget.avatar!,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(UIData.logoLogin),
      );
    } catch (e) {
      return Image.asset(UIData.logoLogin);
    }
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
                        leading:
                            //  widget.avatar == null ?
                            Image.asset(UIData.logoLogin),
                        // : validateImage(),
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
                                        fontWeight: FontWeight.normal),
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
                          icon: const Icon(Icons.favorite_border_rounded),
                          onPressed: () {
                            debugPrint('Favorite button pressed.');
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
