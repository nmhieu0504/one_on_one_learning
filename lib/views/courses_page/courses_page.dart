import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/courses_page/courses_list_page.dart';
import 'package:one_on_one_learning/views/courses_page/ebook_list_page.dart';

import '../../utils/ui_data.dart';
import 'package:get/get.dart';

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
        children: <Widget>[
          const CoursesList(),
          const EBookList(),
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(UIData.noDataFound, width: 100, height: 100),
              const SizedBox(height: 10),
              Text(
                "no_data".tr,
                style: const TextStyle(color: Colors.grey),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
