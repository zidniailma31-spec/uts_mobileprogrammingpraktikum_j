import 'package:flutter/material.dart';

import '../model/destinasi.dart';
import '../model/kategori.dart';
import '../service/wisata_service.dart';
import '../theme/app_theme.dart';
import '../widgets/kartu_destinasi.dart';
import 'detail_page.dart';
import 'kategori_page.dart';

/// Halaman Beranda: sapaan, pencarian, kategori, populer, dan rekomendasi.
class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final WisataService _service = WisataService();
  late final Future<_DataBeranda> _futureData;
  String _kataCari = '';

  @override
  void initState() {
    super.initState();
    _futureData = _muatData();
  }

  /// Memuat kategori dan destinasi sekaligus.
  Future<_DataBeranda> _muatData() async {
    final kategori = await _service.getKategori();
    final destinasi = await _service.getDestinasi();
    return _DataBeranda(kategori, destinasi);
  }

  void _bukaDetail(Destinasi d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(destinasi: d)),
    );
  }

  void _bukaKategori(int? kategoriId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KategoriPage(kategoriAwal: kategoriId),
      ),
    );
  }

  /// Menampilkan daftar notifikasi (data dummy) dari bawah layar.
  void _tampilkanNotifikasi() {
    const notifikasi = [
      (
        Icons.wb_sunny_outlined,
        'Cuaca cerah di Batu',
        'Waktu yang pas untuk ke Coban Rondo atau Alun-Alun Kota Batu.'
      ),
      (
        Icons.event_outlined,
        'Akhir pekan ramai',
        'Datang lebih pagi ke Jatim Park 2 dan Museum Angkut agar tidak antre.'
      ),
      (
        Icons.info_outline,
        'Pantai Tiga Warna',
        'Wajib reservasi terlebih dahulu sebelum berkunjung.'
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kartu,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notifikasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...notifikasi.map((n) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primerLembut,
                      child: Icon(n.$1, color: AppColors.primer),
                    ),
                    title: Text(n.$2,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(n.$3),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<_DataBeranda>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final populer = data.destinasi.where((d) => d.populer).toList();

          // Rekomendasi: semua destinasi, disaring sesuai kata pencarian.
          final rekomendasi = data.destinasi
              .where((d) =>
                  d.nama.toLowerCase().contains(_kataCari.toLowerCase()))
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              _header(),
              const SizedBox(height: 16),
              _kolomCari(),
              const SizedBox(height: 24),

              // ---------- Kategori ----------
              const _JudulBagian(judul: 'Kategori'),
              const SizedBox(height: 12),
              Row(
                children: data.kategori
                    .map((k) => Expanded(
                          child: _TombolKategori(
                            kategori: k,
                            onTap: () => _bukaKategori(k.id),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // ---------- Destinasi Populer ----------
              if (_kataCari.isEmpty) ...[
                _JudulBagian(
                  judul: 'Destinasi Populer',
                  aksi: 'Lihat semua',
                  onAksi: () => _bukaKategori(null),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 236,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: populer.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 14),
                    itemBuilder: (context, i) => KartuPopuler(
                      destinasi: populer[i],
                      onTap: () => _bukaDetail(populer[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ---------- Rekomendasi / Hasil pencarian ----------
              _JudulBagian(
                judul: _kataCari.isEmpty
                    ? 'Rekomendasi Untukmu'
                    : 'Hasil pencarian (${rekomendasi.length})',
              ),
              const SizedBox(height: 12),
              if (rekomendasi.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Destinasi tidak ditemukan',
                        style: TextStyle(color: AppColors.teksSekunder)),
                  ),
                ),
              ...rekomendasi.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: KartuDestinasi(
                      destinasi: d,
                      onTap: () => _bukaDetail(d),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo, Zidnia',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.teksSekunder,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text('Mau jelajah ke mana\nhari ini?',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800, height: 1.25)),
            ],
          ),
        ),
        // Tombol lonceng: menampilkan notifikasi (tips wisata).
        Material(
          color: AppColors.kartu,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _tampilkanNotifikasi,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.garis),
              ),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kolomCari() {
    return TextField(
      onChanged: (teks) => setState(() => _kataCari = teks),
      decoration: InputDecoration(
        hintText: 'Cari destinasi wisata...',
        hintStyle: const TextStyle(color: AppColors.teksSekunder, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.teksSekunder),
        filled: true,
        fillColor: AppColors.kartu,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.garis),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primer, width: 1.5),
        ),
      ),
    );
  }
}

/// Penampung data Beranda (kategori + destinasi).
class _DataBeranda {
  final List<Kategori> kategori;
  final List<Destinasi> destinasi;

  _DataBeranda(this.kategori, this.destinasi);
}

/// Judul bagian, dengan tombol teks opsional di kanan (misal "Lihat semua").
class _JudulBagian extends StatelessWidget {
  final String judul;
  final String? aksi;
  final VoidCallback? onAksi;

  const _JudulBagian({required this.judul, this.aksi, this.onAksi});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(judul,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        if (aksi != null)
          GestureDetector(
            onTap: onAksi,
            child: Text(aksi!,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primer)),
          ),
      ],
    );
  }
}

/// Tombol ikon kategori di Beranda.
class _TombolKategori extends StatelessWidget {
  final Kategori kategori;
  final VoidCallback onTap;

  const _TombolKategori({required this.kategori, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Nama pendek agar muat di layar: "Sejarah & Budaya" -> "Sejarah".
    final namaPendek = kategori.nama.split(' ').first;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primerLembut,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(kategori.iconData, color: AppColors.primer),
          ),
          const SizedBox(height: 6),
          Text(namaPendek,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}