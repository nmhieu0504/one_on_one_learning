// ignore_for_file: avoid_print, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:one_on_one_learning/views/register_page/active_email.dart';
import 'package:get/get.dart';

import '../../services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _loading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  void _displayDeleteMotionToast() {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Email has already taken'),
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
                  child:
                      Image.asset(UIData.registerImng, width: 200, height: 200),
                ),
                Center(
                  child: Text('register'.tr,
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
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                          return 'password_empty'.tr;
                        }
                        if (value.length < 6) {
                          return 'password_error'.tr;
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'password'.tr,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue),
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                          return 're_password_empty'.tr;
                        }
                        if (value != _passwordController.text) {
                          return 're_password_error'.tr;
                        }
                        return null;
                      },
                      controller: _rePasswordController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 're_enter_password'.tr,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue),
                        ),
                      ),
                      obscureText: _obscureText,
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
                        bool result = await AuthService.signUp(
                            _emailController.text, _passwordController.text);
                        if (result) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return ActiveEmail(email: _emailController.text);
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
                    child: Text(
                      'sign_up'.tr,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('already_have_an_account'.tr),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'sign_in'.tr,
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
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
