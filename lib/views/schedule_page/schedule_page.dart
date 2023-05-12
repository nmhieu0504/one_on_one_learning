import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import '../../models/schedule.dart';
import '../../services/schedule_services.dart';
import '../../utils/countries_lis.dart';
import 'package:intl/intl.dart';

import '../../utils/ui_data.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool _getMoreData = false;
  bool _loading = true;
  final _reason = [
    'Reschedule at another time',
    'Busy at that time',
    'Asked by the tutor',
    'Other'
  ];
  String? _currentReason = 'Reschedule at another time';

  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final List<ScheduleModel> _dataList = [];

  final TextEditingController _cancelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScheduleServices.loadScheduleData(_page++, 20).then((value) {
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
        ScheduleServices.loadScheduleData(_page++, 20).then((value) {
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

  List<Widget> _buildCancelReasonCheckbox() {
    var list = <Widget>[];
    for (var i = 0; i < _reason.length; i++) {
      list.add(
        ListTile(
          title: Text(_reason[i]),
          leading: Radio<String>(
            value: _reason[i],
            groupValue: _currentReason,
            onChanged: (String? value) {
              setState(() {
                _currentReason = value;
              });
            },
          ),
        ),
      );
    }
    return list;
  }

  Future<void> cancelSchduleService(
      String scheduleDetailId, String note, int cancelReasonId) async {
    bool result = await ScheduleServices.deleteSchdule(
        scheduleDetailId, note, cancelReasonId);
    setState(() {
      _loading = false;
    });
  }

  void _displayErrorMotionToast(String errorMessage) {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(errorMessage),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  void _showCancelDialog(int index) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text('Cancel Schedule',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text("What was the reason you cancel this booking?",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: _buildCancelReasonCheckbox())),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: _cancelController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your reason here'),
                      ),
                    ),
                  ]),
                  actions: <Widget>[
                    FilledButton(
                      style: FilledButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text(
                        'Ok',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          cancelSchduleService(
                              _dataList[index].scheduleDetailId ?? "",
                              _cancelController.text,
                              _reason.indexOf(_currentReason ?? "") + 1);
                          _loading = true;
                          _dataList.removeAt(index);
                        });

                        Navigator.of(context).pop();
                      },
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey,
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        _cancelController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _dataList.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(UIData.noDataFound, width: 100, height: 100),
                      const SizedBox(height: 10),
                      const Text(
                        "No data",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _dataList.length + 1,
                itemBuilder: (context, index) {
                  return index == _dataList.length
                      ? _buildProgressIndicator()
                      : Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 74, 20, 140)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
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
                                  ],
                                ),
                              ),
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
                                margin: const EdgeInsets.only(bottom: 20),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
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
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              getCountryName(
                                                  _dataList[index].country),
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
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "${DateFormat.Hm().format(_dataList[index].startTimestamp)} - ${DateFormat.Hm().format(_dataList[index].endTimestamp)}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          _dataList[index]
                                                      .startTimestamp
                                                      .difference(
                                                          DateTime.now())
                                                      .inMinutes <=
                                                  120
                                              ? Container()
                                              : OutlinedButton(
                                                  style: ButtonStyle(
                                                    side: MaterialStateProperty
                                                        .all<BorderSide>(
                                                      const BorderSide(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                      children: const <Widget>[
                                                        Icon(Icons.delete,
                                                            color: Colors.red),
                                                        Text('Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      ]),
                                                  onPressed: () {
                                                    _showCancelDialog(index);
                                                  }),
                                        ]),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: const Text(
                                        'Lesson request',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
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
                                                top: 30,
                                                bottom: 30,
                                                left: 10,
                                                right: 10),
                                            child: Text(_dataList[index]
                                                    .studentRequest ??
                                                "No request")),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                },
              );
  }
}
