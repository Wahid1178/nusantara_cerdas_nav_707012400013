import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/favorit_cubit.dart';
import 'cubit/pengajuan_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    // Berada DI ATAS MaterialApp sehingga seluruh route (termasuk route
    // bernama yang di-push) dan layout sempit/lebar bisa menemukan Cubit.
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoritCubit()),
        BlocProvider(create: (_) => PengajuanCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const NusantaraCerdasApp(),
    ),
  );
}

class NusantaraCerdasApp extends StatelessWidget {
  const NusantaraCerdasApp({super.key});

  static ThemeData _bentukTema(Brightness brightness) {
    final bool gelap = brightness == Brightness.dark;
    final ColorScheme skema = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: skema,
      appBarTheme: AppBarTheme(
        backgroundColor: gelap ? skema.surfaceContainer : Colors.blue,
        foregroundColor: gelap ? skema.onSurface : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hanya MaterialApp yang dibangun ulang saat mode berubah.
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nusantara Cerdas',
          initialRoute: AppRoutes.beranda,
          routes: AppRoutes.daftarRoute(),
          onGenerateRoute: AppRoutes.bentukRoute,
          onUnknownRoute: AppRoutes.routeTidakDikenal,
          theme: _bentukTema(Brightness.light),
          darkTheme: _bentukTema(Brightness.dark),
          themeMode: themeMode,
        );
      },
    );
  }
}
