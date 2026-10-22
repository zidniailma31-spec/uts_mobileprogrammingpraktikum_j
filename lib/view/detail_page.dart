import 'package:flutter/material.dart';

import '../model/destinasi.dart';
import '../model/kategori.dart';
import '../service/favorit_service.dart';
import '../service/maps_service.dart';
import '../service/wisata_service.dart';
import '../theme/app_theme.dart';
import '../widgets/foto_destinasi.dart';

/// Halaman detail satu destinasi.
/// Data destinasi dikirim dari halaman sebelumnya lewat Navigator.push.
class DetailPage extends StatelessWidget {
  final Destinasi destinasi;

  const DetailPage({super.key, required this.destinasi});

  @override
  Widget build(BuildContext context) {
    final d = destinasi;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Foto besar + tombol kembali & favorit ----------
            Stack(
              children: [
                FotoDestinasi(
                  destinasi: d,
                  height: 320,
                  width: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      _TombolBulat(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                      const Spacer(),
                      // Tombol favorit ikut berubah saat ditekan.
                      ValueListenableBuilder<Set<int>>(
                        valueListenable: FavoritService.favorit,
                        builder: (context, favorit, _) {
                          final aktif = favorit.contains(d.id);
                          return _TombolBulat(
                            onTap: () => FavoritService.toggle(d.id),
                            child: Icon(
                              aktif ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: aktif
                                  ? const Color(0xFFC2410C)
                                  : AppColors.teks,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ---------- Isi (naik sedikit menutupi foto) ----------
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                decoration: const BoxDecoration(
                  color: AppColors.latar,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChipKategori(kategoriId: d.kategoriId),
                    const SizedBox(height: 8),
                    Text(d.nama,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    // Alamat bisa diketuk untuk membuka pilihan peta / rute.
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _tampilkanPilihanPeta(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 16, color: AppColors.primer),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.alamat,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.teksSekunder)),
                                  const SizedBox(height: 2),
                                  const Text('Lihat di peta',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primer)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tiga kotak info: rating, jam buka, tiket
                    Row(
                      children: [
                        Expanded(
                          child: _KotakInfo(
                            ikon: Icons.star_rounded,
                            warnaIkon: AppColors.aksen,
                            label: 'Rating',
                            nilai: '${d.rating} / 5',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _KotakInfo(
                            ikon: Icons.schedule,
                            label: 'Jam buka',
                            nilai: d.jamBuka,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _KotakInfo(
                            ikon: Icons.confirmation_number_outlined,
                            label: 'Tiket',
                            nilai: d.hargaLabel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Berdasarkan ${d.ulasanLabel} di Google Maps',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.teksSekunder)),
                    const SizedBox(height: 20),

                    const Text('Tentang',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(d.deskripsi,
                        style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Color(0xFF3D4844))),
                    const SizedBox(height: 20),

                    const Text('Fasilitas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: d.fasilitas
                          .map((f) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: AppColors.kartu,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.garis),
                                ),
                                child: Text(f,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------- Bar bawah: harga + tombol rute ----------
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: AppColors.kartu,
          border: Border(top: BorderSide(color: AppColors.garis)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Harga tiket',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.teksSekunder)),
                  Text(d.hargaLabel,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primer)),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _bukaMaps(context, destinasi.ruteUrl),
              icon: const Icon(Icons.directions, size: 18),
              label: const Text('Lihat Rute'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primer,
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membuka link Google Maps. Jika gagal, tampilkan pesan di bawah layar.
  Future<void> _bukaMaps(BuildContext context, String url) async {
    final berhasil = await MapsService.buka(url);
    if (!berhasil && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }

  /// Lembar bawah berisi alamat dan dua pilihan: lihat lokasi atau rute.
  void _tampilkanPilihanPeta(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kartu,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lokasi ${destinasi.nama}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(destinasi.alamat,
                  style: const TextStyle(
                      height: 1.5, color: AppColors.teksSekunder)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primerLembut,
                  child: Icon(Icons.map_outlined, color: AppColors.primer),
                ),
                title: const Text('Lihat di Google Maps',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Tampilkan titik lokasi di peta'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _bukaMaps(context, destinasi.lokasiUrl);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primerLembut,
                  child: Icon(Icons.directions, color: AppColors.primer),
                ),
                title: const Text('Petunjuk Arah',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Rute dari lokasimu sekarang'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _bukaMaps(context, destinasi.ruteUrl);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tombol bulat putih di atas foto.
class _TombolBulat extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TombolBulat({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kartu,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(width: 44, height: 44, child: Center(child: child)),
      ),
    );
  }
}

/// Kotak kecil berisi ikon, label, dan nilai (rating / jam / tiket).
class _KotakInfo extends StatelessWidget {
  final IconData ikon;
  final Color warnaIkon;
  final String label;
  final String nilai;

  const _KotakInfo({
    required this.ikon,
    required this.label,
    required this.nilai,
    this.warnaIkon = AppColors.primer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kartu,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: warnaIkon, size: 20),
          const SizedBox(height: 6),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.teksSekunder)),
          const SizedBox(height: 2),
          Text(nilai,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Chip kecil nama kategori (dibaca dari data JSON berdasarkan id).
class _ChipKategori extends StatelessWidget {
  final int kategoriId;

  const _ChipKategori({required this.kategoriId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Kategori>(
      future: WisataService().getKategoriById(kategoriId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 28);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primerLembut,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(snapshot.data!.nama,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primer)),
        );
      },
    );
  }
}