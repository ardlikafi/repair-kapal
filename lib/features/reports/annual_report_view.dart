import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';

/// Halaman Laporan Tahunan Eksekutif (Executive Annual Report)
/// Dirancang khusus untuk kebutuhan analisis manajemen & GM Armada (Pak Rian)
class AnnualReportView extends StatefulWidget {
  const AnnualReportView({super.key});

  @override
  State<AnnualReportView> createState() => _AnnualReportViewState();
}

class _AnnualReportViewState extends State<AnnualReportView> {
  int _selectedYear = 2026;

  void _exportAnnualReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.pelniNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: const Row(
          children: [
            Icon(Icons.download_done_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Laporan Tahunan Docking PELNI 2026 berhasil diekspor (Format PDF Executive Summary).',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvasBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space24,
          vertical: AppDimens.space20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Laporan Tahunan ───────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.pelniOrange,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'LAPORAN TAHUNAN & ANALITIK DOCKING',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.pelniNavy,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Executive Summary Kinerja Dok Armada, Realisasi Anggaran & Evaluasi Mutu Galangan Mitra.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Filter Tahun & Tombol Ekspor
                _buildYearDropdown(),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _exportAnnualReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pelniNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                  ),
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text(
                    'Ekspor Laporan (PDF)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ─── Kartu KPI Finansial & Operasional ─────────────────────────
            _buildExecutiveKpiCards(),

            const SizedBox(height: 20),

            // ─── Row 2: Distribusi Kompartemen & Evaluasi Galangan ─────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Distribusi Kompartemen Kerusakan
                Expanded(
                  flex: 3,
                  child: _buildCompartmentDistributionCard(),
                ),
                const SizedBox(width: 16),
                // Evaluasi Kinerja Mitra Galangan
                Expanded(
                  flex: 4,
                  child: _buildShipyardEvaluationCard(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ─── Catatan Rekomendasi Khusus Manajemen ────────────────────
            _buildManagementNotesCard(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedYear,
          borderRadius: BorderRadius.circular(6),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.pelniNavy,
          ),
          onChanged: (y) {
            if (y != null) setState(() => _selectedYear = y);
          },
          items: const [
            DropdownMenuItem(value: 2026, child: Text('Tahun Anggaran 2026')),
            DropdownMenuItem(value: 2025, child: Text('Tahun Anggaran 2025')),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutiveKpiCards() {
    return Row(
      children: [
        Expanded(
          child: _buildKpiBox(
            title: 'REALISASI ANGGARAN DOK',
            value: 'Rp 42,8 M',
            trend: 'Efisiensi +8.4%',
            isPositive: true,
            caption: 'Pagu anggaran Rp 46,7 M',
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.pelniNavy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiBox(
            title: 'RATA-RATA OFF-HIRE TIME',
            value: '24,2 Hari',
            trend: '-3,8 Hari Lebih Cepat',
            isPositive: true,
            caption: 'Target SLA dok: 28 hari',
            icon: Icons.speed_rounded,
            color: AppColors.statusApproved,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiBox(
            title: 'TINGKAT DEFECT DITUTUP',
            value: '94,8%',
            trend: 'Target BKI 100%',
            isPositive: true,
            caption: '62 dari 66 hotspot terselesaikan',
            icon: Icons.task_alt_rounded,
            color: AppColors.pelniSkyBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiBox(
            title: 'SERTIFIKASI LAIK LAUT',
            value: '100% Valid',
            trend: 'Nol Insiden Pasca-Dok',
            isPositive: true,
            caption: 'Pengawasan BKI & Perhubungan',
            icon: Icons.verified_user_outlined,
            color: AppColors.pelniOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiBox({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required String caption,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: AppColors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.statusApproved,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  caption,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompartmentDistributionCard() {
    final distributions = [
      {'name': 'Lambung Kapal (Hull & Underwater Plating)', 'percent': 0.42, 'hotspots': '28 Titik'},
      {'name': 'Kamar Mesin & Pemipaan (Engine & Piping)', 'percent': 0.31, 'hotspots': '20 Titik'},
      {'name': 'Geladak Muat & Pintu Kedap (Deck / Outfitting)', 'percent': 0.19, 'hotspots': '13 Titik'},
      {'name': 'Anjungan & Elektrikal (Bridge & Electrical)', 'percent': 0.08, 'hotspots': '5 Titik'},
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pie_chart_outline_rounded,
                  size: 16, color: AppColors.pelniNavy),
              SizedBox(width: 8),
              Text(
                'DISTRIBUSI TEMUAN PER KOMPARTEMEN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pelniNavy,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Analisis konsentrasi pekerjaan perbaikan berdasarkan area kapal.',
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          ...distributions.map((d) {
            final double p = d['percent'] as double;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        d['name'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${(p * 100).toInt()}% (${d['hotspots']})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pelniNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: p,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        p > 0.35
                            ? AppColors.pelniNavy
                            : (p > 0.20
                                ? AppColors.pelniSkyBlue
                                : AppColors.pelniOrange),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildShipyardEvaluationCard() {
    final shipyards = [
      {
        'name': 'PT Galangan Bahari (Bitung)',
        'vessels': 'KMP Nusa Bhakti',
        'score': '92 / 100',
        'sla': 'Tepat Waktu (+2 Hari Cepat)',
        'bki': 'Lolos 100%',
      },
      {
        'name': 'PT PAL Indonesia (Surabaya)',
        'vessels': 'KM Sinabung',
        'score': '95 / 100',
        'sla': 'Sesuai Jadwal (On-Time)',
        'bki': 'Lolos 100%',
      },
      {
        'name': 'PT Galangan Dok Surabaya',
        'vessels': 'KM Kelud',
        'score': '88 / 100',
        'sla': 'Sesuai Jadwal (On-Time)',
        'bki': 'Lolos 100%',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_outlined,
                  size: 16, color: AppColors.pelniNavy),
              SizedBox(width: 8),
              Text(
                'MATRIKS EVALUASI KINERJA GALANGAN MITRA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pelniNavy,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Skor mutu pengerjaan fisik, kepatuhan K3 maritim, dan ketepatan jadwal.',
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          ...shipyards.map((s) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.pelniNavyBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFD3F5)),
                    ),
                    child: const Icon(Icons.corporate_fare_rounded,
                        size: 20, color: AppColors.pelniNavy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s['name']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pelniNavy,
                          ),
                        ),
                        Text(
                          'Armada: ${s['vessels']} • ${s['sla']}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.statusApprovedBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppColors.statusApprovedBorder),
                        ),
                        child: Text(
                          s['score']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.statusApproved,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Grade A (Sangat Baik)',
                        style: TextStyle(
                            fontSize: 9, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildManagementNotesCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.pelniNavyBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFBFD3F5)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              size: 20, color: AppColors.pelniNavy),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CATATAN STRATEGIS SUPERINTENDENT GM PELNI (UNTUK PAK RIAN)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pelniNavy,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '1. Konsentrasi korosi lambung kapal (Hull) menyerap 42% total anggaran. Direkomendasikan penerapan spesifikasi cat antifouling nano-epoxy generasi baru pada siklus docking 2027 untuk memperpanjang usia plat bawah air.\n'
                  '2. Standar SLA galangan mitra terpelihara sangat baik (rata-rata 24,2 hari vs target 28 hari), menghemat potensi biaya sandar dermaga sebesar Rp 380 juta.\n'
                  '3. Integrasi sistem pemantauan berbasis digital (PDMS) memangkas waktu verifikasi berita acara perbaikan dari 4 hari menjadi 15 menit secara realtime.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
