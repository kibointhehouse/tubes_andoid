import 'package:flutter/material.dart';
import 'package:tubes_android/model/regis_model.dart';
import 'package:tubes_android/services/api_services.dart';
import 'package:tubes_android/view/screen/home_page.dart';
import 'package:tubes_android/view/screen/login_page.dart';

class RegisPage extends StatefulWidget {
  const RegisPage({super.key});

  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiServices _dataService = ApiServices();
  bool isLoading = false;

  @override
  void dispose() {
    _fullnameController.dispose();
    _phonenumberController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// Fullname Validation
  String? _validateFullname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }
    // Cek apakah setiap kata diawali huruf besar
    List<String> words = value.split(" ");
    for (var word in words) {
      if (word.isNotEmpty && word[0] != word[0].toUpperCase()) {
        return 'Setiap kata harus diawali huruf kapital';
      }
    }
    // Cek apakah ada angka atau karakter unik
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi';
    }

    return null;
  }

// Phone Number Validation
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^62\d{8,13}$').hasMatch(value)) {
      return 'Nomor telepon harus diawali 62 dan berisi 10-15 angka';
    }
    return null;
  }

// Username Validation
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (value.length < 4) {
      return 'Username minimal 4 karakter';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Username hanya boleh berisi huruf dan angka';
    }
    return null;
  }

// Password Validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Password minimal 3 karakter';
    }
    return null;
  }

  void _clearForm() {
    print("clear form");
    setState(() {
      _fullnameController.clear();
      _phonenumberController.clear();
      _usernameController.clear();
      _passwordController.clear();
    });
    print("Form cleared! Fullname: ${_fullnameController.text}");
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final regisModel = RegisInput(
        fullname: _fullnameController.text,
        phonenumber: _phonenumberController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      RegisResponse? res = await _dataService.register(regisModel);
      setState(() => isLoading = false);

      if (res?.status == 201) {
        setState(() {
          _clearForm(); // Clear form dan update UI
        });

        String roleMessage = res?.role != null
            ? "Role: ${res!.role}" // Menampilkan role yang diterima
            : "Role tidak ditemukan";

        _showSnackbar("Registrasi berhasil! $roleMessage");

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        });
      } else {
        _showSnackbar(res?.message ?? "Registrasi gagal");
      }
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.green,
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
                              controller: _fullnameController,
                              validator: _validateFullname,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                "Full Name",
                                Icons.near_me,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phonenumberController,
                              validator: _validatePhoneNumber,
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
                                    onPressed: () {
                                      _handleRegister();
                                      _clearForm(); // Tambahkan ini untuk memastikan form di-reset
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 40),
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

                            // Tombol "Back to Home"
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Back to Home",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
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
