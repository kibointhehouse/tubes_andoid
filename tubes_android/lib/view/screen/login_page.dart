import 'package:tubes_android/model/login_model.dart';
import 'package:tubes_android/services/api_services.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    bool isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf1f5f8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 118, 0, 245),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _usernameController,
                    validator: _validateUsername,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Write your username',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person,
                          color: Color.fromARGB(255, 118, 0, 245)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    validator: _validatePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Write your password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock,
                          color: Color.fromARGB(255, 118, 0, 245)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      backgroundColor: const Color.fromARGB(255, 118, 0, 245),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: const Color.fromARGB(255, 9, 20, 232),
                    ),
                    onPressed: () async {
                      final isValidForm = _formKey.currentState!.validate();
                      if (isValidForm) {
                        final postModel = LoginInput(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        );
                        LoginResponse? res =
                            await _dataService.login(postModel);
                        if (res!.status == 200) {
                          await AuthManager.login(
                              _usernameController.text, res.token!);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false,
                          );
                        } else {
                          displaySnackbar(res.message);
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Color.fromARGB(255, 252, 235, 253),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
