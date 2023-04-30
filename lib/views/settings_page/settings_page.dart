import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/login_page/login_page.dart';

import '../profile_page/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharePref sharePref = SharePref();
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text("General",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      size: 30,
                    ),
                    title: const Text('Language'),
                    subtitle: const Text('English'),
                    onTap: () {
                      // Handle language selection
                    },
                  ),
                  ListTile(
                      leading: const Icon(
                        Icons.dark_mode,
                        size: 30,
                      ),
                      title: const Text('Dark mode'),
                      trailing: Switch(
                        onChanged: (value) {},
                        value: _isDarkMode,
                      )),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: const Text("Account",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 30,
                    ),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const ProfilePage();
                      }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    title: const Text('Sign Out'),
                    onTap: () {
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
                  ),
                ])));
  }
}
