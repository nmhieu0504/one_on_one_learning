import 'package:flutter/material.dart';
import 'package:one_on_one_learning/pages/courses_page/courses_list_page.dart';
import 'package:one_on_one_learning/pages/courses_page/ebook_list_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        controller: _tabController,
        labelColor: Colors.black,
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        tabs: const <Widget>[
          Tab(
            text: 'Courses',
          ),
          Tab(
            text: 'E-Book',
          ),
          Tab(
            text: 'Interactive E-Book',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          CoursesList(),
          EBookList(),
          Center(
            child: Text("No Data"),
          ),
        ],
      ),
    );
  }
}
