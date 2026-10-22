import 'package:flutter/material.dart';

/// Kumpulan warna aplikasi (sesuai panduan desain di Figma).
class AppColors {
  static const primer = Color(0xFF0E5A4A);
  static const primerLembut = Color(0xFFE3EFEA);
  static const aksen = Color(0xFFE8963A);
  static const teks = Color(0xFF17201D);
  static const teksSekunder = Color(0xFF5C6964);
  static const latar = Color(0xFFF5F6F2);
  static const kartu = Color(0xFFFFFFFF);
  static const garis = Color(0xFFE2E6E1);

  /// Warna kotak pengganti foto, dibedakan per kategori.
  static Color warnaKategori(int kategoriId) {
    switch (kategoriId) {
      case 1:
        return const Color(0xFF9CB8A2); // Alam
      case 2:
        return const Color(0xFF8FB3C9); // Pantai
      case 3:
        return const Color(0xFFD9B48F); // Kuliner
      case 4:
        return const Color(0xFFC2A98E); // Sejarah & Budaya
      default:
        return const Color(0xFFB7A6CC); // Taman Rekreasi
    }
  }

  /// Ikon per kategori, dipakai saat foto belum tersedia.
  static IconData ikonKategori(int kategoriId) {
    switch (kategoriId) {
      case 1:
        return Icons.forest;
      case 2:
        return Icons.beach_access;
      case 3:
        return Icons.restaurant;
      case 4:
        return Icons.account_balance;
      default:
        return Icons.attractions;
    }
  }
}

/// Tema utama aplikasi: warna, font Plus Jakarta Sans, dan gaya dasar.
/// Font diambil dari folder assets/fonts (didaftarkan di pubspec.yaml).
ThemeData buatTema() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primer,
      primary: AppColors.primer,
      surface: AppColors.latar,
    ),
    scaffoldBackgroundColor: AppColors.latar,
  ).copyWith(
    textTheme: ThemeData(fontFamily: 'PlusJakartaSans').textTheme.apply(
          bodyColor: AppColors.teks,
          displayColor: AppColors.teks,
        ),
  );
}
