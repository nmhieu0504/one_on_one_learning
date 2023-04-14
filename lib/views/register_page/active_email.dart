import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:one_on_one_learning/views/login_page/login_page.dart';

class ActiveEmail extends StatelessWidget {
  final String email;
  const ActiveEmail({super.key, required this.email});

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
                text: "We've sent an email to ",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                      text:
                          '. Please check your email to activate your account.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      )),
                ]),
          ])),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginPage();
                  }),
                );
              },
              child: const Text(
                'Back to Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )),
        ),
      ])),
    );
  }
}