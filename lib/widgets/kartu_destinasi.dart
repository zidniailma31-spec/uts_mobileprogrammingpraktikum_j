import 'package:flutter/material.dart';

import '../model/destinasi.dart';
import '../theme/app_theme.dart';
import 'foto_destinasi.dart';

/// Label rating: ikon bintang + angka, contoh "★ 4.7".
class RatingLabel extends StatelessWidget {
  final double rating;
  final double size;

  const RatingLabel({super.key, required this.rating, this.size = 13});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.aksen, size: size + 3),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// Kartu besar untuk bagian "Destinasi Populer" (digeser ke samping).
class KartuPopuler extends StatelessWidget {
  final Destinasi destinasi;
  final VoidCallback onTap;

  const KartuPopuler({super.key, required this.destinasi, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Material(
        color: AppColors.kartu,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FotoDestinasi(
                  destinasi: destinasi,
                  height: 140,
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              destinasi.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                          RatingLabel(rating: destinasi.rating, size: 12),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _BarisLokasi(lokasi: destinasi.lokasi),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu memanjang untuk daftar (Rekomendasi, Kategori, Favorit).
class KartuDestinasi extends StatelessWidget {
  final Destinasi destinasi;
  final VoidCallback onTap;

  const KartuDestinasi(
      {super.key, required this.destinasi, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kartu,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              FotoDestinasi(destinasi: destinasi, width: 84, height: 84),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destinasi.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    _BarisLokasi(lokasi: destinasi.lokasi),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingLabel(rating: destinasi.rating, size: 12),
                        const Spacer(),
                        Text(
                          destinasi.hargaLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primer,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Baris kecil berisi ikon pin dan nama lokasi.
class _BarisLokasi extends StatelessWidget {
  final String lokasi;

  const _BarisLokasi({required this.lokasi});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined,
            size: 14, color: AppColors.teksSekunder),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            lokasi,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.teksSekunder),
          ),
        ),
      ],
    );
  }
}
