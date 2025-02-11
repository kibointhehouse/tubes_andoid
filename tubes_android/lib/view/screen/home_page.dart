import 'package:flutter/material.dart';
import 'login_page.dart'; // Pastikan file ini ada

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Navbar menyatu dengan background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Navbar transparan
        elevation: 0, // Menghilangkan bayangan navbar
        title: const Text(
          'HomePage',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false, // Membuat teks HomePage rata kiri
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Warna tombol putih
                foregroundColor: const Color(0xFF6A11CB), // Warna teks ungu
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Memperlebar tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Membulatkan tombol
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Sama dengan login page
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100), // Menghindari overlap dengan navbar

                  // Ilustrasi (Ganti dengan asset jika ada)
                  Image.network(
                    'https://www.saniharto.com/assets/gallery/Gambar_Resotran_Park_Hyatt_Jakarta.jpeg',
                    height: 200,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Welcome to MyApp!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Sub-title
                  const Text(
                    'Management Menu Restaurant',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Tombol Get Started di bawah
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Warna putih seperti tombol login
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Membulatkan tombol
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A11CB), // Warna ungu
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
