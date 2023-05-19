import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import '../../models/schedule.dart';
import '../../services/schedule_services.dart';
import '../../utils/countries_lis.dart';
import 'package:intl/intl.dart';

import '../../utils/ui_data.dart';
import 'package:get/get.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool _isAvatarError = false;
  bool _getMoreData = false;
  bool _loading = true;
  final _reason = [
    'cancel_schedule_reason_1'.tr,
    'cancel_schedule_reason_2'.tr,
    'cancel_schedule_reason_3'.tr,
    'cancel_schedule_reason_4'.tr,
  ];
  String? _currentReason = 'cancel_schedule_reason_1'.tr;

  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final List<ScheduleModel> _dataList = [];

  final TextEditingController _cancelController = TextEditingController();
  late List<TextEditingController> _requestControllerList;
  late List<bool> _isEditList;

  @override
  void initState() {
    super.initState();
    ScheduleServices.loadScheduleData(_page++, 20).then((value) {
      setState(() {
        _dataList.addAll(value);
        _requestControllerList = List.generate(
            _dataList.length,
            (index) => TextEditingController()
              ..text = _dataList[index].studentRequest ?? "");
        _isEditList = List.generate(_dataList.length, (index) => false);
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
            _requestControllerList = List.generate(
                _dataList.length,
                (index) => TextEditingController()
                  ..text = _dataList[index].studentRequest ?? "");
            _isEditList = List.generate(_dataList.length, (index) => false);
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

  List<Widget> _buildCancelReasonCheckbox(
      void Function(void Function()) setState) {
    var list = <Widget>[];
    for (var i = 0; i < _reason.length; i++) {
      list.add(
        RadioListTile(
          activeColor: Colors.blue,
          title: Text(_reason[i]),
          value: _reason[i],
          groupValue: _currentReason,
          onChanged: (value) {
            setState(() {
              _currentReason = value;
            });
          },
        ),
      );
    }
    return list;
  }

  Future<void> cancelSchduleService(
      String scheduleDetailId, String note, int cancelReasonId) async {
    bool result = await ScheduleServices.deleteSchdule(
        scheduleDetailId, note, cancelReasonId);
    if (result) {
      _displaySuccessMotionToast("cancel_schedule_success".tr);
    } else {
      _displayErrorMotionToast("cancel_schedule_error".tr);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> editRequestService(String id, String studentRequest) async {
    bool result =
        await ScheduleServices.updateScheduleRequest(id, studentRequest);
    if (result) {
      _displaySuccessMotionToast("edit_request_success".tr);
    } else {
      _displayErrorMotionToast("edit_request_error".tr);
    }
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

  void _displaySuccessMotionToast(String str) {
    MotionToast.success(
      height: 60,
      width: 300,
      description: Text(str,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 70, 146, 60))),
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
                  title: Text('cancel_schedule'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text("cancel_schedule_why".tr,
                        style: const TextStyle(fontSize: 18)),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: StatefulBuilder(builder: (context, setState) {
                          return ListBody(
                              children: _buildCancelReasonCheckbox(setState));
                        })),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: _cancelController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'enter_your_reason'.tr,
                        ),
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
                          _requestControllerList.removeAt(index);
                          _isEditList.removeAt(index);
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
                        _currentReason = _reason[0];
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
                      Text(
                        'no_data'.tr,
                        style: const TextStyle(color: Colors.grey),
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
                                                  child: Row(children: <Widget>[
                                                    const Icon(Icons.delete,
                                                        color: Colors.red),
                                                    Text('cancel'.tr,
                                                        style: const TextStyle(
                                                            color: Colors.red)),
                                                  ]),
                                                  onPressed: () {
                                                    _showCancelDialog(index);
                                                  }),
                                        ]),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, top: 5, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'lesson_request'.tr,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isEditList[index] =
                                                      !_isEditList[index];
                                                  if (!_isEditList[index]) {
                                                    editRequestService(
                                                        _dataList[index].id,
                                                        _requestControllerList[
                                                                index]
                                                            .text);
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                _isEditList[index]
                                                    ? Icons.save
                                                    : Icons.edit,
                                                size: 25,
                                              ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                            left: 10,
                                            right: 10),
                                        child: TextField(
                                          enabled: _isEditList[index],
                                          maxLines: 2,
                                          controller:
                                              _requestControllerList[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                          ),
                                        )),
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
