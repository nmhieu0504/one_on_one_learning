// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/utils/backend.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;
import 'package:one_on_one_learning/views/forget_password_page/forget_password_page.dart';
import 'package:one_on_one_learning/views/register_page/register_page.dart';

import '../navigator_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _loading = false;
  bool _checkRefreshToken = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SharePref sharePref = SharePref();

  Future<bool> _signIn() async {
    setState(() {
      _loading = true;
    });
    final response = await http.post(Uri.parse(API_URL.LOGIN), body: {
      "email": _emailController.text,
      "password": _passwordController.text,
    });

    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      sharePref.saveString("access_token", data["tokens"]["access"]["token"]);
      sharePref.saveString(
          "access_token_exp", data["tokens"]["access"]["expires"]);
      sharePref.saveString("refresh_token", data["tokens"]["refresh"]["token"]);
      sharePref.saveString(
          "refresh_token_exp", data["tokens"]["refresh"]["expires"]);

      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }

  void _displayDeleteMotionToast() {
    MotionToast.error(
      title: const Text(
        'Invalid',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Wrong email or password'),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
    sharePref.getString("refresh_token").then((value) async {
      if (value != null) {
        DateTime now = DateTime.now();
        String? str = await sharePref.getString("refresh_token_exp");
        DateTime exp = DateTime.parse(str!);
        if (now.isBefore(exp)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigatorPage()),
          );
        }
      } else {
        setState(() {
          _checkRefreshToken = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _checkRefreshToken
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Stack(children: [
                  ListView(
                    padding: const EdgeInsets.all(40.0),
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Image.asset(UIData.logoLogin,
                            width: 200, height: 200),
                      ),
                      const Center(
                        child: Text('LET LEARN',
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
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 16),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
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
                            labelText: 'Password',
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
                                  color: Colors.deepPurple),
                            ),
                          ),
                          obscureText: _obscureText,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const ForgetPasswordPage();
                                }),
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool result = await _signIn();
                            if (result) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const NavigatorPage();
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
                        child: const Text('Sign In'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const RegisterPage();
                                }),
                              );
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                            const Text('Or Sign In With'),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: IconButton(
                                      constraints:
                                          const BoxConstraints.tightFor(
                                        width: 60,
                                        height: 50,
                                      ),
                                      onPressed: () {},
                                      tooltip: "Sign in with Facebook",
                                      icon: const Image(
                                        image: AssetImage(UIData.facebookIcon),
                                        color: null,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: IconButton(
                                      constraints:
                                          const BoxConstraints.tightFor(
                                        width: 60,
                                        height: 50,
                                      ),
                                      onPressed: () {},
                                      tooltip: "Sign in with Google",
                                      icon: const Image(
                                        image: AssetImage(UIData.googleIcon),
                                        color: null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
