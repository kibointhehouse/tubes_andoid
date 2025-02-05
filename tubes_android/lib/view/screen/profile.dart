import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Ini adalah halaman Profile',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
