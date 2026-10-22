import 'package:flutter/services.dart';

/// Membuka Google Maps dari aplikasi lewat MethodChannel ke Android.
class MapsService {
  static const MethodChannel _channel = MethodChannel('jelajah_malang/maps');

  /// Mengembalikan true jika link berhasil dibuka.
  static Future<bool> buka(String url) async {
    try {
      final berhasil =
          await _channel.invokeMethod<bool>('bukaUrl', {'url': url});
      return berhasil ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}