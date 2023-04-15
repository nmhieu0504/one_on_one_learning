// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/utils/backend.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;
import 'package:one_on_one_learning/views/forget_password_page/check_email.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  final TextEditingController _emailController = TextEditingController();

  Future<bool> _forgetPass() async {
    setState(() {
      _loading = true;
    });
    final response = await http.post(Uri.parse(API_URL.FORGET_PASSWORD), body: {
      "email": _emailController.text,
    });

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  void _displayDeleteMotionToast() {
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
                const Center(
                  child: Text('Reset your password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 10),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool result = await _forgetPass();
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
                          _displayDeleteMotionToast();
                        }
                      }
                    },
                    child: const Text('Send email'),
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
