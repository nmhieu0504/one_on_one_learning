import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:one_on_one_learning/controllers/controller.dart';
import 'package:one_on_one_learning/services/course_service.dart';
import 'package:one_on_one_learning/views/courses_page/course_card_component.dart';

import '../../models/course.dart';
import '../../utils/ui_data.dart';

import 'package:get/get.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});
  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  Controller controller = Get.find();
  int page = 1;
  final int size = 10;

  bool _getMoreData = false;
  final ScrollController _scrollController = ScrollController();

  List<Course> coursesList = [];
  late List<Map<String, dynamic>> courseContentCategories;

  List<Map<String, dynamic>> levelList = [
    {"name": "Any Level", "isSelected": false},
    {"name": "Beginner", "isSelected": false},
    {"name": "Upper-Beginner", "isSelected": false},
    {"name": "Pre-Intermediate", "isSelected": false},
    {"name": "Intermediate", "isSelected": false},
    {"name": "Upper-Intermediate", "isSelected": false},
    {"name": "Pre-Advanced", "isSelected": false},
    {"name": "Advanced", "isSelected": false},
    {"name": "Very Advanced", "isSelected": false}
  ];

  final List<String> _sortingList = ["ascending".tr, "descending".tr];
  String _currentSorting = "";

  bool _loading = true;
  bool _isFilter = false;

  final TextEditingController _searchController = TextEditingController();

  Widget _levelFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: levelList.map((value) {
            return Obx(() => FilterChip(
                  backgroundColor: controller.black_and_white_card.value,
                  selectedColor: controller.blue_100_and_blue_400.value,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  label: Text(value["name"]),
                  onSelected: (bool isSlected) {
                    setState(() {
                      value["isSelected"] = isSlected;
                    });
                  },
                  selected: value["isSelected"],
                ));
          }).toList(),
        ));
  }

  Widget _categoryFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: courseContentCategories.map((value) {
            return Obx(() => FilterChip(
                  backgroundColor: controller.black_and_white_card.value,
                  selectedColor: controller.blue_100_and_blue_400.value,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  label: Text(value["title"]),
                  onSelected: (bool isSlected) {
                    setState(() {
                      value["isSelected"] = isSlected;
                    });
                  },
                  selected: value["isSelected"],
                ));
          }).toList(),
        ));
  }

  Widget _sortingTypelFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: _sortingList.map((value) {
            return Obx(() => FilterChip(
                  backgroundColor: controller.black_and_white_card.value,
                  selectedColor: controller.blue_100_and_blue_400.value,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  label: Text(value),
                  onSelected: (bool isSlected) {
                    setState(() {
                      if (isSlected) {
                        _currentSorting = value;
                      } else {
                        _currentSorting = "";
                      }
                    });
                  },
                  selected: value == _currentSorting,
                ));
          }).toList(),
        ));
  }

  Widget _buildFilter() {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Text(
                  "course_name".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Obx(() => Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SizedBox(
                    height: 40,
                    child: Theme(
                      data: ThemeData(
                        useMaterial3: controller.isDarkTheme,
                        primaryColor: controller.blue_700_and_white.value,
                        primaryColorDark: controller.blue_700_and_white.value,
                      ),
                      child: Theme(
                        data: ThemeData(
                          useMaterial3: true,
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            primary: controller.blue_700_and_white.value,
                            secondary: controller.black_and_white_text.value,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: controller.black_and_white_text.value),
                            ),
                          ),
                        ),
                        child: TextField(
                          style: TextStyle(
                              color: controller.black_and_white_text.value),
                          cursorColor: controller.blue_700_and_white.value,
                          controller: _searchController,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              hintText: 'search'.tr,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: controller.black_and_white_text.value,
                                  fontSize: 16),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(15),
                                width: 18,
                                child: Image.asset(UIData.searchIcon,
                                    color:
                                        controller.black_and_white_text.value),
                              )),
                        ),
                      ),
                    ),
                  ),
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  "select_level".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            _levelFilter(),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  "select_category".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            _categoryFilter(),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  "sort_by_level".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            _sortingTypelFilter(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          for (var element in levelList) {
                            element["isSelected"] = false;
                          }
                          for (var element in courseContentCategories) {
                            element["isSelected"] = false;
                          }
                          _searchController.text = "";
                          _currentSorting = "";
                        });
                      },
                      child: Obx(() => Text(
                            'reset_filter'.tr,
                            style: TextStyle(
                                color: controller.blue_700_and_white.value),
                          ))),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                      ),
                      onPressed: () {
                        page = 1;
                        coursesList.clear();
                        setState(() {
                          _isFilter = false;
                          _loading = true;
                        });
                        CoursesService.loadCoursesList(
                          page: page++,
                          size: size,
                          courseContentCategories: courseContentCategories,
                          levelList: levelList,
                          sortingOrder: _currentSorting == "ascending".tr
                              ? false
                              : _currentSorting == "descending".tr
                                  ? true
                                  : null,
                          q: _searchController.text,
                        ).then((value) {
                          setState(() {
                            coursesList.addAll(value);
                            for (var element in coursesList) {
                              element.level =
                                  levelList[int.parse(element.level)]["name"];
                              element.topics.sort((a, b) =>
                                  a["orderCourse"].compareTo(b["orderCourse"]));
                            }
                            _loading = false;
                          });
                        });
                      },
                      child: Text(
                        'apply_filter'.tr,
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
              ],
            )
          ])),
    );
  }

  @override
  void initState() {
    super.initState();
    CoursesService.loadCoursesList(
      page: page++,
      size: size,
    ).then((value) {
      setState(() {
        coursesList.addAll(value);
        for (var element in coursesList) {
          element.level = levelList[int.parse(element.level)]["name"];
          element.topics
              .sort((a, b) => a["orderCourse"].compareTo(b["orderCourse"]));
        }
        _loading = false;
      });
    });
    CoursesService.loadContentCategory().then((value) {
      setState(() {
        courseContentCategories = value;
        for (var element in courseContentCategories) {
          element["isSelected"] = false;
        }
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _getMoreData = true;
        });
        CoursesService.loadCoursesList(
          page: page++,
          size: size,
          courseContentCategories: courseContentCategories,
          levelList: levelList,
          sortingOrder: _currentSorting == "ascending".tr
              ? false
              : _currentSorting == "descending".tr
                  ? true
                  : null,
          q: _searchController.text,
        ).then((value) {
          setState(() {
            for (var element in value) {
              element.level = levelList[int.parse(element.level)]["name"];
            }
            coursesList.addAll(value);
            _loading = false;
            _getMoreData = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.blue[700],
          ))
        : _isFilter
            ? _buildFilter()
            : Stack(children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: Obx(() => TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isFilter = true;
                                });
                              },
                              icon: Icon(Icons.filter_alt_outlined,
                                  color: controller.black_and_white_text.value),
                              label: Text(
                                "filter".tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        controller.black_and_white_text.value),
                              ))),
                        ),
                      ],
                    ),
                    coursesList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const SizedBox(height: 200),
                                Image.asset(UIData.noDataFound,
                                    width: 100, height: 100),
                                const SizedBox(height: 10),
                                Text(
                                  "no_data".tr,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ])
                        : GroupedListView<dynamic, String>(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            elements: coursesList,
                            groupBy: (element) => element.categories,
                            // groupComparator: (value1, value2) => value2.compareTo(value1),
                            // itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']),
                            groupSeparatorBuilder: (String value) => Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(
                                value,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            indexedItemBuilder: (context, element, index) {
                              return CourseCardComponent(
                                course: element,
                              );
                            },
                          ),
                  ]),
                ),
                _getMoreData
                    ? Opacity(
                        opacity: 0.8,
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]);
  }
}
