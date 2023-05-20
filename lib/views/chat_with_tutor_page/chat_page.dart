// ignore_for_file: library_prefixes

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_learning/models/chat_message.dart';
import 'package:bubble/bubble.dart';
import 'package:one_on_one_learning/services/chat_service.dart';
import 'package:one_on_one_learning/services/user_service.dart';
import 'package:one_on_one_learning/utils/web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';

import '../../controllers/controller.dart';

class ChatPage extends StatefulWidget {
  final String tutorId;
  const ChatPage({super.key, required this.tutorId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Controller controller = Get.find();
  bool _loading = true;
  final textFieldController = TextEditingController();
  List<Message> messageList = [];
  int page = 1;
  final int perPage = 25;
  final ScrollController _scrollController = ScrollController();

  late final WebSocketChannel channel;
  var infoLogin;

  void connectToWebSocket() async {
    infoLogin = await UserService.loadUserInfo(isSocketCall: true);

    channel = WebSocketChannel.connect(Uri.parse(WebSocketChat.SOCKET_URL));
    channel.stream.listen((message) {
      debugPrint("RAW MESSAGE: $message");
      // Define a regular expression pattern to match the number followed by the object
      RegExp pattern = RegExp(r'^(\d{1,2})(.*)$');
      // Extract the number and the object using the regular expression pattern
      RegExpMatch? match = pattern.firstMatch(message);

      if (match != null) {
        // Extract the number and the object from the matched groups
        String? code = match.group(1);
        String? object = match.group(2);

        debugPrint('Code: $code');
        debugPrint('Object: $object');

        if (code == "0") {
          channel.sink.add("40");
          debugPrint("SENDING: 40");
        }
        if (code == "40") {
          List<dynamic> obj = ["connection:login", infoLogin];
          String messageLogin = "42${jsonEncode(obj)}";
          debugPrint("LOGIN: $messageLogin");
          channel.sink.add(messageLogin);
          debugPrint("SENDING: 42");
        }
        if (code == "2") {
          channel.sink.add("3");
          debugPrint("SENDING: 3");
        }
        if (code == "42") {
          List<dynamic> obj = jsonDecode(object!);
          if (obj[0] == "chat:returnNewMessage" &&
              obj[1]["message"]["fromId"] == widget.tutorId) {
            setState(() {
              messageList.add(Message(
                  userID: obj[1]["message"]["fromId"],
                  message: obj[1]["message"]["content"],
                  date: DateTime.now(),
                  sentByMe: false));
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    ChatService.loadMessage(widget.tutorId, page++, perPage).then((value) {
      setState(() {
        if (value != null) {
          _loading = false;
          messageList.addAll(value);
        }
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ChatService.loadMessage(widget.tutorId, page++, perPage).then((value) {
          setState(() {
            if (value != null) {
              messageList.addAll(value);
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue[700],
                ))
              : Column(children: [
                  Expanded(
                    child: GroupedListView<Message, DateTime>(
                      controller: _scrollController,
                      order: GroupedListOrder.DESC,
                      reverse: true,
                      padding: const EdgeInsets.all(10),
                      elements: messageList,
                      groupBy: (message) => DateTime(
                        message.date.year,
                        message.date.month,
                        message.date.day,
                      ),
                      groupHeaderBuilder: (Message message) => Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              DateFormat.yMMMMEEEEd().format(message.date),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11.0)),
                        ),
                      ),
                      itemComparator: (element1, element2) =>
                          element1.date.compareTo(element2.date),
                      indexedItemBuilder: (context, message, index) {
                        return Column(children: [
                          Row(children: [
                            Expanded(
                              child: Bubble(
                                  margin: BubbleEdges.only(
                                    top: 5,
                                    bottom: 5,
                                    left: message.sentByMe ? 60 : 0,
                                    right: message.sentByMe ? 0 : 60,
                                  ),
                                  alignment: message.sentByMe
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  nip: message.sentByMe
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                                  color: message.sentByMe
                                      ? Colors.blue
                                      : controller.grey_100_and_grey_850.value,
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                        color: message.sentByMe
                                            ? Colors.white
                                            : controller
                                                .black_and_white_text.value),
                                  )),
                            ),
                          ]),
                        ]);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
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
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          hintText: "send_a_meesage".tr,
                          hintStyle: TextStyle(
                              color: controller.black_and_white_text.value,
                              fontWeight: FontWeight.normal),
                          contentPadding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: controller.blue_700_and_white.value,
                            ),
                            onPressed: () {
                              setState(() {
                                messageList.add(Message(
                                    userID: "userID",
                                    message: textFieldController.text,
                                    date: DateTime.now(),
                                    sentByMe: true));
                                channel.sink.add("42${jsonEncode([
                                      "chat:sendMessage",
                                      {
                                        "fromId": infoLogin["user"]["id"],
                                        "toId": widget.tutorId,
                                        "content": textFieldController.text
                                      }
                                    ])}");
                              });
                              textFieldController.clear();
                            },
                          ),
                        ),
                        controller: textFieldController,
                      ),
                    ),
                  )
                ])),
    );
  }
}
