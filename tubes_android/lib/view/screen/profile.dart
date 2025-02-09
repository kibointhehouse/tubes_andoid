import 'package:flutter/material.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/login_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
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

// LOGOUT
void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Anda yakin ingin logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              await AuthManager.logout();
              Navigator.pushAndRemoveUntil(
                dialogContext,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Ya'),
          ),
        ],
      );
    },
  );
}
