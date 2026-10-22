import 'package:flutter/material.dart';

import '../model/destinasi.dart';
import '../service/favorit_service.dart';
import '../service/wisata_service.dart';
import '../theme/app_theme.dart';
import '../widgets/kartu_destinasi.dart';
import 'detail_page.dart';

/// Halaman Favorit: menampilkan destinasi yang ditandai hati di halaman Detail.
class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Destinasi>>(
        future: WisataService().getDestinasi(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final semua = snapshot.data!;

          // Ikut diperbarui otomatis setiap favorit berubah.
          return ValueListenableBuilder<Set<int>>(
            valueListenable: FavoritService.favorit,
            builder: (context, favorit, _) {
              final daftar =
                  semua.where((d) => favorit.contains(d.id)).toList();

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  const Text('Favorit Saya',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('${daftar.length} destinasi disimpan',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.teksSekunder)),
                  const SizedBox(height: 20),
                  if (daftar.isEmpty) const _Kosong(),
                  ...daftar.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: KartuDestinasi(
                          destinasi: d,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailPage(destinasi: d)),
                          ),
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Tampilan saat belum ada favorit.
class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.favorite_border, size: 56, color: AppColors.garis),
          SizedBox(height: 12),
          Text('Belum ada favorit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          SizedBox(height: 4),
          Text(
            'Tekan ikon hati di halaman detail\nuntuk menyimpan destinasi.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.teksSekunder),
          ),
        ],
      ),
    );
  }
}
