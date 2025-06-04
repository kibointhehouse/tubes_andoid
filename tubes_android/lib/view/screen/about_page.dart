import 'package:flutter/material.dart';
import 'package:tubes_android/services/auth_manager.dart';
import 'package:tubes_android/view/screen/login_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 81, 1, 185),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar Header dengan efek full
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://arsitagx-master-article.s3.ap-southeast-1.amazonaws.com/article-photo/807/desain-restoran-kontemporer-5.jpg'),
                      fit: BoxFit.cover, // Full image, tanpa terpotong
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: const Text(
                    "Aplikasi Manajemen Restoran",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Deskripsi Aplikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tentang Aplikasi",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Aplikasi Manajemen Menu Restoran mempermudah pengelolaan menu dengan fitur tambah, edit, hapus, dan tampilan daftar menu secara digital, sehingga lebih efisien, akurat, dan fleksibel bagi pengelola restoran."
                        "Dengan fitur yang mudah digunakan, restoran dapat meningkatkan produktivitas dan pelayanan kepada pelanggan.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Fitur-Fitur Aplikasi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFeatureCard(
                    icon: Icons.restaurant_menu,
                    title: "Kelola Menu dengan Mudah",
                    description:
                        "Tambahkan, edit, dan hapus menu restoran dengan cepat dan mudah.",
                  ),
                  _buildFeatureCard(
                    icon: Icons.inventory,
                    title: "Manajemen Stok yang Efisien",
                    description:
                        "Pantau ketersediaan bahan baku agar stok selalu tersedia.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Card Fitur dengan animasi hover
  Widget _buildFeatureCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
