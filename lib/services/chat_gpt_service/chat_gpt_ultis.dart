// ignore_for_file: avoid_print

import './api_const.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatGPTUltils {
  static List<Map<String, String>> history = [];
  static OpenAI openAI = OpenAI.instance.build(
      token: API_Const.API_KEY,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)));
  static bool isProcessing = false;

  static final ChatGPTUltils _chatGPTUltils = ChatGPTUltils._internal();
  ChatGPTUltils._internal();
  factory ChatGPTUltils() => _chatGPTUltils;

  Future<String> getResponse(String inputMessage) async {
    try {
      isProcessing = true;
      print("Message enter: $inputMessage \nMessage processing...");
      history.add({"role": "user", "content": inputMessage});

      final request = ChatCompleteText(
          model: ChatModel.gptTurbo,
          maxToken: API_Const.MAX_TOKEN,
          messages: history);

      final response = await openAI.onChatCompletion(request: request);

      if (response != null) {
        var botMessage = response.choices[0].message?.content;
        history.add({"role": "assistant", "content": botMessage ?? ""});

        print("Message received: $botMessage");
        isProcessing = false;
        return botMessage ?? "";
      }
    } catch (err) {
      print(err.toString());
    }
    return "Something went wrong. Please try again later :<";
  }
}
