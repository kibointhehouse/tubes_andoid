import 'package:tubes_android/view/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'profile.dart'; // Tambahkan file untuk halaman kedua

class BottomNavbar extends StatefulWidget {
  // const DynamicBottomNavBar({super.key});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentPageIndex = 0; // Menyimpan indeks halaman aktif

  // Daftar halaman yang terhubung dengan BotNav
  final List<Widget> _pages = <Widget>[
    HomePage(), // Halaman Home
    Profile(), // Halaman profile
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex =
          index; // Ubah halaman aktif berdasarkan tab yang ditekan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex], // Tampilkan halaman sesuai indeks aktif
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex, // Menentukan tab aktif
        onTap: onTabTapped, // Panggil fungsi untuk mengubah halaman
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ikon Home
            label: 'Home', // Label Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_off_outlined), // Ikon
            label: 'Profile', // Label Kelola Data
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_off_outlined), // Ikon
            label: 'About', // Label Kelola Data
          ),
        ],
        backgroundColor: Colors.pink, // Warna latar BotNav
        selectedItemColor: Colors.brown[200], // Warna item aktif
        unselectedItemColor: Colors.white, // Warna item tidak aktif
      ),
    );
  }
}
