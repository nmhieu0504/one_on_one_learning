import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_on_one_learning/models/ebook.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/controller.dart';

class EbookCardComponent extends StatelessWidget {
  Controller controller = Get.find();
  final EBook ebook;

  EbookCardComponent({
    super.key,
    required this.ebook,
  });

  void _launchInBrowser() async {
    if (!await launchUrl(
      Uri.parse(ebook.fileUrl),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $ebook.fileUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
          _launchInBrowser();
          // );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(ebook.imageUrl),
            Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 10, right: 10),
              child: Text(ebook.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                ebook.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 10, right: 10),
              child: Text(ebook.level,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
