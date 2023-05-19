import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:one_on_one_learning/services/user_service.dart';

import '../../controllers/controller.dart';

class MeetingPage extends StatefulWidget {
  final String roomNameOrUrl;
  const MeetingPage({super.key, required this.roomNameOrUrl});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  bool _loading = true;
  Controller controller = Get.find<Controller>();

  @override
  void initState() {
    super.initState();
    UserService.loadUserInfo().then((value) {
      setState(() {
        _loading = false;
        userDisplayNameText.text = value.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildMeetConfig(),
            ),
    );
  }

  final userDisplayNameText = TextEditingController(text: "");

  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;
  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  _joinMeeting() async {
    // Define meetings options here
    var options = JitsiMeetingOptions(
      serverUrl: "https://meet.lettutor.com",
      roomNameOrUrl: widget.roomNameOrUrl,
      userDisplayName: userDisplayNameText.text,
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
            "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
            "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
            "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }

  Widget buildMeetConfig() {
    return Scaffold(
      appBar: AppBar(
        title: Text("join_meeting".tr),
      ),
      body: SingleChildScrollView(
        child: Obx(() => Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                _buildTextField(
                  labelText: "user_display_name".tr,
                  textController: userDisplayNameText,
                ),
                const SizedBox(height: 16.0),
                CheckboxListTile(
                  activeColor: controller.blue_700_and_white.value,
                  title: Text("audio_muted".tr),
                  value: isAudioMuted,
                  onChanged: _onAudioMutedChanged,
                ),
                const SizedBox(height: 5),
                CheckboxListTile(
                  activeColor: controller.blue_700_and_white.value,
                  title: Text("audio_only".tr),
                  value: isAudioOnly,
                  onChanged: _onAudioOnlyChanged,
                ),
                const SizedBox(height: 5),
                CheckboxListTile(
                  activeColor: controller.blue_700_and_white.value,
                  title: Text("video_muted".tr),
                  value: isVideoMuted,
                  onChanged: _onVideoMutedChanged,
                ),
                const Divider(height: 48.0, thickness: 2.0),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () => _joinMeeting(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                    ),
                    child: Text(
                      "join_meeting".tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),
              ],
            )),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController textController,
    String? hintText,
  }) {
    return Theme(
      data: ThemeData(
        useMaterial3: controller.isDarkTheme,
        primaryColor: controller.blue_700_and_white.value,
        primaryColorDark: controller.blue_700_and_white.value,
      ),
      child: TextField(
        style: TextStyle(
          color: controller.black_and_white_text.value,
        ),
        controller: textController,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            labelText: labelText,
            hintText: hintText),
      ),
    );
  }
}
