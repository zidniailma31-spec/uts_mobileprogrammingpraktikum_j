import 'dart:convert';
import 'dart:io';

/// Mencari foto destinasi secara otomatis dari Wikimedia Commons
/// (kumpulan foto bebas pakai milik Wikipedia) berdasarkan nama tempat.
class FotoService {
  /// Identitas aplikasi yang dikirim ke server Wikimedia (wajib menurut
  /// aturan Wikimedia, permintaan tanpa identitas bisa ditolak).
  static const userAgent = 'JelajahMalang/1.0 (tugas UTS Mobile Programming)';

  /// Kata kunci tambahan untuk tempat yang fotonya di Wikimedia
  /// memakai nama lain (misalnya nama bahasa Inggris).
  /// Dicoba berurutan sampai ada foto yang ditemukan.
  static const Map<String, List<String>> _kataKunciTambahan = {
    'Coban Rondo': ['Coban Rondo waterfall', 'Coban Rondo Batu'],
    'Coban Pelangi': ['Coban Pelangi waterfall', 'Rainbow waterfall Malang'],
    'Kebun Teh Wonosari': ['Wonosari tea plantation', 'Kebun teh Lawang'],
    'Pantai Balekambang': ['Balekambang beach', 'Balekambang'],
    'Pantai Tiga Warna': ['Tiga Warna beach', 'Sendang Biru'],
    'Pantai Goa Cina': ['Goa Cina beach', 'Goa China Malang'],
    'Bakso President': ['Bakso Malang', 'Bakso'],
    'Pos Ketan Legenda': ['Ketan Batu', 'Ketan susu'],
    'Toko Oen': ['Oen Malang'],
    'Candi Singosari': ['Singhasari temple', 'Singosari temple'],
    'Museum Brawijaya': ['Brawijaya Museum', 'Museum Brawijaya Malang'],
    'Kampung Warna-Warni Jodipan': ['Jodipan', 'Kampung Warna Warni Malang'],
    'Jatim Park 2': ['Batu Secret Zoo', 'Jawa Timur Park 2'],
    'Museum Angkut': ['Angkut Museum', 'Museum Angkut Batu'],
    'Alun-Alun Kota Batu': ['Alun-alun Batu', 'Batu East Java'],
  };

  // Hasil yang BERHASIL disimpan agar tiap nama hanya dicari sekali.
  static final Map<String, String> _cache = {};

  // Antrean: permintaan dikirim satu per satu (tidak serentak),
  // supaya tidak ditolak server karena terlalu banyak sekaligus.
  static Future<void> _antrean = Future.value();

  /// Mengembalikan link foto, atau null jika tidak ditemukan.
  static Future<String?> cariFoto(String nama) async {
    if (_cache.containsKey(nama)) return _cache[nama];

    final hasil = _antrean.then((_) => _cariDenganBeberapaKataKunci(nama));
    _antrean = hasil.then((_) {}, onError: (_) {});

    final url = await hasil;
    if (url != null) _cache[nama] = url;
    return url;
  }

  static Future<String?> _cariDenganBeberapaKataKunci(String nama) async {
    if (_cache.containsKey(nama)) return _cache[nama];

    final daftarKataKunci = [nama, ...?_kataKunciTambahan[nama]];
    for (final kataKunci in daftarKataKunci) {
      final url = await _cari(kataKunci);
      if (url != null) return url;
    }
    return null;
  }

  static Future<String?> _cari(String kataKunci) async {
    final uri = Uri.https('commons.wikimedia.org', '/w/api.php', {
      'action': 'query',
      'format': 'json',
      'generator': 'search',
      'gsrsearch': 'filetype:bitmap $kataKunci', // hanya file foto
      'gsrnamespace': '6', // 6 = ruang nama "File"
      'gsrlimit': '5',
      'prop': 'imageinfo',
      'iiprop': 'url',
      'iiurlwidth': '800', // minta ukuran lebar 800px agar ringan
    });

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, userAgent);
      final response = await request.close();
      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final pages = (data['query']?['pages'] as Map<String, dynamic>?)
              ?.values
              .toList() ??
          [];

      // Urutkan sesuai peringkat hasil pencarian, ambil yang paling cocok.
      pages.sort((a, b) =>
          ((a['index'] ?? 0) as int).compareTo((b['index'] ?? 0) as int));
      for (final page in pages) {
        final info = (page['imageinfo'] as List?)?.first;
        final url = info?['thumburl'] ?? info?['url'];
        if (url is String) return url;
      }
      return null;
    } catch (_) {
      return null; // tidak ada internet / gagal -> pakai placeholder
    } finally {
      client.close();
    }
  }
}