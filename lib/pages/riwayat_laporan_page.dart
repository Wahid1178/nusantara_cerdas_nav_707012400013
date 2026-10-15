
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pengajuan_model.dart';

class RiwayatLaporanPage extends StatefulWidget {
  const RiwayatLaporanPage({super.key});

  @override
  State<RiwayatLaporanPage> createState() =>
      _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  String _filterStatus = 'Semua';

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Diproses':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _tampilkanDetail(BuildContext context, Pengajuan pengajuan) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Detail Pengajuan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detail('Nama Layanan', pengajuan.namaLayanan),
              _detail('Nama Pemohon', pengajuan.namaPemohon),
              _detail('Email', pengajuan.email),
              _detail('Sesi Pelayanan', pengajuan.sesi),
              _detail('Status', pengajuan.status),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _detail(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isi,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final semuaPengajuan = model.daftarPengajuanDetail;

    // Filter berdasarkan status yang dipilih.
    final pengajuanTampil = semuaPengajuan.asMap().entries.where((entry) {
      if (_filterStatus == 'Semua') return true;
      return entry.value.status == _filterStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Riwayat Pengajuan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Daftar pengajuan layanan yang pernah Anda kirimkan.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                if (pengajuanTampil.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 45),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 65,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _filterStatus == 'Semua'
                              ? 'Belum ada pengajuan layanan.'
                              : 'Belum ada pengajuan berstatus $_filterStatus.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pengajuan dari form akan muncul di sini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  ...pengajuanTampil.map((entry) {
                    final index = entry.key;
                    final pengajuan = entry.value;
                    final warna = _warnaStatus(pengajuan.status);

                    return GestureDetector(
                      onTap: () {
                        _tampilkanDetail(context, pengajuan);
                      },
                      onLongPress: () {
                        if (pengajuan.status == 'Selesai') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pengajuan ini sudah selesai.',
                              ),
                            ),
                          );
                          return;
                        }

                        model.tandaiSelesai(index);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pengajuan berhasil ditandai selesai.',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: warna.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.miscellaneous_services,
                                  color: warna,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pengajuan.namaLayanan,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Pemohon: ${pengajuan.namaPemohon}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Email: ${pengajuan.email}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sesi: ${pengajuan.sesi}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: warna.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        pengajuan.status,
                                        style: TextStyle(
                                          color: warna,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Ketuk untuk detail • Tekan lama untuk menyelesaikan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Buka halaman layanan untuk membuat pengajuan baru.',
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() => _filterStatus = 'Semua');
                },
                icon: Icon(
                  Icons.list,
                  color: _filterStatus == 'Semua'
                      ? Colors.blue
                      : Colors.grey,
                ),
                tooltip: 'Semua Pengajuan',
              ),
              IconButton(
                onPressed: () {
                  setState(() => _filterStatus = 'Menunggu');
                },
                icon: Icon(
                  Icons.pending_actions,
                  color: _filterStatus == 'Menunggu'
                      ? Colors.blue
                      : Colors.grey,
                ),
                tooltip: 'Menunggu',
              ),
              const SizedBox(width: 45),
              IconButton(
                onPressed: () {
                  setState(() => _filterStatus = 'Selesai');
                },
                icon: Icon(
                  Icons.check_circle_outline,
                  color: _filterStatus == 'Selesai'
                      ? Colors.blue
                      : Colors.grey,
                ),
                tooltip: 'Selesai',
              ),
              IconButton(
                onPressed: () {
                  setState(() => _filterStatus = 'Semua');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Daftar pengajuan diperbarui.'),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
