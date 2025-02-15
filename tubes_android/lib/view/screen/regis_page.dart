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

// Validasi Nama Lengkap
  String? _validateFullname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }
    List<String> words = value.split(" ");
    for (var word in words) {
      if (word.isNotEmpty && word[0] != word[0].toUpperCase()) {
        return 'Setiap kata harus diawali huruf kapital';
      }
    }
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi';
    }
    return null;
  }

// Validasi Nomor Telepon
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^62\d{8,13}$').hasMatch(value)) {
      return 'Nomor telepon harus diawali 62 dan berisi 10-15 angka';
    }
    return null;
  }

// Validasi Username
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

// Validasi Password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Password minimal 3 karakter';
    }
    return null;
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
        _showSnackbar(
            "Registrasi berhasil! Role: ${res?.role ?? 'Tidak ditemukan'}");

        // Hapus data hanya jika registrasi berhasil
        _fullnameController.clear();
        _phonenumberController.clear();
        _usernameController.clear();
        _passwordController.clear();

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
                            _buildTextField("Full Name", Icons.near_me,
                                _fullnameController, _validateFullname),
                            _buildTextField("Phone Number", Icons.phone,
                                _phonenumberController, _validatePhoneNumber),
                            _buildTextField("Username", Icons.person,
                                _usernameController, _validateUsername),
                            _buildTextField("Password", Icons.lock,
                                _passwordController, _validatePassword,
                                obscureText: true),
                            const SizedBox(height: 24),
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _handleRegister,
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
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              },
                              child: const Text(
                                "Back to Home",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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

  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, String? Function(String?) validator,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          prefixIcon: Icon(icon, color: Colors.white70),
        ),
      ),
    );
  }
}
