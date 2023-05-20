import 'package:flutter/material.dart';
import 'package:one_on_one_learning/views/courses_page/courses_list_page.dart';
import 'package:one_on_one_learning/views/courses_page/ebook_list_page.dart';

import '../../controllers/controller.dart';
import '../../utils/ui_data.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with TickerProviderStateMixin {
  Controller controller = Get.find();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TabBar(
            indicatorColor: controller.blue_700_and_white.value,
            isScrollable: true,
            controller: _tabController,
            labelColor: controller.blue_700_and_white.value,
            labelStyle: TextStyle(
              fontSize: 18,
              color: controller.blue_700_and_white.value,
            ),
            tabs: <Widget>[
              Tab(
                text: 'courses'.tr,
              ),
              const Tab(
                text: 'E-Book',
              ),
              const Tab(
                text: 'Interactive E-Book',
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                  
                  child: const CoursesList()),
              Container(
                  
                  child: const EBookList()),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
        ));
  }
}
