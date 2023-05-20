import 'package:flutter/material.dart';
import 'package:one_on_one_learning/controllers/controller.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:one_on_one_learning/views/login_page/login_page.dart';
import 'package:get/get.dart';

class CheckEmail extends StatelessWidget {
  final String email;
  CheckEmail({super.key, required this.email});
  Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(UIData.emailVerify, height: 300, width: 300),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: "we_have_sent_email".tr,
                style: TextStyle(
                  color: controller.black_and_white_text.value,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: email,
                    style: TextStyle(
                      color: controller.black_and_white_text.value,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text: 'please_check_your_reset_email'.tr,
                      style: TextStyle(
                        color: controller.black_and_white_text.value,
                        fontSize: 16,
                      )),
                ]),
          ])),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: controller.blue_700_and_white.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginPage();
                  }),
                );
              },
              child: Text(
                'back_to_sign_in'.tr,
                style: TextStyle(
                  color: controller.black_and_white_card.value,
                  fontSize: 16,
                ),
              )),
        ),
      ])),
    );
  }
}
