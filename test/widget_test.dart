import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:modul2/main.dart';
import 'package:modul2/models/favorit_model.dart';
import 'package:modul2/models/pengajuan_model.dart';

void main() {
  testWidgets('Aplikasi menampilkan halaman Beranda', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FavoritModel()),
          ChangeNotifierProvider(create: (context) => PengajuanModel()),
        ],
        child: const NusantaraCerdasApp(),
      ),
    );

    expect(find.text('Selamat Datang di'), findsOneWidget);
  });
}