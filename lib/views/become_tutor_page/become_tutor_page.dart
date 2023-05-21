import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_on_one_learning/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_learning/views/become_tutor_page/register_done.dart';

import '../../controllers/controller.dart';
import '../../models/user.dart';
import '../../utils/countries_lis.dart';
import '../../utils/ui_data.dart';
import 'package:get/get.dart';

class BecomeTutorPage extends StatefulWidget {
  const BecomeTutorPage({super.key});

  @override
  State<BecomeTutorPage> createState() => _BecomeTutorPageState();
}

class _BecomeTutorPageState extends State<BecomeTutorPage> {
  Controller controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _formKeyInfo = GlobalKey<FormState>();

  late File imageFile;
  bool _loading = true;
  bool _isAvatarError = false;
  late User user;
  final List<DropdownMenuEntry<String>> countryMenuList =
      <DropdownMenuEntry<String>>[];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final List<TextEditingController> _infoController =
      List.generate(5, (index) => TextEditingController());

  final List<String> infoTitleList = <String>[
    'interests',
    'education',
    'experience',
    'current_or_previous_profession',
    'introduction'
  ];

  late String? dropdownLevelValue;

  List<String> countryTittleList = <String>[];
  late String? dropdownCountryValue;

  var bestAtTeaching = [
    "Beginner",
    "Intermediate",
    "Advanced",
  ];
  String currentBestAtTeaching = "Beginner";

  var specialtiesList = [
    {"key": "english-for-kids", "name": "English for Kids"},
    {"key": "business-english", "name": "Business English"},
    {"key": "conversational-english", "name": "Conversational English"},
    {"key": "starters", "name": "STARTERS"},
    {"key": "movers", "name": "MOVERS"},
    {"key": "flyers", "name": "FLYERS"},
    {"key": "ket", "name": "KET"},
    {"key": "pet", "name": "PET"},
    {"key": "ielts", "name": "IELTS"},
    {"key": "toefl", "name": "TOEFL"},
    {"key": "toeic", "name": "TOEIC"}
  ];
  List<bool> testPreparationChoices = List.generate(11, (index) => false);

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

  Widget _buildBestAtTeachingChips() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(bestAtTeaching.length, (int index) {
            return FilterChip(
              backgroundColor: controller.black_and_white_card.value,
              selectedColor: controller.blue_100_and_blue_400.value,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(bestAtTeaching[index]),
              onSelected: (bool isSlected) {
                setState(() {
                  if (isSlected) {
                    currentBestAtTeaching = bestAtTeaching[index];
                  }
                });
              },
              selected: currentBestAtTeaching == bestAtTeaching[index],
            );
          }).toList(),
        ));
  }

  Widget _buildTestPreparationsChips() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(specialtiesList.length, (int index) {
            return FilterChip(
              backgroundColor: controller.black_and_white_card.value,
              selectedColor: controller.blue_100_and_blue_400.value,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: Text(specialtiesList[index]["name"].toString()),
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

  void _loadData() {
    UserService.loadUserInfo().then((value) {
      setState(() {
        user = value;
        _loading = false;

        _nameController.text = user.name;
        _birthdayController.text = user.birthday ?? "";
        _countryController.text = user.country ?? "";

        dropdownCountryValue = user.country == null
            ? null
            : getCountryName(user.country, isTutorPage: true);
      });
    });
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

  List<Widget> _buildTutorInfoForm() {
    List<Widget> list = [];
    for (var i = 0; i < 5; i++) {
      list.addAll([
        Text(
          infoTitleList[i].tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'this_field_cannot_be_empty'.tr;
            }
            return null;
          },
          cursorColor: controller.blue_700_and_white.value,
          style: TextStyle(
            color: controller.black_and_white_text.value,
          ),
          maxLines: 3,
          enableInteractiveSelection: false,
          controller: _infoController[i],
          decoration: InputDecoration(
            hintText: "let_us_know_more_about_you".tr,
            hintStyle: TextStyle(
                color: controller.black_and_white_text.value,
                fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ]);
    }
    return list;
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
        title: Text('become_a_tutor'.tr),
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
                            right: -5,
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
                    Text(
                      'best_teaching_studen_at_level'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildBestAtTeachingChips(),
                    Text(
                      'your_specialties'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildTestPreparationsChips(),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKeyInfo,
                      child: Theme(
                        data: ThemeData(
                          useMaterial3: true,
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            primary: controller.blue_700_and_white.value,
                            secondary: controller.black_and_white_text.value,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: controller.black_and_white_text.value),
                            ),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildTutorInfoForm()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                controller.blue_700_and_white.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (!testPreparationChoices.contains(true)) {
                              _displayErrorMotionToast(
                                  'please_choose_at_least_one_specialty'.tr);
                            }
                            if (_formKey.currentState!.validate() &&
                                _formKeyInfo.currentState!.validate()) {
                              List<String> specialties = [];
                              for (var i = 0;
                                  i < testPreparationChoices.length;
                                  i++) {
                                if (testPreparationChoices[i]) {
                                  specialties.add(
                                      specialtiesList[i]["key"].toString());
                                }
                              }
                              controller.isBecomingTutor = true;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompleteRegister()));
                              UserService.becomeTutor(
                                  name: _nameController.text,
                                  country: dropdownCountryValue ?? "",
                                  birthday: _birthdayController.text,
                                  interests: _infoController[0].text,
                                  education: _infoController[1].text,
                                  experience: _infoController[2].text,
                                  profession: _infoController[3].text,
                                  bio: _infoController[4].text,
                                  targetStudent: currentBestAtTeaching,
                                  specialties: specialties,
                                  avatar: user.avatar);
                            }
                          },
                          child: Text('register'.tr,
                              style: TextStyle(
                                  color:
                                      controller.black_and_white_card.value)),
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
