import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_on_one_learning/services/user_service.dart';
import 'package:intl/intl.dart';

import '../../controllers/controller.dart';
import '../../models/user.dart';
import '../../utils/countries_lis.dart';
import '../../utils/ui_data.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Controller controller = Get.find();
  late File imageFile;
  bool _loading = true;
  bool _isAvatarError = false;
  late User user;
  final List<DropdownMenuEntry<String>> countryMenuList =
      <DropdownMenuEntry<String>>[];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> levelTittleList = <String>[
    'Pre A1 (Beginner)',
    'A1 (Higher Beginner)',
    'A2 (Pre-Intermediate)',
    'B1 (Intermediate)',
    'B2 (Upper-Intermediate)',
    'C1 (Advanced)',
    'C2 (Proficiency)'
  ];
  List<String> levelCodeList = <String>[
    'BEGINNER',
    'HIGHER_BEGINNER',
    'PRE_INTERMEDIATE',
    'INTERMEDIATE',
    'UPPER_INTERMEDIATE',
    'ADVANCED',
    'PROFICIENCY'
  ];
  late String? dropdownLevelValue;

  List<String> countryTittleList = <String>[];
  late String? dropdownCountryValue;

  var learnTopics = [
    {"id": 4, "key": "business-english", "name": "Business English"},
    {"id": 3, "key": "english-for-kids", "name": "English for Kids"},
    {"id": 5, "key": "conversational-english", "name": "Conversational English"}
  ];
  List<bool> learnTopicsChoices = <bool>[false, false, false];

  var testPreparations = [
    {"id": 1, "key": "starters", "name": "STARTERS"},
    {"id": 2, "key": "movers", "name": "MOVERS"},
    {"id": 3, "key": "flyers", "name": "FLYERS"},
    {"id": 4, "key": "ket", "name": "KET"},
    {"id": 5, "key": "pet", "name": "PET"},
    {"id": 6, "key": "ielts", "name": "IELTS"},
    {"id": 7, "key": "toefl", "name": "TOEFL"},
    {"id": 8, "key": "toeic", "name": "TOEIC"}
  ];
  List<bool> testPreparationChoices = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void _displaySuccessMotionToast(String str) {
    Get.snackbar(
      "",
      "",
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      duration: const Duration(milliseconds: 750),
      titleText: const Text("Ok",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      messageText: Text(str,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white)),
    );
  }

  void _displayErrorMotionToast(String errorMessage) {
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
      messageText: Text(errorMessage,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white)),
    );
  }

  Widget _buildLearnTopicsChips() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(learnTopics.length, (int index) {
            return FilterChip(
              backgroundColor: controller.black_and_white_card.value,
              selectedColor: controller.blue_100_and_blue_400.value,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(learnTopics[index]["name"].toString()),
              onSelected: (bool isSlected) {
                setState(() {
                  if (isSlected) {
                    learnTopicsChoices[index] = true;
                  } else {
                    learnTopicsChoices[index] = false;
                  }
                });
              },
              selected: learnTopicsChoices[index],
            );
          }).toList(),
        ));
  }

  Widget _buildTestPreparationsChips() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(testPreparations.length, (int index) {
            return FilterChip(
              backgroundColor: controller.black_and_white_card.value,
              selectedColor: controller.blue_100_and_blue_400.value,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(testPreparations[index]["name"].toString()),
              onSelected: (bool isSlected) {
                setState(() {
                  if (isSlected) {
                    testPreparationChoices[index] = true;
                  } else {
                    testPreparationChoices[index] = false;
                  }
                });
              },
              selected: testPreparationChoices[index],
            );
          }).toList(),
        ));
  }

  void _saveProfile() {
    if (dropdownLevelValue == null) {
      _displayErrorMotionToast('please_choose_level'.tr);
      return;
    }

    setState(() {
      _loading = true;
    });

    List<String> learnTopicsList = [];
    for (int i = 0; i < learnTopicsChoices.length; i++) {
      if (learnTopicsChoices[i]) {
        learnTopicsList.add(learnTopics[i]["id"].toString());
      }
    }

    List<String> testPreparationsList = [];
    for (int i = 0; i < testPreparationChoices.length; i++) {
      if (testPreparationChoices[i]) {
        testPreparationsList.add(testPreparations[i]["id"].toString());
      }
    }

    UserService.updateUserInfo({
      "name": _nameController.text,
      "country": dropdownCountryValue == null
          ? null
          : countryList.keys
              .toList()[countryTittleList.indexOf(dropdownCountryValue ?? "")],
      "phone": _phoneController.text,
      "birthday":
          _birthdayController.text.isEmpty ? null : _birthdayController.text,
      "level": dropdownLevelValue == null
          ? null
          : levelCodeList[levelTittleList.indexOf(dropdownLevelValue ?? "")],
      "learnTopics": learnTopicsList,
      "testPreparations": testPreparationsList,
      "studySchedule": _scheduleController.text
    }).then((value) {
      setState(() {
        _displaySuccessMotionToast('update_user_info_success'.tr);
        _loading = false;
      });
    });
  }

  void _loadData() {
    UserService.loadUserInfo().then((value) {
      setState(() {
        user = value;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _birthdayController.text = user.birthday ?? "";
        _countryController.text = user.country ?? "";
        _phoneController.text = user.phone;
        _scheduleController.text = user.studySchedule ?? "";

        int leveldx = levelCodeList.indexOf(user.level ?? "");
        dropdownLevelValue = leveldx == -1 ? null : levelTittleList[leveldx];

        String tmp = getCountryName(user.country, isTutorPage: true);
        dropdownCountryValue = tmp == "No information" ? null : tmp;

        for (var e in user.learnTopics) {
          int index =
              learnTopics.indexWhere((element) => element["id"] == e["id"]);
          if (index != -1) {
            learnTopicsChoices[index] = true;
          }
        }

        for (var e in user.testPreparations) {
          int index = testPreparations
              .indexWhere((element) => element["id"] == e["id"]);
          if (index != -1) {
            testPreparationChoices[index] = true;
          }
        }

        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    countryTittleList = getCountriesName();
    countryList.forEach((key, value) {
      countryMenuList.add(DropdownMenuEntry<String>(value: key, label: value));
    });
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
      ),
      floatingActionButton: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: controller.blue_700_and_white.value,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _saveProfile();
          }
        },
        icon: Icon(
          Icons.save,
          size: 24.0,
          color: controller.black_and_white_card.value,
        ),
        label: Text(
          'save'.tr,
          style: TextStyle(
            color: controller.black_and_white_card.value,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
              color: controller.blue_700_and_white.value,
            ))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.grey[50],
                            backgroundImage: _isAvatarError
                                ? const AssetImage(UIData.defaultAvatar)
                                : NetworkImage(user.avatar) as ImageProvider,
                            onBackgroundImageError: (exception, stackTrace) {
                              setState(() {
                                _isAvatarError = true;
                              });
                            },
                          ),
                          Positioned(
                            bottom: -10,
                            right: 0,
                            child: IconButton(
                              iconSize: 40,
                              icon: Image.asset(
                                UIData.imagePicker,
                                scale: 10,
                              ),
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);

                                if (pickedFile != null) {
                                  // File selected, process it
                                  debugPrint(
                                      "File selected: ${pickedFile.path}");
                                  imageFile = File(pickedFile.path);
                                  setState(() {
                                    _loading = true;
                                  });
                                  UserService.updateUserAvatar(imageFile)
                                      .then((value) {
                                    _displaySuccessMotionToast(
                                        'update_user_info_success'.tr);
                                    _loadData();
                                  });
                                  // Do something with the image file, e.g. upload to server
                                } else {
                                  // No file selected, handle accordingly
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text(
                          _nameController.text,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Theme(
                        data: ThemeData(
                          useMaterial3: true,
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            primary: controller.blue_700_and_white.value,
                            secondary: controller.black_and_white_text.value,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: controller.black_and_white_text.value),
                            ),
                          ),
                        ),
                        child: TextFormField(
                          cursorColor: controller.blue_700_and_white.value,
                          style: TextStyle(
                            color: controller.black_and_white_text.value,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_your_name'.tr;
                            }
                            return null;
                          },
                          controller: _nameController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              labelText: 'name'.tr,
                              labelStyle: TextStyle(
                                  color:
                                      controller.black_and_white_text.value)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: controller.blue_700_and_white.value,
                          secondary: controller.black_and_white_text.value,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: controller.black_and_white_text.value,
                        ),
                        enableInteractiveSelection: false,
                        readOnly: true,
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true, //<-- SEE HERE
                          fillColor: controller.isDarkTheme
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: controller.black_and_white_text.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: controller.blue_700_and_white.value,
                          secondary: controller.black_and_white_text.value,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: controller.black_and_white_text.value,
                        ),
                        enableInteractiveSelection: false,
                        readOnly: true,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          filled: true, //<-- SEE HERE
                          fillColor: controller.isDarkTheme
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'phone'.tr,
                          labelStyle: TextStyle(
                              color: controller.black_and_white_text.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: controller.blue_700_and_white.value,
                          secondary: controller.black_and_white_text.value,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: controller.black_and_white_text.value,
                        ),
                        readOnly: true,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            if (value != null) {
                              _birthdayController.text =
                                  DateFormat("yyyy-MM-dd").format(value);
                            }
                          });
                        },
                        controller: _birthdayController,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelText: 'birthday'.tr,
                            labelStyle: TextStyle(
                                color: controller.black_and_white_text.value)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        inputDecorationTheme: InputDecorationTheme(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.blue_700_and_white.value ??
                                    Colors.blue[700]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: controller.black_and_white_card.value,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'country'.tr,
                          labelStyle: TextStyle(
                              color: controller.black_and_white_text.value),
                        ),
                        value: dropdownCountryValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownCountryValue = newValue;
                          });
                        },
                        items: countryTittleList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: controller.black_and_white_text.value,
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        inputDecorationTheme: InputDecorationTheme(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.blue_700_and_white.value ??
                                    Colors.blue[700]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: controller.black_and_white_card.value,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'level'.tr,
                          labelStyle: TextStyle(
                              color: controller.black_and_white_text.value),
                        ),
                        value: dropdownLevelValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownLevelValue = newValue;
                          });
                        },
                        items: levelTittleList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: controller.black_and_white_text.value,
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'want_to_learn'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'topics_capital'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildLearnTopicsChips(),
                    Text(
                      'test_preparation'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildTestPreparationsChips(),
                    const SizedBox(height: 20),
                    Text(
                      'study_schedule'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: controller.blue_700_and_white.value,
                          secondary: controller.black_and_white_text.value,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: controller.black_and_white_text.value),
                          ),
                        ),
                      ),
                      child: TextField(
                        cursorColor: controller.blue_700_and_white.value,
                        style: TextStyle(
                          color: controller.black_and_white_text.value,
                        ),
                        maxLines: 3,
                        enableInteractiveSelection: false,
                        controller: _scheduleController,
                        decoration: InputDecoration(
                          hintText: "your_study_schedule".tr,
                          hintStyle: TextStyle(
                              color: controller.black_and_white_text.value,
                              fontWeight: FontWeight.normal),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
