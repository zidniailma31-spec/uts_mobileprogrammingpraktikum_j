import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Halaman Profil: identitas pengembang dan informasi aplikasi.
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          const Text('Profil',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),

          // Kartu identitas
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primerLembut,
                  child: Text('Z',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primer)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Zidnia Ilma Arifa',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('240605110126 · Kelas J',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const _BarisInfo(
              ikon: Icons.info_outline,
              judul: 'Tentang Aplikasi',
              isi: 'Jelajah Malang membantu menemukan destinasi wisata '
                  'di Malang Raya: alam, pantai, kuliner, sejarah, dan rekreasi.'),
          const _BarisInfo(
              ikon: Icons.dataset_outlined,
              judul: 'Sumber Data',
              isi: 'Rating, jam buka, dan alamat dari Google Maps '
                  '(Oktober 2026). Harga tiket bersifat perkiraan.'),
          const _BarisInfo(
              ikon: Icons.school_outlined,
              judul: 'Mata Kuliah',
              isi: 'UTS Mobile Programming · Teknik Informatika '
                  'UIN Maulana Malik Ibrahim Malang'),
          const _BarisInfo(
              ikon: Icons.tag, judul: 'Versi', isi: '1.0.0'),
        ],
      ),
    );
  }
}

class _BarisInfo extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String isi;

  const _BarisInfo(
      {required this.ikon, required this.judul, required this.isi});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kartu,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: AppColors.primer),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(isi,
                    style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.teksSekunder)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
