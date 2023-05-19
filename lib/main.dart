import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'controllers/controller.dart';
import 'views/login_page/login_page.dart';
import 'package:one_on_one_learning/controllers/translation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Controller controller = Get.put<Controller>(
    Controller(),
  );
  SharePref sharePref = SharePref();
  bool? result = await sharePref.getBool("isEnglish");
  bool isEnglish = result ?? true;
  controller.isEnglish = isEnglish;
  runApp(MyApp(isEnglish: isEnglish));
}

class MyApp extends StatelessWidget {
  bool isEnglish;
  MyApp({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(), // Initialize with custom translations
      locale: isEnglish ? const Locale('en', 'US') : const Locale('vi', 'VN'),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginPage(),
    );
  }
}
