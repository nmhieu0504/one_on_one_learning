import 'package:flutter/material.dart';
import 'package:one_on_one_learning/ui_data/ui_data.dart';
import '../navigator_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
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
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const NavigatorPage('Home Page');
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
      ),
    );
  }
}
