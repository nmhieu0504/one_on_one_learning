// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_learning/models/chat_message.dart';
import 'package:bubble/bubble.dart';
import 'package:one_on_one_learning/services/chat_service.dart';
import 'package:one_on_one_learning/utils/web_socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String tutorId;
  const ChatPage({super.key, required this.tutorId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _loading = true;
  // bool _isConnected = true;
  late IO.Socket _socket;
  final textFieldController = TextEditingController();
  List<Message> messageList = [];
  int page = 1;
  final int perPage = 25;
  final ScrollController _scrollController = ScrollController();

  void _connectToServer() {
    _socket = IO.io(
      WebSocket.SOCKET_URL,
      <String, dynamic>{
        "transports": ["websocket"],
        // "forceNew": true,
        "EIO": "4",
        // "auth": {
        //   "token":
        //       "${AppKey.authorization} ${SPref.instance.get(AppKey.authorization)}"
        // }
      },
    );
    _socket.onConnect((_) {
      debugPrint('CONNECT STATUS: CONNECT');
      // _socket.emitWithAck(
      //     "chat:join-room", {"idGroup": "_groupController.targetGroup?.id"},
      //     ack: (value) {
      //   debugPrint("ACK JOIN CHAT ROOM: $value");
      // });
      // _getAllMessage();
    });
    debugPrint("CONNECT STATUS: ${_socket.connected}");
  }

  void _getAllMessage() {
    _socket.emitWithAck(
        "chat:get-all-message", {"idGroup": "_groupController.targetGroup?.id"},
        ack: (Map<String, dynamic> value) {
      setState(() {
        // _isConnected = true;
        debugPrint("ACK GET ALL MESSAGE: $value");
        final data = value["messages"];
        debugPrint("DATA: $data");

        data.forEach((e) {
          messageList.add(Message(
              userID: e["userID"],
              message: e["data"]["content"],
              date: DateTime.parse(e["createdAt"]),
              sentByMe: e["userID"] == "_currentUser?.uid"));
        });
      });
    });
    _socket.on("chat:receive-message", (data) {
      debugPrint("MESSAAGE RECEIVED: $data");
      // setState(() {
      //   String photoURL = findSentUserImg(data["userID"]) ?? defaultAvatar;
      //   messageList.add(Message(
      //       photoURL: photoURL,
      //       userID: data["userID"],
      //       message: data["data"]["content"],
      //       date: DateTime.parse(data["createdAt"]),
      //       sentByMe: data["userID"] == _currentUser?.uid));
      // });
    });
  }

  @override
  void initState() {
    super.initState();
    _connectToServer();
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
    _socket.emitWithAck(
        "chat:leave-room", {"idGroup": "_groupController.targetGroup?.id"},
        ack: (value) {
      _socket.dispose();
      debugPrint("ACK LEAVE CHAT ROOM: $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
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
                                      : Colors.grey[200],
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                        color: message.sentByMe
                                            ? Colors.white
                                            : Colors.black),
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
                        primaryColor: Colors.blue,
                      ),
                      child: TextField(
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          hintText: "Send a message ...",
                          contentPadding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              _socket.emitWithAck("chat:send-message", {
                                "idGroup": "_groupController.targetGroup?.id",
                                "content": textFieldController.text,
                                "type": "text"
                              }, ack: (value) {
                                debugPrint("ACK SEND MESSAGE: $value");
                              });
                              setState(() {
                                messageList.add(Message(
                                    userID: "userID",
                                    message: textFieldController.text,
                                    date: DateTime.now(),
                                    sentByMe: true));
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
