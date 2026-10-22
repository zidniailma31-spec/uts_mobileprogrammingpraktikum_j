/// Model untuk satu destinasi wisata.
/// Nama field disamakan dengan key JSON agar mudah diganti ke data API nanti.
class Destinasi {
  final int id;
  final String nama;
  final int kategoriId;
  final String lokasi;
  final String alamat;
  final double latitude;
  final double longitude;
  final int hargaTiket;
  final String jamBuka;
  final double rating;
  final int jumlahUlasan;
  final bool populer;
  final String gambar;
  final List<String> fasilitas;
  final String deskripsi;

  Destinasi({
    required this.id,
    required this.nama,
    required this.kategoriId,
    required this.lokasi,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.hargaTiket,
    required this.jamBuka,
    required this.rating,
    required this.jumlahUlasan,
    required this.populer,
    required this.gambar,
    required this.fasilitas,
    required this.deskripsi,
  });

  /// Membuat objek Destinasi dari data JSON.
  factory Destinasi.fromJson(Map<String, dynamic> json) {
    return Destinasi(
      id: json['id'],
      nama: json['nama'],
      kategoriId: json['kategoriId'],
      lokasi: json['lokasi'],
      alamat: json['alamat'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      hargaTiket: json['hargaTiket'],
      jamBuka: json['jamBuka'],
      rating: (json['rating'] as num).toDouble(),
      jumlahUlasan: json['jumlahUlasan'] ?? 0,
      populer: json['populer'] ?? false,
      gambar: json['gambar'],
      fasilitas: List<String>.from(json['fasilitas'] ?? []),
      deskripsi: json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'kategoriId': kategoriId,
        'lokasi': lokasi,
        'alamat': alamat,
        'latitude': latitude,
        'longitude': longitude,
        'hargaTiket': hargaTiket,
        'jamBuka': jamBuka,
        'rating': rating,
        'jumlahUlasan': jumlahUlasan,
        'populer': populer,
        'gambar': gambar,
        'fasilitas': fasilitas,
        'deskripsi': deskripsi,
      };

  /// Teks harga siap tampil, contoh: "Rp35.000" atau "Gratis".
  String get hargaLabel {
    if (hargaTiket == 0) return 'Gratis';
    return 'Rp${_titik(hargaTiket)}';
  }

  /// Teks jumlah ulasan, contoh: "12.620 ulasan".
  String get ulasanLabel => '${_titik(jumlahUlasan)} ulasan';

  /// Link Google Maps yang menampilkan titik lokasi destinasi.
  String get lokasiUrl =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  /// Link Google Maps untuk petunjuk arah ke destinasi
  /// dari lokasi pengguna saat ini.
  String get ruteUrl =>
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving';

  /// Memberi titik pemisah ribuan, contoh: 12620 -> "12.620".
  static String _titik(int angka) => angka.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]}.',
      );
}