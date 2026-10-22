import 'package:flutter/material.dart';

/// Model untuk kategori wisata (Alam, Pantai, Kuliner, dst.).
class Kategori {
  final int id;
  final String nama;
  final String ikon;

  Kategori({
    required this.id,
    required this.nama,
    required this.ikon,
  });

  /// Membuat objek Kategori dari data JSON.
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
      ikon: json['ikon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'ikon': ikon,
      };

  /// Mengubah nama ikon (String dari JSON) menjadi IconData Flutter.
  IconData get iconData {
    switch (ikon) {
      case 'forest':
        return Icons.forest;
      case 'beach_access':
        return Icons.beach_access;
      case 'restaurant':
        return Icons.restaurant;
      case 'account_balance':
        return Icons.account_balance;
      case 'attractions':
        return Icons.attractions;
      default:
        return Icons.place;
    }
  }
}
