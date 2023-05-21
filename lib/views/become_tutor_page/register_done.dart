import 'package:flutter/material.dart';
import 'package:one_on_one_learning/controllers/controller.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:get/get.dart';

class CompleteRegister extends StatelessWidget {
  CompleteRegister({super.key});
  Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(UIData.happyFace, height: 200, width: 200),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: Text("become_a_tutor_success".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold))),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: controller.blue_700_and_white.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'get_back'.tr,
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
