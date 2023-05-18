// ignore_for_file: avoid_print, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:one_on_one_learning/views/forget_password_page/check_email.dart';

import '../../services/auth_services.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  final TextEditingController _emailController = TextEditingController();

  void _displayErrorMotionToast() {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Email does not exist'),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(children: [
            ListView(
              padding: const EdgeInsets.all(40.0),
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 15),
                  child: Image.asset(UIData.forgetPasswordImg,
                      width: 200, height: 200),
                ),
                Center(
                  child: Text('reset_password'.tr,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 10),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.blue,
                      primaryColorDark: Colors.blue,
                    ),
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email_empty'.tr;
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'email_error'.tr;
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        bool result =
                            await AuthService.forgetPass(_emailController.text);
                        if (result) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CheckEmail(email: _emailController.text);
                            }),
                          );
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          _displayErrorMotionToast();
                        }
                      }
                    },
                    child: Text(
                      'send_email'.tr,
                    ),
                  ),
                ),
              ],
            ),
            _loading
                ? Opacity(
                    opacity: 0.8,
                    child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : const SizedBox(),
          ]),
        ),
      ),
    );
  }
}
