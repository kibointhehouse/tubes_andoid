import 'package:tubes_android/view/screen/about_page.dart';
// import 'package:tubes_android/view/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:tubes_android/view/screen/menu_page.dart';
import 'profile_page.dart'; // Tambahkan file untuk halaman kedua

class DynamicBottomNavBar extends StatefulWidget {
  const DynamicBottomNavBar({super.key});

  @override
  _BottomNavBar createState() => _BottomNavBar();
}

class _BottomNavBar extends State<DynamicBottomNavBar> {
  int _currentPageIndex = 0; // Menyimpan indeks halaman aktif

  // Daftar halaman yang terhubung dengan BotNav
  final List<Widget> _pages = <Widget>[
    // const HomePage(), // Halaman Home
    const MenuPage(), // Halaman Menu
    const Profile(), // Halaman Kelola Data
    const About(), // Halaman Kelola Data
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index; // Ubah halaman aktif berdasarkan tab yang ditekan
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home), // Ikon Home
          //   label: 'Home', // Label Home
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), // Ikon
            label: 'Menu', // Label Menu
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Ikon
            label: 'Profile', // Label profile
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline), // Ikon
            label: 'About', // Label Kelola Data
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 81, 1, 185), // Warna latar BotNav
        selectedItemColor: Colors.white, // Warna item aktif
        unselectedItemColor: const Color.fromARGB(255, 220, 210, 232), // Warna item tidak aktif
      ),
    );
  }
}
