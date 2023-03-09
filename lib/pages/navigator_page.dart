import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/courses_page.dart';
import 'package:one_on_one_learning/pages/history_page.dart';
import 'package:one_on_one_learning/pages/home_page.dart';
import 'package:one_on_one_learning/pages/schedule_page.dart';
import '../ui_data.dart';

class PageNavigator extends StatefulWidget {
  const PageNavigator(this.title, {super.key});

  final String title;

  @override
  State<PageNavigator> createState() => PageNavigatorState();
}

class PageNavigatorState extends State<PageNavigator> {
  int _selectedIndex = 0;
  String _appBarTitle = 'Tutors';

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    HistoryPage(),
    SchedulePage(),
    CoursesPage(),
    Text(
      'Index 4: Settings',
      style: optionStyle,
    ),
  ];

  static const List<String> _appBarTitles = <String>[
    'Tutors',
    'History',
    'Schedule',
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
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
            ),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer_outlined,
            ),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_sharp,
            ),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        selectedIconTheme: const IconThemeData(color: Colors.blue),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
      ),
    );
  }
}
