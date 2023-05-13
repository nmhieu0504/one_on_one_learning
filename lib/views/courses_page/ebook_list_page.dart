import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/ebook.dart';
import 'package:one_on_one_learning/services/course_service.dart';
import 'package:one_on_one_learning/views/courses_page/ebook_card_component.dart';

import '../../utils/ui_data.dart';

class EBookList extends StatefulWidget {
  const EBookList({super.key});

  @override
  State<EBookList> createState() => _EBookListState();
}

class _EBookListState extends State<EBookList> {
  int page = 1;
  final int size = 10;

  bool _getMoreData = false;
  final ScrollController _scrollController = ScrollController();

  List<EBook> ebookList = [];
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

  final List<String> _sortingList = ["Ascending", "Descending"];
  String _currentSorting = "";

  bool _loading = true;
  bool _isFilter = false;

  final TextEditingController _searchController = TextEditingController();

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _getMoreData ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _levelFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: levelList.map((value) {
            return FilterChip(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(value["name"]),
              onSelected: (bool isSlected) {
                setState(() {
                  value["isSelected"] = isSlected;
                });
              },
              selected: value["isSelected"],
            );
          }).toList(),
        ));
  }

  Widget _categoryFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: courseContentCategories.map((value) {
            return FilterChip(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(value["title"]),
              onSelected: (bool isSlected) {
                setState(() {
                  value["isSelected"] = isSlected;
                });
              },
              selected: value["isSelected"],
            );
          }).toList(),
        ));
  }

  Widget _sortingTypelFilter() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Wrap(
          spacing: 10,
          children: _sortingList.map((value) {
            return FilterChip(
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
            );
          }).toList(),
        ));
  }

  Widget _buildFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const Text(
                  "Course Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: 'Search',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 16),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(15),
                        width: 18,
                        child: Image.asset(UIData.searchIcon),
                      )),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: const Text(
                  "Select Level",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            _levelFilter(),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: const Text(
                  "Select Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            _categoryFilter(),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: const Text(
                  "Sort by Level",
                  style: TextStyle(
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
                      child: const Text(
                        'Reset Filter',
                      )),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                  child: FilledButton(
                      onPressed: () {
                        ebookList.clear();
                        setState(() {
                          _isFilter = false;
                          _loading = true;
                          page = 1;
                        });
                        CoursesService.loadEbookList(
                          page: page++,
                          size: size,
                          courseContentCategories: courseContentCategories,
                          levelList: levelList,
                          sortingOrder: _currentSorting,
                          q: _searchController.text,
                        ).then((value) {
                          setState(() {
                            ebookList.addAll(value);
                            for (var element in ebookList) {
                              element.level =
                                  levelList[int.parse(element.level)]["name"];
                            }
                            _loading = false;
                          });
                        });
                      },
                      child: const Text(
                        'Apply',
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
    CoursesService.loadEbookList(
      page: page++,
      size: size,
    ).then((value) {
      setState(() {
        ebookList.addAll(value);
        for (var element in ebookList) {
          element.level = levelList[int.parse(element.level)]["name"];
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
        CoursesService.loadEbookList(
          page: page++,
          size: size,
          courseContentCategories: courseContentCategories,
          levelList: levelList,
          sortingOrder: _currentSorting,
          q: _searchController.text,
        ).then((value) {
          setState(() {
            ebookList.addAll(value);
            for (var element in ebookList) {
              element.level = levelList[int.parse(element.level)]["name"];
            }
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
        ? const Center(child: CircularProgressIndicator())
        : _isFilter
            ? _buildFilter()
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isFilter = true;
                              });
                            },
                            icon: const Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Filter",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                  ebookList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const SizedBox(height: 150),
                              Image.asset(UIData.noDataFound,
                                  width: 100, height: 100),
                              const SizedBox(height: 10),
                              const Text(
                                "No data",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ])
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ebookList.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return index == ebookList.length
                                ? _buildProgressIndicator()
                                : EbookCardComponent(ebook: ebookList[index]);
                          })
                ]),
              );
  }
}
