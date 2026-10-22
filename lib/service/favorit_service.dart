import 'package:flutter/foundation.dart';

/// Menyimpan daftar id destinasi favorit selama aplikasi berjalan.
/// ValueNotifier membuat halaman yang memantau otomatis diperbarui
/// saat favorit ditambah atau dihapus.
class FavoritService {
  static final ValueNotifier<Set<int>> favorit = ValueNotifier<Set<int>>({});

  static bool isFavorit(int id) => favorit.value.contains(id);

  static void toggle(int id) {
    final baru = Set<int>.from(favorit.value);
    if (baru.contains(id)) {
      baru.remove(id);
    } else {
      baru.add(id);
    }
    favorit.value = baru;
  }
}
