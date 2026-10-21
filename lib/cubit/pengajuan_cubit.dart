
import 'package:flutter_bloc/flutter_bloc.dart';

class PengajuanCubit extends Cubit<List<String>> {
  PengajuanCubit() : super(<String>[]);

  // Jumlah layanan di keranjang pengajuan.
  int get totalPengajuan => state.length;

  // Menambahkan layanan ke keranjang.
  // Layanan yang sama tidak ditambahkan dua kali.
  void tambahPengajuan(String namaLayanan) {
    if (state.contains(namaLayanan)) return;

    emit([...state, namaLayanan]);
  }

  // Menghapus layanan tertentu dari keranjang.
  void hapusPengajuan(String namaLayanan) {
    emit(
      state.where((nama) => nama != namaLayanan).toList(),
    );
  }

  // Mengirim seluruh layanan dalam keranjang.
  // Untuk saat ini, pengiriman disimulasikan dengan
  // mengosongkan keranjang setelah proses selesai.
  void kirimSemuaPengajuan() {
    if (state.isEmpty) return;

    emit(<String>[]);
  }

  // Mengosongkan keranjang.
  void kosongkanPengajuan() {
    emit(<String>[]);
  }
}
