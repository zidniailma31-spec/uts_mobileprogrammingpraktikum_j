import 'package:flutter/material.dart';

import '../model/destinasi.dart';
import '../model/kategori.dart';
import '../service/wisata_service.dart';
import '../theme/app_theme.dart';
import '../widgets/kartu_destinasi.dart';
import 'detail_page.dart';

/// Halaman daftar destinasi yang bisa disaring per kategori.
/// - Dibuka dari Beranda: [kategoriAwal] terisi dan ada tombol kembali.
/// - Dibuka dari menu "Jelajah": menampilkan semua destinasi.
class KategoriPage extends StatefulWidget {
  final int? kategoriAwal;
  final bool tampilkanKembali;

  const KategoriPage({
    super.key,
    this.kategoriAwal,
    this.tampilkanKembali = true,
  });

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final WisataService _service = WisataService();
  // Kategori dan destinasi dimuat sekali saat halaman dibuka.
  late final Future<List<Object>> _futureData;

  // null artinya "Semua".
  int? _kategoriDipilih;

  @override
  void initState() {
    super.initState();
    _kategoriDipilih = widget.kategoriAwal;
    _futureData = Future.wait<Object>([
      _service.getKategori(),
      _service.getDestinasi(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Object>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final kategori = snapshot.data![0] as List<Kategori>;
            final semua = snapshot.data![1] as List<Destinasi>;

            // Saring destinasi sesuai kategori yang dipilih.
            final daftar = _kategoriDipilih == null
                ? semua
                : semua.where((d) => d.kategoriId == _kategoriDipilih).toList();

            final judul = _kategoriDipilih == null
                ? 'Semua Destinasi'
                : 'Wisata ${kategori.firstWhere((k) => k.id == _kategoriDipilih).nama}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(judul, daftar.length),
                _barisFilter(kategori),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: daftar.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, i) => KartuDestinasi(
                      destinasi: daftar[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(destinasi: daftar[i]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _appBar(String judul, int jumlah) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          if (widget.tampilkanKembali) ...[
            _TombolKotak(
              ikon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('$jumlah destinasi ditemukan',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.teksSekunder)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Deretan chip filter: Semua + tiap kategori.
  Widget _barisFilter(List<Kategori> kategori) {
    final pilihan = <int?>[null, ...kategori.map((k) => k.id)];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: pilihan.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final id = pilihan[i];
          final label = id == null
              ? 'Semua'
              : kategori.firstWhere((k) => k.id == id).nama;
          final aktif = id == _kategoriDipilih;

          return ChoiceChip(
            label: Text(label),
            selected: aktif,
            showCheckmark: false,
            onSelected: (_) => setState(() => _kategoriDipilih = id),
            selectedColor: AppColors.primer,
            backgroundColor: AppColors.kartu,
            side: BorderSide(
                color: aktif ? AppColors.primer : AppColors.garis),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999)),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : AppColors.teks,
            ),
          );
        },
      ),
    );
  }
}

/// Tombol kotak putih kecil (dipakai untuk tombol kembali).
class _TombolKotak extends StatelessWidget {
  final IconData ikon;
  final VoidCallback onTap;

  const _TombolKotak({required this.ikon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kartu,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.garis),
          ),
          child: Icon(ikon, size: 20),
        ),
      ),
    );
  }
}
