import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/courses_page/courses_page.dart';
import 'package:one_on_one_learning/views/history_page/history_page.dart';
import 'package:one_on_one_learning/views/home_page/home_page.dart';
import 'package:one_on_one_learning/views/schedule_page/schedule_page.dart';
import 'package:one_on_one_learning/views/settings_page/settings_page.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => NavigatorStatePage();
}

class NavigatorStatePage extends State<NavigatorPage> {
  int _selectedIndex = 0;
  String _appBarTitle = 'Tutors';

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SchedulePage(),
    HistoryPage(),
    CoursesPage(),
    Text(
      'Index 4: Settings',
      style: optionStyle,
    ),
  ];

  static const List<String> _appBarTitles = <String>[
    'Tutors',
    'Schedule',
    'History',
    'Courses',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _appBarTitle = _appBarTitles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _appBarTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
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
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer_outlined,
            ),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_sharp,
            ),
            label: 'Courses',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
