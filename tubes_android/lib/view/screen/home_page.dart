import 'package:flutter/material.dart';
import 'package:tubes_android/view/screen/regis_page.dart';
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
        title: const Padding(
          padding: EdgeInsets.only(top: 10), // Tambahkan jarak ke atas
          child: Text(
            'HomePage',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Warna teks navbar menjadi hitam
            ),
          ),
        ),
        centerTitle: false, // Membuat teks HomePage rata kiri
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20.0), // Tambahkan jarak ke atas
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A11CB), // Warna ungu
                foregroundColor: Colors.white, // Warna teks putih
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
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
          // Background Color diubah menjadi putih
          Container(
            color: Colors.white,
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 120), // Tambahkan lebih banyak jarak agar tidak terlalu atas

                  // Ilustrasi (Ganti dengan asset jika ada)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://www.saniharto.com/assets/gallery/Gambar_Resotran_Park_Hyatt_Jakarta.jpeg',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Welcome to MyApp!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Warna teks hitam agar kontras
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Sub-title
                  const Text(
                    'Restaurant Menu Management',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Warna abu-abu untuk teks tambahan
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Tombol Get Started di bawah
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A11CB), // Warna ungu seperti di tombol Sign In
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Warna teks putih agar kontras
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
