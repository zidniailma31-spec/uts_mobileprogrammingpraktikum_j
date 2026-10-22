import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'view/main_page.dart';

void main() {
  runApp(const JelajahMalangApp());
}

/// Widget paling atas aplikasi: mengatur judul, tema, dan halaman awal.
class JelajahMalangApp extends StatelessWidget {
  const JelajahMalangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jelajah Malang',
      debugShowCheckedModeBanner: false,
      theme: buatTema(),
      home: const MainPage(),
    );
  }
}
