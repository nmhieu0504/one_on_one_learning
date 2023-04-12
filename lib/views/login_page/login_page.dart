import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:one_on_one_learning/utils/backend.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;

import '../navigator_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _loading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<bool> _signIn() async {
    setState(() {
      _loading = true;
    });
    final response = await http.post(Uri.parse(API_URL.LOGIN), body: {
      "email": _emailController.text,
      "password": _passwordController.text,
    });

    if (response.statusCode == 200) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          ListView(
            padding: const EdgeInsets.all(40.0),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Image.asset(UIData.logoLogin, width: 200, height: 200),
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
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
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
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () async {
                  bool result = await _signIn();
                  if (result) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const NavigatorPage('Home Page');
                      }),
                    );
                  } else {
                    setState(() {
                      _loading = false;
                    });
                    _displayDeleteMotionToast();
                  }
                },
                child: const Text('Sign In'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {},
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
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            child: IconButton(
                              constraints: const BoxConstraints.tightFor(
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
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            child: IconButton(
                              constraints: const BoxConstraints.tightFor(
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
    );
  }
}
