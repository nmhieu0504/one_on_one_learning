import 'package:flutter/material.dart';
import 'package:one_on_one_learning/services/user_service.dart';
import 'package:intl/intl.dart';

import '../../models/user.dart';
import '../../utils/countries_lis.dart';
import '../../utils/ui_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Widget _buildLearnTopicsChips() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(learnTopics.length, (int index) {
            return FilterChip(
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

    UserService.loadUserInfo().then((value) {
      setState(() {
        user = value;
        _loading = false;

        _nameController.text = user.name;
        _emailController.text = user.email;
        _birthdayController.text = user.birthday ?? "";
        _countryController.text = user.country ?? "";
        _phoneController.text = user.phone;
        _scheduleController.text = user.studySchedule ?? "";

        int leveldx = levelCodeList.indexOf(user.level ?? "");
        dropdownLevelValue = leveldx == -1 ? null : levelTittleList[leveldx];
        dropdownCountryValue =
            user.country == null ? null : getCountryName(user.country);

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
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () {
          _saveProfile();
        },
        icon: const Icon(
          Icons.save,
          size: 24.0,
        ),
        label: const Text('Save'), // <-- Text
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey[50],
                        backgroundImage: _isAvatarError
                            ? const AssetImage(UIData.logoLogin)
                            : NetworkImage(user.avatar) as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          setState(() {
                            _isAvatarError = true;
                          });
                        },
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
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
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
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      enableInteractiveSelection: false,
                      readOnly: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.grey[200],
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      enableInteractiveSelection: false,
                      readOnly: true,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.grey[200],
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Phone',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
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
                        labelText: 'Birthday',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Country',
                      ),
                      value: dropdownCountryValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownCountryValue = newValue;
                        });
                      },
                      items: countryTittleList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Level',
                      ),
                      value: dropdownLevelValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownLevelValue = newValue;
                        });
                      },
                      items: levelTittleList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Want to learn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Topics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildLearnTopicsChips(),
                    const Text(
                      'Test preparation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildTestPreparationsChips(),
                    const SizedBox(height: 20),
                    const Text(
                      'Study schedule',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      enableInteractiveSelection: false,
                      controller: _scheduleController,
                      decoration: InputDecoration(
                        hintText: "Show us your study schedule",
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
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
