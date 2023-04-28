// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:one_on_one_learning/models/schedule.dart';
import 'package:one_on_one_learning/services/schedule_services.dart';
import 'package:intl/intl.dart';

import '../../utils/countries_lis.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _getMoreData = false;
  bool _loading = true;

  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  List<ScheduleModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    ScheduleServices.loadHistoryData(_page++, 20).then((value) {
      setState(() {
        _dataList.addAll(value);
        _loading = false;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _getMoreData = true;
        });
        ScheduleServices.loadHistoryData(_page++, 20).then((value) {
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

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: _scrollController,
            itemCount: _dataList.length + 1,
            itemBuilder: (context, index) {
              if (index == _dataList.length) {
                return _buildProgressIndicator();
              }
              return Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color.fromARGB(255, 74, 20, 140)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                          child: ListTile(
                            leading: Image.network(
                              _dataList[index].avatar,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              _dataList[index].name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(children: <Widget>[
                                const Icon(
                                  Icons.flag,
                                  color: Colors.blue,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    getCountryName(_dataList[index].country),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: ExpansionTile(
                              title: const Text(
                                'Lesson request',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              children: [
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    // height: 100,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 25,
                                            bottom: 30,
                                            left: 10,
                                            right: 10),
                                        child: Text(
                                            _dataList[index].studentRequest ??
                                                "No request")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: ExpansionTile(
                                title: const Text(
                                  'Lesson review',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                children: [
                                  Card(
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
                                      child: SizedBox(
                                          width: double.infinity,
                                          // height: 100,
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 25,
                                                  bottom: 30,
                                                  left: 10,
                                                  right: 10),
                                              child: !_dataList[index].classReview
                                                  ? const Text("No review")
                                                  : Text("Lesson status: " +
                                                      (_dataList[index]
                                                              .lessonStatus ??
                                                          "") +
                                                      (_dataList[index].behaviorComment !=
                                                              null
                                                          ? "\nBehavior: ${_dataList[index].behaviorComment}"
                                                          : "") +
                                                      (_dataList[index]
                                                                  .listeningComment !=
                                                              null
                                                          ? "\nListening: ${_dataList[index].listeningComment}"
                                                          : "") +
                                                      (_dataList[index]
                                                                  .speakingComment !=
                                                              null
                                                          ? "\nSpeaking : ${_dataList[index].speakingComment}"
                                                          : "") +
                                                      (_dataList[index]
                                                                  .vocabularyComment !=
                                                              null
                                                          ? "\nVocabulary: ${_dataList[index].vocabularyComment}"
                                                          : "") +
                                                      (_dataList[index]
                                                                  .homeworkComment !=
                                                              null
                                                          ? "\nHomework: ${_dataList[index].homeworkComment}"
                                                          : "") +
                                                      (_dataList[index]
                                                                  .overallComment !=
                                                              null
                                                          ? "\nOverall comment: ${_dataList[index].overallComment}"
                                                          : ""))))),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 0),
                      elevation: 0,
                      child: SizedBox(
                        width: double.infinity,
                        // height: 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text('Rating')),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text('Report')),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              );
            });
  }
}
