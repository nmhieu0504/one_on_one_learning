// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  late bool isEnglish;
  late bool isDarkTheme;
  var bannerBackground = Colors.blue[900].obs;
  var blue_700_and_white = Colors.blue[700].obs;
  var black_and_white_card = Colors.white.obs;
  var black_and_grey_300 = Colors.grey[300].obs;
  var black_and_white_text = Colors.white.obs;
  var grey_100_and_grey_850 = Colors.grey[100].obs;
  var blue_700_and_black = Colors.blue[700].obs;

  void onChangeTheme() {
    if (isDarkTheme) {
      bannerBackground.value = const Color.fromARGB(255, 30, 30, 30);
      blue_700_and_white.value = Colors.white;
      black_and_white_card.value = const Color.fromARGB(255, 25, 25, 26);
      black_and_grey_300.value = Colors.black;
      black_and_white_text.value = Colors.white;
      grey_100_and_grey_850.value = Colors.grey[850];
      blue_700_and_black.value = Colors.black;
    } else {
      bannerBackground.value = Colors.blue[900];
      blue_700_and_white.value = Colors.blue[700];
      black_and_white_card.value = Colors.white;
      black_and_grey_300.value = Colors.grey[300];
      black_and_white_text.value = Colors.black;
      grey_100_and_grey_850.value = Colors.grey[100];
      blue_700_and_black.value = Colors.blue[700];
    }
  }
}
