import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aplikasi Manajemen Restoran',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aplikasi ini dirancang untuk membantu pemilik restoran dalam mengelola menu, pesanan, dan stok dengan lebih efisien. ' 
              'Dengan fitur yang mudah digunakan, restoran dapat meningkatkan produktivitas dan layanan kepada pelanggan.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.restaurant_menu, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text(
                  'Kelola Menu dengan Mudah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.inventory, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text(
                  'Manajemen Stok yang Efisien',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
