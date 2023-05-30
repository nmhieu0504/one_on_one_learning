// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:one_on_one_learning/utils/backend.dart';
import 'package:one_on_one_learning/utils/share_pref.dart';
import 'package:one_on_one_learning/utils/ui_data.dart';
import 'package:http/http.dart' as http;
import 'package:one_on_one_learning/views/forget_password_page/forget_password_page.dart';
import 'package:one_on_one_learning/views/register_page/register_page.dart';
import 'package:get/get.dart';

import '../../services/auth_services.dart';
import '../navigator_page.dart';
import '../../controllers/controller.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Controller controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _loading = false;
  bool _checkRefreshToken = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SharePref sharePref = SharePref();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignInWithGoogle() async {
    try {
      await _googleSignIn.signIn().then((value) {
        value?.authentication.then((googleKey) {
          String accessToken = googleKey.accessToken!;
          debugPrint("Access token: $accessToken");
          setState(() {
            _loading = true;
          });
          AuthService.signInWithGoogle(accessToken).then((value) {
            if (value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavigatorPage()),
              );
            } else {
              _displayErrorMotionToastWithThirdParty();
            }
          });
        }).catchError((err) {
          debugPrint('inner error');
        });
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void _handleSignInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      debugPrint("TOKEN FB: ${accessToken.token}");
      setState(() {
        _loading = true;
      });
      AuthService.signInWithFacebook(accessToken.token).then((value) {
        if (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigatorPage()),
          );
        } else {
          _displayErrorMotionToastWithThirdParty();
        }
      });
    } else {
      debugPrint('Facebook login failed: ${result.message}');
    }
  }

  void _displayErrorMotionToast() {
    Get.snackbar(
      "",
      "",
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      duration: const Duration(milliseconds: 750),
      titleText: Text("error".tr,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      messageText: Text("wrong_email_or_password".tr,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white)),
    );
  }

  void _displayErrorMotionToastWithThirdParty() {
    Get.snackbar(
      "",
      "",
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      duration: const Duration(milliseconds: 750),
      titleText: Text("error".tr,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      messageText: Text("something_went_wrong".tr,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white)),
    );
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
          () async {
            String? token = await sharePref.getString("refresh_token");
            var response = await http.post(Uri.parse(API_URL.REFRESH_TOKEN),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"refreshToken": token ?? '', "timezone": 7}));

            if (response.statusCode == 200) {
              debugPrint(response.body);
              var data = jsonDecode(response.body);
              sharePref.saveString(
                  "access_token", data["tokens"]["access"]["token"]);
              sharePref.saveString(
                  "access_token_exp", data["tokens"]["access"]["expires"]);
              sharePref.saveString(
                  "refresh_token", data["tokens"]["refresh"]["token"]);
              sharePref.saveString(
                  "refresh_token_exp", data["tokens"]["refresh"]["expires"]);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavigatorPage()),
              );
            }
          }();
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
            ? Center(
                child: CircularProgressIndicator(
                  color: controller.blue_700_and_white.value,
                ),
              )
            : Obx(() => Form(
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
                        Center(
                          child: Text('LET LEARN',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: controller.blue_700_and_white.value,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50, bottom: 10),
                          child: Theme(
                            data: ThemeData(
                              useMaterial3: true,
                              colorScheme: ColorScheme.fromSwatch().copyWith(
                                primary: controller.blue_700_and_white.value,
                                secondary:
                                    controller.black_and_white_text.value,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: controller
                                          .black_and_white_text.value),
                                ),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: controller.blue_700_and_white.value,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: controller.black_and_white_text.value),
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
                                  labelStyle: TextStyle(
                                      color: controller
                                          .black_and_white_text.value)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Theme(
                            data: ThemeData(
                              useMaterial3: true,
                              colorScheme: ColorScheme.fromSwatch().copyWith(
                                primary: controller.blue_700_and_white.value,
                                secondary:
                                    controller.black_and_white_text.value,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: controller
                                          .black_and_white_text.value),
                                ),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: controller.blue_700_and_white.value,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: controller.black_and_white_text.value),
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
                                labelStyle: TextStyle(
                                    color:
                                        controller.black_and_white_text.value),
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
                                      color:
                                          controller.blue_700_and_white.value),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const ForgetPasswordPage();
                                  }),
                                );
                              },
                              child: Text('forgot_password'.tr,
                                  style: TextStyle(
                                      color:
                                          controller.blue_700_and_white.value)),
                            ),
                          ],
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                controller.blue_700_and_white.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              bool result = await AuthService.signIn(
                                  _emailController.text,
                                  _passwordController.text);
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
                                _displayErrorMotionToast();
                              }
                            }
                          },
                          child: Text('sign_in'.tr,
                              style: TextStyle(
                                  color:
                                      controller.black_and_white_card.value)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('dont_have_an_account'.tr),
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
                              child: Text('sign_up'.tr,
                                  style: TextStyle(
                                      color:
                                          controller.blue_700_and_white.value)),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'or_sign_in_with'.tr,
                              ),
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
                                        onPressed: () {
                                          _handleSignInWithFacebook();
                                        },
                                        tooltip: "Sign in with Facebook",
                                        icon: const Image(
                                          image:
                                              AssetImage(UIData.facebookIcon),
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
                                        onPressed: () {
                                          _handleSignInWithGoogle();
                                        },
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
                              color: Colors.grey,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: controller.blue_700_and_white.value,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                )),
      ),
    );
  }
}
