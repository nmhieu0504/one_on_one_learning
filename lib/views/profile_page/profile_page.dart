import 'package:flutter/material.dart';
import 'package:one_on_one_learning/services/user_service.dart';

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
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
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

        int leveldx = levelCodeList.indexOf(user.level ?? "");
        dropdownLevelValue = leveldx == -1 ? null : levelTittleList[leveldx];
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
        onPressed: () {},
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
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
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
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
                    // const SizedBox(height: 20),
                    // DropdownMenu(
                    //   label: const Text('Country'),
                    //   initialSelection: user.country,
                    //   controller: _countryController,
                    //   dropdownMenuEntries: countryMenuList),
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
                                '${value.day}/${value.month}/${value.year}';
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
                    DropdownButton(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(30),
                      value: dropdownLevelValue,
                      items: levelTittleList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownLevelValue = newValue!;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
