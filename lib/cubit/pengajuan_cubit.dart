import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/pengajuan_model.dart';

class PengajuanCubit extends Cubit<List<Pengajuan>> {
  PengajuanCubit() : super(<Pengajuan>[]);

  // Turunan dari state: jumlah layanan yang sedang diajukan.
  int get totalPengajuan => state.length;

  // Daftar nama layanan yang diajukan.
  List<String> get daftarNamaLayanan =>
      state.map((pengajuan) => pengajuan.namaLayanan).toList();

  void tambahPengajuan(
    String namaLayanan, {
    String namaPemohon = '-',
    String email = '-',
    String sesi = '-',
  }) {
    emit(<Pengajuan>[
      ...state,
      Pengajuan(
        namaLayanan: namaLayanan,
        namaPemohon: namaPemohon,
        email: email,
        sesi: sesi,
      ),
    ]);
  }

  void tandaiSelesai(int index) {
    if (index < 0 || index >= state.length) return;

    final lama = state[index];
    final salinan = List<Pengajuan>.of(state);

    // Buat objek baru (bukan mengubah objek lama) supaya state
    // dianggap berubah dan BlocBuilder ikut dibangun ulang.
    salinan[index] = Pengajuan(
      namaLayanan: lama.namaLayanan,
      namaPemohon: lama.namaPemohon,
      email: lama.email,
      sesi: lama.sesi,
      status: 'Selesai',
    );

    emit(salinan);
  }

  void hapusPengajuan(String namaLayanan) {
    emit(state.where((p) => p.namaLayanan != namaLayanan).toList());
  }

  void kosongkanPengajuan() {
    emit(<Pengajuan>[]);
  }
}