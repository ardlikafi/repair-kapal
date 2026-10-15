import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/defect_hotspot.dart';
import '../../domain/entities/vessel.dart';

/// Modal Laporan Berita Acara Docking Resmi & Ekspor PDF PELNI (Executive Report)
class DockingReportDialog extends StatelessWidget {
  final Vessel vessel;
  final List<DefectHotspot> hotspots;

  const DockingReportDialog({
    super.key,
    required this.vessel,
    required this.hotspots,
  });

  static Future<void> show(
    BuildContext context, {
    required Vessel vessel,
    required List<DefectHotspot> hotspots,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => DockingReportDialog(
        vessel: vessel,
        hotspots: hotspots,
      ),
    );
  }

  void _handlePrint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.pelniNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Laporan Berita Acara Dok "${vessel.name}" berhasil diekspor ke PDF resmi.',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 880, maxHeight: 760),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // ─── Header Dialog (Toolbar Preview) ─────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLight,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.print_outlined,
                      size: 18, color: AppColors.pelniNavy),
                  const SizedBox(width: 8),
                  const Text(
                    'Pratinjau Dokumen Berita Acara & Laporan Docking Resmi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 18,
                    tooltip: 'Tutup',
                  ),
                ],
              ),
            ),

            // ─── Area Dokumen Cetak (Printable Sheet A4 Style) ────────────
            Expanded(
              child: Container(
                color: AppColors.canvasBg,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Kop Surat Resmi PELNI ───────────────────────
                        _buildKopSurat(),

                        const SizedBox(height: 18),

                        // ─── Detail Proyek Docking ────────────────────────
                        _buildProjectDetails(),

                        const SizedBox(height: 20),

                        // ─── Tabel Rekap Pekerjaan ────────────────────────
                        _buildWorkSummaryTable(),

                        const SizedBox(height: 28),

                        // ─── Area Tanda Tangan Digital ────────────────────
                        _buildSignatures(),

                        const SizedBox(height: 20),

                        // Catatan Kaki Legal
                        Center(
                          child: Text(
                            'Dokumen ini diterbitkan secara elektronik oleh Sistem Monitoring Docking Terintegrasi PT PELNI (Persero).\nSah dan diakui sebagai dokumen resmi administrasi teknik armada perkapalan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textMuted.withValues(alpha: 0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Action Footer ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLight,
                border: Border(
                  top: BorderSide(color: AppColors.borderColor, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Tutup',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _handlePrint(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pelniNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 11),
                    ),
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text(
                      'Download PDF / Print',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Kop Surat Resmi PELNI ──────────────────────────────────────────────────
  Widget _buildKopSurat() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pelni_logo.png',
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text(
                'PELNI',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.pelniNavy,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PT PELAYARAN NASIONAL INDONESIA (PERSERO)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.pelniNavy,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    'DIREKTORAT ARMADA & TEKNIK — DIVISI DOCKING & PEMELIHARAAN KAPAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Text(
                    'Jl. Gajah Mada No. 14, Jakarta Pusat 10130 • www.pelni.co.id',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.pelniNavy, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'BERITA ACARA RESMI',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                  Text(
                    'NO: BA-DOCK/PELNI/2026/04',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Garis Pembatas Kop Surat (Ganda)
        Container(height: 2.5, color: AppColors.pelniNavy),
        const SizedBox(height: 1.5),
        Container(height: 0.8, color: AppColors.pelniNavy),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'REKAPITULASI PROGRES INSPEKSI DEFECT & PENYELESAIAN DOCKING',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.pelniNavy,
              letterSpacing: 0.5,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Detail Proyek Docking ──────────────────────────────────────────────────
  Widget _buildProjectDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Nama Kapal', vessel.name),
                _buildInfoRow('Nomor IMO', vessel.imoNumber),
                _buildInfoRow('Tipe Armada', 'Ro-Ro Passenger Ferry'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Galangan Mitra', 'Galangan Dok Bitung (PT Galangan Bahari)'),
                _buildInfoRow('Periode Docking', 'Tahunan (Annual Survey) 2026'),
                _buildInfoRow('Status Pelaksanaan', 'Sedang Docking (45% Selesai)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.pelniNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tabel Rekap Pekerjaan ──────────────────────────────────────────────────
  Widget _buildWorkSummaryTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A. DAFTAR TITIK TEMUAN & REKAP STATUS PEKERJAAN',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.pelniNavy,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: AppColors.borderColor, width: 1),
          columnWidths: const {
            0: FixedColumnWidth(36),
            1: FixedColumnWidth(95),
            2: FixedColumnWidth(140),
            3: FixedColumnWidth(125),
            4: FixedColumnWidth(100),
            5: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Tabel
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
              children: [
                _buildTableHeaderCell('NO'),
                _buildTableHeaderCell('KODE TAG'),
                _buildTableHeaderCell('ZONA DEK'),
                _buildTableHeaderCell('MITRA VENDOR'),
                _buildTableHeaderCell('STATUS'),
                _buildTableHeaderCell('VERIFIKASI SUPERINTENDENT'),
              ],
            ),
            // Baris Data Hotspots
            ...hotspots.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final h = entry.value;

              return TableRow(
                decoration: BoxDecoration(
                  color: idx % 2 == 0 ? const Color(0xFFFBFBFB) : Colors.white,
                ),
                children: [
                  _buildTableCell('$idx', align: TextAlign.center, isBold: true),
                  _buildTableCell(h.pinCode, isBold: true, color: AppColors.pelniNavy),
                  _buildTableCell(h.deckZone),
                  _buildTableCell(h.vendor?.companyName ?? 'PT Galangan Bahari'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: h.status.badgeBgColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: h.status.borderColor, width: 1),
                      ),
                      child: Text(
                        h.status.displayLabel,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: h.status.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  _buildTableCell(
                    h.inspectorNotes ?? h.description,
                    fontSize: 9,
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.pelniNavy,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    TextAlign align = TextAlign.left,
    bool isBold = false,
    Color? color,
    double fontSize = 9.5,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          color: color ?? AppColors.textPrimary,
        ),
      ),
    );
  }

  // ─── Area Tanda Tangan Digital ──────────────────────────────────────────────
  Widget _buildSignatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'B. PENGESAHAN DAN VERIFIKASI DOKUMEN',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.pelniNavy,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pihak Mitra Galangan
            _buildSignatureBox(
              partyTitle: 'Pihak Mitra Galangan Pelaksana',
              companyName: 'PT GALANGAN BAHARI',
              signerName: 'Ir. Bambang Trihatmojo, ST.',
              signerTitle: 'Kepala Proyek Galangan Dok',
              badgeLabel: 'VERIFIKASI TEKNIK DOK',
              badgeColor: AppColors.pelniSkyBlue,
            ),
            // Pihak PELNI
            _buildSignatureBox(
              partyTitle: 'Pihak Pemilik Kapal (Owner)',
              companyName: 'PT PELNI (PERSERO)',
              signerName: 'Capt. Hendra Gunawan, M.Mar.',
              signerTitle: 'Superintendent GM Divisi Docking PELNI',
              badgeLabel: 'DISETUJUI & DISAHKAN',
              badgeColor: AppColors.statusApproved,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignatureBox({
    required String partyTitle,
    required String companyName,
    required String signerName,
    required String signerTitle,
    required String badgeLabel,
    required Color badgeColor,
  }) {
    return Container(
      width: 370,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            partyTitle,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
          Text(
            companyName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.pelniNavy,
            ),
          ),
          const SizedBox(height: 8),

          // Stempel Verifikasi Digital
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: badgeColor, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined, size: 13, color: badgeColor),
                const SizedBox(width: 5),
                Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Garis Tanda Tangan & Nama Terang
          Text(
            signerName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              decoration: TextDecoration.underline,
            ),
          ),
          Text(
            signerTitle,
            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
