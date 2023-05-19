import 'package:flutter/material.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/views/login_page/login_page.dart';

import '../../controllers/controller.dart';
import '../profile_page/profile_page.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharePref sharePref = SharePref();
  Controller controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('settings'.tr),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text("general".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(
                  Icons.language,
                  size: 30,
                ),
                title: Text('languages'.tr),
                subtitle: Text('current_language'.tr),
                onTap: () {
                  controller.isEnglish = !controller.isEnglish;
                  if (controller.isEnglish) {
                    sharePref.saveBool('isEnglish', true);
                    Get.updateLocale(const Locale('en', 'US'));
                  } else {
                    sharePref.saveBool('isEnglish', false);
                    Get.updateLocale(const Locale('vi', 'VN'));
                  }
                },
              ),
              ListTile(
                  leading: const Icon(
                    Icons.dark_mode,
                    size: 30,
                  ),
                  title: Text('dark_mode'.tr),
                  trailing: Switch(
                    activeColor: Colors.blue[700],
                    onChanged: (value) {
                      setState(() {
                        controller.isDarkTheme = value;
                        controller.onChangeTheme();
                        if (controller.isDarkTheme) {
                          sharePref.saveBool('isDarkTheme', true);
                          Get.changeTheme(ThemeData.dark(useMaterial3: true));
                        } else {
                          sharePref.saveBool('isDarkTheme', false);
                          Get.changeTheme(ThemeData.light(useMaterial3: true));
                        }
                      });
                    },
                    value: controller.isDarkTheme,
                  )),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Text("account".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30,
                ),
                title: Text('profile'.tr),
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
                title: Text('sign_out'.tr),
                onTap: () {
                  sharePref.removeString('access_token');
                  sharePref.removeString('refresh_token');
                  sharePref.removeString('access_token_exp');
                  sharePref.removeString('refresh_token_exp');
                  Navigator.pop(context);
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
