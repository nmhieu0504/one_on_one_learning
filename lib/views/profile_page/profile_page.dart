import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_picture.jpg'),
          ),
          SizedBox(height: 20),
          Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'johndoe@email.com',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            '123-456-7890',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            '123 Main Street\nAnytown, USA 12345',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'I am a Flutter developer with 2 years of experience. '
            'I specialize in building mobile applications for Android and iOS platforms.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
