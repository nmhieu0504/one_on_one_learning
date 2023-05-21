// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:one_on_one_learning/models/schedule.dart';
import 'package:one_on_one_learning/services/schedule_services.dart';
import 'package:intl/intl.dart';

import '../../models/user.dart';
import '../../services/user_service.dart';
import '../../utils/countries_lis.dart';
import '../../utils/ui_data.dart';

import 'package:get/get.dart';
import 'package:one_on_one_learning/controllers/controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Controller controller = Get.find<Controller>();
  bool _isAvatarError = false;
  late final User user;
  bool _getMoreData = false;
  bool _loading = true;

  int _page = 1;
  final int _perPage = 20;
  final ScrollController _scrollController = ScrollController();
  final List<ScheduleModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    ScheduleServices.loadHistoryData(_page++, _perPage).then((value) {
      setState(() {
        _dataList.addAll(value);
        _loading = false;
      });
    });
    UserService.loadUserInfo().then((value) {
      user = value;
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _getMoreData = true;
        });
        ScheduleServices.loadHistoryData(_page++, _perPage).then((value) {
          setState(() {
            _dataList.addAll(value);
            _getMoreData = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _displaySuccessMotionToast(String str) {
    Get.snackbar(
      "",
      "",
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      duration: const Duration(milliseconds: 750),
      titleText: const Text("Ok",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      messageText: Text(str,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white)),
    );
  }

  List<Widget> _showRating(int rating) {
    List<Widget> list = [];
    for (int i = 0; i < rating; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    }
    while (list.length < 5) {
      list.add(const Icon(
        Icons.star,
        color: Colors.grey,
      ));
    }
    return list;
  }

  Widget _buildRatingList(List<dynamic> list, int dataListIndex) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) =>
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Text(
                  "${'rating'.tr}: ",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(children: _showRating(list[index]["rating"]))
              ]),
              TextButton(
                  onPressed: () {
                    _showRatingDialog(
                        dataListIndex: dataListIndex,
                        feedbackIndex: index,
                        initialRating: list[index]["rating"],
                        content: list[index]["content"],
                        isEdit: true,
                        id: list[index]["id"],
                        bookingId: list[index]["bookingId"]);
                  },
                  child: Obx(() => Text(
                        "edit_rating".tr,
                        style: TextStyle(
                            color: controller.blue_700_and_white.value),
                      ))),
            ]));
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _getMoreData ? 1.0 : 00,
          child: CircularProgressIndicator(
            color: controller.blue_700_and_white.value,
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(
      {required int dataListIndex,
      required int feedbackIndex,
      String tutorId = "",
      int initialRating = 5,
      String content = "",
      bool isEdit = false,
      String id = "",
      String bookingId = ""}) {
    int ratingStar = initialRating;
    TextEditingController contentRating = TextEditingController();
    contentRating.text = content;

    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
                child: AlertDialog(
              title: Text(
                'rate_for_this_lesson'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: initialRating.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      debugPrint(rating.toString());
                      ratingStar = rating.toInt();
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
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
                            color: controller.black_and_white_text.value,
                          ),
                          cursorColor: controller.blue_700_and_white.value,
                          controller: contentRating,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: controller.black_and_white_text.value,
                            ),
                            labelText: 'write_your_review'.tr,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: controller.blue_700_and_white.value,
                  ),
                  child: Text('submit'.tr,
                      style: TextStyle(
                          color: controller.black_and_white_card.value)),
                  onPressed: () {
                    ScheduleServices.feedbackTutor(
                            id: id,
                            bookingId: bookingId,
                            userId: tutorId,
                            rating: ratingStar,
                            content: contentRating.text,
                            isEdit: isEdit)
                        .then((value) {
                      setState(() {
                        _displaySuccessMotionToast('rating_success'.tr);
                        if (isEdit) {
                          _dataList[dataListIndex].feedbacks[feedbackIndex]
                              ["rating"] = ratingStar;
                          _dataList[dataListIndex].feedbacks[feedbackIndex]
                              ["content"] = contentRating.text;
                        } else {
                          _dataList[dataListIndex].feedbacks.add(value["data"]);
                        }
                      });
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.grey,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text('cancel'.tr,
                      style: const TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(
              color: controller.blue_700_and_white.value,
            ),
          )
        : Obx(() => RefreshIndicator(
              color: controller.blue_700_and_white.value,
              onRefresh: () async {
                setState(() {
                  _page = 1;
                  _dataList.clear();
                  _loading = true;
                });
                ScheduleServices.loadHistoryData(_page++, _perPage)
                    .then((value) {
                  setState(() {
                    _dataList.addAll(value);
                    _loading = false;
                  });
                });
              },
              child: _dataList.isEmpty
                  ? ListView(children: [
                      const SizedBox(height: 250),
                      Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(UIData.noDataFound,
                                  width: 100, height: 100),
                              const SizedBox(height: 10),
                              Text(
                                'no_data'.tr,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ]),
                      ),
                    ])
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _dataList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _dataList.length) {
                          return _buildProgressIndicator();
                        }
                        return Obx(() => Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: controller.black_and_white_card.value,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          DateFormat("EEE, dd MMM yyyy")
                                              .format(_dataList[index].date),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Text(
                                            "${DateFormat.Hm().format(_dataList[index].startTimestamp)} - ${DateFormat.Hm().format(_dataList[index].endTimestamp)}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    color:
                                        controller.black_and_white_card.value,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 15, 15, 15),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.grey[50],
                                            backgroundImage: _isAvatarError
                                                ? const AssetImage(
                                                    UIData.defaultAvatar)
                                                : NetworkImage(
                                                        _dataList[index].avatar)
                                                    as ImageProvider,
                                            onBackgroundImageError:
                                                (exception, stackTrace) {
                                              setState(() {
                                                _isAvatarError = true;
                                              });
                                            },
                                          ),
                                          title: Text(
                                            _dataList[index].name,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(children: <Widget>[
                                              const Icon(
                                                Icons.flag,
                                                color: Colors.blue,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  getCountryName(
                                                      _dataList[index].country),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    // padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: ExpansionTile(
                                            title: Text(
                                              'lesson_request'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: controller
                                                    .black_and_white_text.value,
                                              ),
                                            ),
                                            children: [
                                              Card(
                                                color: controller
                                                    .black_and_white_card.value,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  // height: 100,
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 25,
                                                              bottom: 30,
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(_dataList[
                                                                  index]
                                                              .studentRequest ??
                                                          "no_request".tr)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: ExpansionTile(
                                              title: Text(
                                                'lesson_review'.tr,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: controller
                                                      .black_and_white_text
                                                      .value,
                                                ),
                                              ),
                                              children: [
                                                Card(
                                                    color: controller
                                                        .black_and_white_card
                                                        .value,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .outline,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  12)),
                                                    ),
                                                    child: SizedBox(
                                                        width: double.infinity,
                                                        // height: 100,
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 25,
                                                                    bottom: 30,
                                                                    left: 10,
                                                                    right: 10),
                                                            child: !_dataList[index]
                                                                    .classReview
                                                                ? Text("no_review"
                                                                    .tr)
                                                                : Text("Lesson status: " +
                                                                    (_dataList[index].lessonStatus ??
                                                                        "") +
                                                                    (_dataList[index].behaviorComment != null
                                                                        ? "\nBehavior: ${_dataList[index].behaviorComment}"
                                                                        : "") +
                                                                    (_dataList[index].listeningComment != null
                                                                        ? "\nListening: ${_dataList[index].listeningComment}"
                                                                        : "") +
                                                                    (_dataList[index].speakingComment != null
                                                                        ? "\nSpeaking : ${_dataList[index].speakingComment}"
                                                                        : "") +
                                                                    (_dataList[index].vocabularyComment != null
                                                                        ? "\nVocabulary: ${_dataList[index].vocabularyComment}"
                                                                        : "") +
                                                                    (_dataList[index].homeworkComment !=
                                                                            null
                                                                        ? "\nHomework: ${_dataList[index].homeworkComment}"
                                                                        : "") +
                                                                    (_dataList[index].overallComment !=
                                                                            null
                                                                        ? "\nOverall comment: ${_dataList[index].overallComment}"
                                                                        : ""))))),
                                              ]),
                                        ),
                                        _dataList[index].feedbacks.isEmpty
                                            ? Container()
                                            : Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 15),
                                                child: _buildRatingList(
                                                    _dataList[index].feedbacks,
                                                    index))
                                      ],
                                    ),
                                  ),
                                  Card(
                                    color:
                                        controller.black_and_white_card.value,
                                    margin: const EdgeInsets.only(bottom: 0),
                                    elevation: 0,
                                    child: SizedBox(
                                      width: double.infinity,
                                      // height: 100,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: _dataList[index]
                                                      .feedbacks
                                                      .isNotEmpty
                                                  ? Container()
                                                  : TextButton(
                                                      onPressed: () {
                                                        _showRatingDialog(
                                                            tutorId:
                                                                _dataList[index]
                                                                    .tutorId,
                                                            dataListIndex:
                                                                index,
                                                            feedbackIndex: 0,
                                                            bookingId:
                                                                _dataList[index]
                                                                    .id);
                                                      },
                                                      child: Text(
                                                        "rating".tr,
                                                        style: TextStyle(
                                                            color: controller
                                                                .blue_700_and_white
                                                                .value),
                                                      )),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
            ));
  }
}
