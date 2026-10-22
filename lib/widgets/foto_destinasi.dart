import 'package:flutter/material.dart';

import '../model/destinasi.dart';
import '../service/foto_service.dart';
import '../theme/app_theme.dart';

/// Menampilkan foto destinasi dengan urutan:
/// 1. Jika "gambar" di JSON berisi link http -> pakai link itu.
/// 2. Jika file di folder assets ada -> pakai file itu.
/// 3. Jika tidak ada -> cari otomatis di internet berdasarkan nama tempat.
/// 4. Jika tetap tidak ketemu -> kotak berwarna + ikon kategori.
class FotoDestinasi extends StatelessWidget {
  final Destinasi destinasi;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const FotoDestinasi({
    super.key,
    required this.destinasi,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    final gambar = destinasi.gambar;

    return ClipRRect(
      borderRadius: borderRadius,
      child: gambar.startsWith('http')
          ? _FotoInternet(
              url: gambar,
              destinasi: destinasi,
              width: width,
              height: height,
            )
          : Image.asset(
              gambar,
              width: width,
              height: height,
              fit: BoxFit.cover,
              // File assets tidak ada -> cari otomatis di internet
              errorBuilder: (context, error, stackTrace) => _FotoOtomatis(
                destinasi: destinasi,
                width: width,
                height: height,
              ),
            ),
    );
  }
}

/// Mencari link foto berdasarkan nama destinasi, lalu menampilkannya.
/// Dibuat StatefulWidget agar pencarian hanya dijalankan sekali per kartu.
class _FotoOtomatis extends StatefulWidget {
  final Destinasi destinasi;
  final double? width;
  final double? height;

  const _FotoOtomatis({required this.destinasi, this.width, this.height});

  @override
  State<_FotoOtomatis> createState() => _FotoOtomatisState();
}

class _FotoOtomatisState extends State<_FotoOtomatis> {
  late final Future<String?> _futureUrl;

  @override
  void initState() {
    super.initState();
    _futureUrl = FotoService.cariFoto(widget.destinasi.nama);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _futureUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _Placeholder(
              destinasi: widget.destinasi,
              width: widget.width,
              height: widget.height,
              loading: true);
        }
        final url = snapshot.data;
        if (url == null) {
          return _Placeholder(
              destinasi: widget.destinasi,
              width: widget.width,
              height: widget.height);
        }
        return _FotoInternet(
          url: url,
          destinasi: widget.destinasi,
          width: widget.width,
          height: widget.height,
        );
      },
    );
  }
}

/// Menampilkan foto dari link internet.
class _FotoInternet extends StatelessWidget {
  final String url;
  final Destinasi destinasi;
  final double? width;
  final double? height;

  const _FotoInternet({
    required this.url,
    required this.destinasi,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      // Identitas aplikasi, agar server foto tidak menolak permintaan.
      headers: const {'User-Agent': FotoService.userAgent},
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _Placeholder(
            destinasi: destinasi, width: width, height: height, loading: true);
      },
      errorBuilder: (context, error, stackTrace) =>
          _Placeholder(destinasi: destinasi, width: width, height: height),
    );
  }
}

/// Kotak berwarna + ikon kategori (saat foto dimuat atau tidak ditemukan).
class _Placeholder extends StatelessWidget {
  final Destinasi destinasi;
  final double? width;
  final double? height;
  final bool loading;

  const _Placeholder({
    required this.destinasi,
    this.width,
    this.height,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.warnaKategori(destinasi.kategoriId),
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : Icon(
              AppColors.ikonKategori(destinasi.kategoriId),
              color: Colors.white.withValues(alpha: 0.85),
              size: 36,
            ),
    );
  }
}