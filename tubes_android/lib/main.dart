import 'package:tubes_android/view/screen/login_page.dart';
import 'package:flutter/material.dart';
// import 'view/screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: false,
      ),
      home: const LoginPage(),
    );
  }
}
