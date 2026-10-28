import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mengelola mode tampilan aplikasi (terang / gelap).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  bool get isGelap => state == ThemeMode.dark;

  void ubahMode(bool gelap) {
    emit(gelap ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleMode() {
    emit(isGelap ? ThemeMode.light : ThemeMode.dark);
  }
}
