import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'beranda_page.dart';
import 'favorit_page.dart';
import 'kategori_page.dart';
import 'profil_page.dart';

/// Halaman induk yang berisi BottomNavigationBar dengan 4 menu.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _indexAktif = 0;

  // Daftar halaman sesuai urutan menu di bawah.
  final List<Widget> _halaman = const [
    BerandaPage(),
    KategoriPage(tampilkanKembali: false),
    FavoritPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga posisi scroll tiap halaman saat berpindah menu.
      body: IndexedStack(index: _indexAktif, children: _halaman),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexAktif,
        onTap: (index) => setState(() => _indexAktif = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.kartu,
        selectedItemColor: AppColors.primer,
        unselectedItemColor: AppColors.teksSekunder,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Jelajah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
