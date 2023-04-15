import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/login_page/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharePref sharePref = SharePref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Center(
            child: FilledButton(
                onPressed: () {
                  sharePref.removeString('access_token');
                  sharePref.removeString('refresh_token');
                  sharePref.removeString('access_token_exp');
                  sharePref.removeString('refresh_token_exp');
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginPage();
                  }));
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: const Text('Sign out',
                    style: TextStyle(fontSize: 20, color: Colors.white))),
          ),
        ])));
  }
}
