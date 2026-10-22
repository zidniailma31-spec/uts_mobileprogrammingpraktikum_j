import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../model/destinasi.dart';
import '../model/kategori.dart';

/// Service untuk mengambil data wisata.
/// Saat ini membaca file JSON lokal. Nanti cukup ganti isi fungsi _loadJson()
/// dengan http.get() ke API, halaman lain tidak perlu diubah.
class WisataService {
  // Data disimpan setelah dibaca pertama kali agar tidak dibaca berulang.
  static Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _loadJson() async {
    if (_cache != null) return _cache!;
    final String jsonString =
        await rootBundle.loadString('assets/data/wisata.json');
    _cache = jsonDecode(jsonString);
    return _cache!;
  }

  /// Mengambil semua kategori.
  Future<List<Kategori>> getKategori() async {
    final data = await _loadJson();
    return (data['kategori'] as List)
        .map((item) => Kategori.fromJson(item))
        .toList();
  }

  /// Mengambil satu kategori berdasarkan id.
  Future<Kategori> getKategoriById(int id) async {
    final semua = await getKategori();
    return semua.firstWhere((k) => k.id == id);
  }

  /// Mengambil semua destinasi.
  Future<List<Destinasi>> getDestinasi() async {
    final data = await _loadJson();
    return (data['destinasi'] as List)
        .map((item) => Destinasi.fromJson(item))
        .toList();
  }

  /// Mengambil destinasi berdasarkan kategori tertentu.
  Future<List<Destinasi>> getDestinasiByKategori(int kategoriId) async {
    final semua = await getDestinasi();
    return semua.where((d) => d.kategoriId == kategoriId).toList();
  }

  /// Mengambil destinasi yang ditandai populer (untuk Beranda).
  Future<List<Destinasi>> getDestinasiPopuler() async {
    final semua = await getDestinasi();
    return semua.where((d) => d.populer).toList();
  }
}
