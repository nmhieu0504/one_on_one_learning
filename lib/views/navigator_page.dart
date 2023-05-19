import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/courses_page/courses_page.dart';
import 'package:one_on_one_learning/views/history_page/history_page.dart';
import 'package:one_on_one_learning/views/home_page/home_page.dart';
import 'package:one_on_one_learning/views/schedule_page/schedule_page.dart';
import 'package:one_on_one_learning/views/settings_page/settings_page.dart';
import 'package:one_on_one_learning/views/chat_gpt_page/chat_gpt_page.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => NavigatorStatePage();
}

class NavigatorStatePage extends State<NavigatorPage> {
  Controller controller = Get.find();

  int _selectedIndex = 0;
  String _appBarTitle = 'home'.tr;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SchedulePage(),
    HistoryPage(),
    CoursesPage(),
  ];

  static final List<String> _appBarTitles = <String>[
    'home'.tr,
    'schedule'.tr,
    'history'.tr,
    'courses'.tr,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _appBarTitle = _appBarTitles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              _appBarTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const ChatGPTPage();
                      }),
                    );
                  },
                  icon: const Icon(
                    Icons.headset_mic,
                  )),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const SettingsPage();
                    }),
                  );
                },
              ),
            ],
          ),
          body: Obx(() => Container(
                color: controller.black_and_grey_300.value,
                child: SafeArea(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              )),
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home,
                ),
                label: 'home'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.timer_outlined,
                ),
                label: 'schedule'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.history,
                ),
                label: 'history'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.menu_book_sharp,
                ),
                label: 'courses'.tr,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: controller.blue_700_and_white.value,
          ),
        ));
  }
}
