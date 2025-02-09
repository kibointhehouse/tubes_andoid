import 'package:flutter/material.dart';
import 'package:tubes_android/model/login_model.dart';
import 'package:tubes_android/services/api_services.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/botnav.dart';
import 'package:tubes_android/view/screen/login_page.dart'; // Tambahkan halaman register

class RegisPage extends StatefulWidget {
  const RegisPage({super.key});

  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiServices _dataService = ApiServices();
  bool isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final postModel = LoginInput(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      LoginResponse? res = await _dataService.login(postModel);
      setState(() => isLoading = false);

      if (res?.status == 200) {
        await AuthManager.login(_usernameController.text, res!.token!);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DynamicBottomNavBar()),
          (route) => false,
        );
      } else {
        _showSnackbar(res?.message ?? "Login gagal");
      }
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Restaurant Menu Management",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
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
                              "Registration",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              // controller: _usernameController,
                              // validator: _validateUsername,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                "Full Name",
                                Icons.near_me,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              // controller: _usernameController,
                              // validator: _validateUsername,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                "Phone Number",
                                Icons.phone,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _usernameController,
                              validator: _validateUsername,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                "Username",
                                Icons.person,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              validator: _validatePassword,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                "Password",
                                Icons.lock,
                              ),
                            ),
                            const SizedBox(height: 24),
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 40,
                                      ),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Color(0xFF6A11CB),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign in here.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                          0xFFFFD700), // Warna emas agar mencolok
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.white70),
    );
  }
}
