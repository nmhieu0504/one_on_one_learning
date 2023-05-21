// ignore_for_file: avoid_print

import 'package:one_on_one_learning/services/chat_gpt_service/chat_gpt_ultis.dart';
import 'package:one_on_one_learning/models/db_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/controller.dart';
import '../../models/message.dart';
import 'package:bubble/bubble.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';

class ChatGPTPage extends StatefulWidget {
  const ChatGPTPage({super.key});

  @override
  State<ChatGPTPage> createState() => _ChatGPTPageState();
}

enum TtsLanguage { en, vn }

class _ChatGPTPageState extends State<ChatGPTPage> {
  Controller controller = Get.find<Controller>();
  final textFieldController = TextEditingController();
  final ChatGPTUltils chatGPTUltils = ChatGPTUltils();
  List<Message> messageList = [];

  FlutterTts flutterTts = FlutterTts();
  TtsLanguage languages = TtsLanguage.en;
  late bool isEnglish;
  late bool isVietnamese;

  bool isAutoTTS = true;

  bool isButtonDisabled = ChatGPTUltils.isProcessing;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadMessage();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAutoTTS = prefs.getBool('isAutoTTS') ?? true;
      isEnglish = prefs.getBool('isEnglish') ?? true;
      isVietnamese = prefs.getBool('isVietnamese') ?? false;
    });
    languages = isEnglish ? TtsLanguage.en : TtsLanguage.vn;
    flutterTts.setLanguage(isEnglish ? "en-US" : "vi-VN");
  }

  Future<void> _loadMessage() async {
    messageList = await DB_Ultils.loadAll();
    ChatGPTUltils.totalTokens =
        (await SharedPreferences.getInstance()).getInt("totalTokens") ?? 0;
    for (var element in messageList) {
      ChatGPTUltils.history.add({
        "role": element.isUser ? "user" : "assistant",
        "content": element.message
      });
    }
    setState(() {
      _loading = false;
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            textFieldController.text = val.recognizedWords;
            // if (val.hasConfidenceRating && val.confidence > 0) {
            //   _confidence = val.confidence;
            // }
          }),
        );
      }
    } else {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                  // color: Colors.blue,
                  ),
              child: Text(
                'settings'.tr,
                style: const TextStyle(
                  // color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: Text('auto_tts_reply'.tr),
            trailing: Switch(
                activeColor: Colors.blue[700],
                value: isAutoTTS,
                onChanged: (value) async {
                  setState(() {
                    isAutoTTS = value;
                  });
                  // obtain shared preferences
                  final prefs = await SharedPreferences.getInstance();
                  // set value
                  prefs.setBool('isAutoTTS', value);
                }),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text('speech_language'.tr),
            onTap: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () async {
                            Navigator.pop(context);
                            setState(() {
                              languages = TtsLanguage.en;
                              isEnglish = true;
                              isVietnamese = false;
                            });
                            flutterTts.setLanguage("en-US");
                            // obtain shared preferences
                            final prefs = await SharedPreferences.getInstance();
                            // set value
                            prefs.setBool('isEnglish', isEnglish);
                            prefs.setBool('isVietnamese', isVietnamese);
                          },
                          child: ListTile(
                            leading: SizedBox(
                                width: 50,
                                height: 50,
                                child:
                                    Image.asset('assets/images/us_flag.png')),
                            title: Text('english'.tr),
                            trailing: isEnglish
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : null,
                          ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () async {
                            Navigator.pop(context);
                            setState(() {
                              languages = TtsLanguage.vn;
                              isEnglish = false;
                              isVietnamese = true;
                            });
                            flutterTts.setLanguage("vi-VN");
                            // obtain shared preferences
                            final prefs = await SharedPreferences.getInstance();
                            // set value
                            prefs.setBool('isEnglish', isEnglish);
                            prefs.setBool('isVietnamese', isVietnamese);
                          },
                          child: ListTile(
                            leading: SizedBox(
                                width: 50,
                                height: 50,
                                child:
                                    Image.asset('assets/images/vn_flag.png')),
                            title: Text('vietnamese'.tr),
                            trailing: isVietnamese
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close',
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: FilledButton(
                onPressed: () {
                  setState(() {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('delete_all_messages'.tr),
                          content: Text('delete_all_messages_confirm'.tr),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text(
                                'Ok',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              onPressed: () {
                                setState(() {
                                  messageList.clear();
                                  ChatGPTUltils.history.clear();
                                  ChatGPTUltils.totalTokens = 0;
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setInt("totalTokens", 0);
                                  });
                                });
                                DB_Ultils.deleteAll();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: Text(
                  'delete_all_messages'.tr,
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageListView() {
    return Expanded(
      child: GroupedListView<Message, DateTime>(
        // order: GroupedListOrder.DESC,
        // reverse: true,
        addAutomaticKeepAlives: true,
        padding: const EdgeInsets.all(10),
        elements: messageList,
        groupBy: (message) => DateTime(
          message.date.year,
          message.date.month,
          message.date.day,
        ),
        groupHeaderBuilder: (Message message) => Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(DateFormat.yMMMMEEEEd().format(message.date),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11.0)),
          ),
        ),
        indexedItemBuilder: (context, message, index) {
          return message.isUser
              ? Bubble(
                  elevation: 5,
                  margin: const BubbleEdges.only(
                    top: 5,
                    bottom: 10,
                  ),
                  alignment: Alignment.topRight,
                  nip: BubbleNip.rightTop,
                  color: Colors.blue,
                  child: Text(
                    message.message,
                    style: const TextStyle(color: Colors.white),
                  ))
              : Row(children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                    child: Obx(() => Bubble(
                        elevation: 5,
                        margin: const BubbleEdges.only(
                          top: 5,
                          bottom: 10,
                        ),
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        color: controller.grey_100_and_grey_850.value,
                        child: Text(
                          message.message,
                          style: TextStyle(
                              color: controller.black_and_white_text.value),
                        ))),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          message.state = !message.state;
                          if (message.state) {
                            for (var i = 0; i < messageList.length; i++) {
                              if (i != index) {
                                messageList[i].state = false;
                              }
                            }
                            flutterTts.speak(message.message);
                            flutterTts.setCompletionHandler(() {
                              setState(() {
                                message.state = false;
                              });
                            });
                          } else {
                            flutterTts.stop();
                          }
                        });
                      },
                      icon: Obx(() => message.state
                          ? LoadingAnimationWidget.beat(
                              color: controller.blue_700_and_white.value ??
                                  Colors.blue,
                              size: 20,
                            )
                          : Icon(
                              Icons.play_circle_outline,
                              color: controller.blue_700_and_white.value,
                            )))
                ]);
        },
      ),
    );
  }

  Future<void> _sendRequest(String message) async {
    textFieldController.clear();
    String result = await chatGPTUltils.getResponse(message);
    int idx = messageList.length;
    if (isAutoTTS) {
      for (var i = 0; i < messageList.length; i++) {
        messageList[i].state = false;
      }
      flutterTts.speak(result);
      flutterTts.setCompletionHandler(() {
        setState(() {
          messageList[idx].state = false;
        });
      });
    }
    setState(() {
      messageList.add(Message(
          message: result,
          date: DateTime.now(),
          isUser: false,
          state: isAutoTTS));
      isButtonDisabled = false;
    });
    DB_Ultils.insertMessage(
        Message(message: result, date: DateTime.now(), isUser: false));
  }

  Widget _buildInputMessage() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
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
                  borderSide:
                      BorderSide(color: controller.black_and_white_text.value),
                ),
              ),
            ),
            child: TextField(
              style: TextStyle(
                color: controller.black_and_white_text.value,
              ),
              cursorColor: controller.blue_700_and_white.value,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: controller.black_and_white_text.value,
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                hintText: "start_typing_or_talking".tr,
                contentPadding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                suffixIcon: Obx(() => IconButton(
                      icon: !isButtonDisabled
                          ? Icon(
                              Icons.send,
                              color: controller.blue_700_and_white.value,
                            )
                          : LoadingAnimationWidget.discreteCircle(
                              color: controller.isDarkTheme
                                  ? Colors.white
                                  : Colors.blue,
                              size: 20,
                            ),
                      onPressed: () {
                        if (isButtonDisabled) return;
                        String text = textFieldController.text;
                        setState(() {
                          isButtonDisabled = true;
                          messageList.add(Message(
                              message: text,
                              date: DateTime.now(),
                              isUser: true));
                        });
                        DB_Ultils.insertMessage(Message(
                            message: text, date: DateTime.now(), isUser: true));
                        _sendRequest(text);
                      },
                    )),
              ),
              controller: textFieldController,
            )),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: SingleChildScrollView(
        child: Column(children: [
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            endRadius: 50.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: Obx(
                () => ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            controller.blue_700_and_white.value)),
                    onPressed: _listen,
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 40,
                      color: controller.black_and_white_card.value,
                    )),
              ),
            ),
          ),
          Obx(() => Text(
                _isListening ? "listening".tr : "tap_to_talk".tr,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: controller.blue_700_and_white.value),
              ))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ],
          centerTitle: true,
          title: const Text("Chat",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))),
      endDrawer: _buildDrawer(),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SafeArea(
              child: Column(children: [
                _buildMessageListView(),
                _buildInputMessage(),
              ]),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }
}
