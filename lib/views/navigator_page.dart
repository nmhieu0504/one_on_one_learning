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
    'home',
    'schedule',
    'history',
    'courses',
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
              _appBarTitle.tr,
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
                color: controller.black_and_grey_200.value,
                child: SafeArea(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              )),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: controller.black_and_white_card.value,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedItemColor: Colors.grey,
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
