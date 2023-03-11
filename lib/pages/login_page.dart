import 'package:flutter/material.dart';
import '../ui_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'navigator_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title, style: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //   ),),
      //   backgroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: ListView(
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
                    color: Colors.blue,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 10),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Password',
                  ),
                  obscureText: true,
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const PageNavigator('Home Page');
                  }),
                );
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
                        IconButton(
                          constraints: const BoxConstraints.tightFor(
                            width: 60,
                            height: 50,
                          ),
                          onPressed: () {},
                          tooltip: "Sign in with Facebook",
                          icon: const FaIcon(FontAwesomeIcons.facebook),
                        ),
                        IconButton(
                          constraints: const BoxConstraints.tightFor(
                            width: 60,
                            height: 50,
                          ),
                          onPressed: () {},
                          tooltip: "Sign in with Google",
                          icon: const FaIcon(FontAwesomeIcons.google),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
