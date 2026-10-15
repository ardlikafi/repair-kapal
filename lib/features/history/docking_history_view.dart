import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../defect_workspace/domain/entities/defect_hotspot.dart';
import '../defect_workspace/domain/entities/vessel.dart';
import '../defect_workspace/presentation/widgets/docking_report_dialog.dart';

/// Model Data Riwayat & Arsip Dok Kapal PELNI
class DockingHistoryItem {
  final String id;
  final int year;
  final String vesselName;
  final String imoNumber;
  final String dockingType; // Annual / Special Docking / Emergency Repair
  final String shipyard;
  final int totalHotspots;
  final String completionDate;
  final String status;
  final String reportDocNumber;

  const DockingHistoryItem({
    required this.id,
    required this.year,
    required this.vesselName,
    required this.imoNumber,
    required this.dockingType,
    required this.shipyard,
    required this.totalHotspots,
    required this.completionDate,
    required this.status,
    required this.reportDocNumber,
  });
}

/// Halaman Riwayat & Arsip Docking PELNI (Enterprise Data Table)
class DockingHistoryView extends StatefulWidget {
  const DockingHistoryView({super.key});

  @override
  State<DockingHistoryView> createState() => _DockingHistoryViewState();
}

class _DockingHistoryViewState extends State<DockingHistoryView> {
  String _searchQuery = '';
  int? _selectedYear;

  // Data Dummy Realistis Sesuai Request
  final List<DockingHistoryItem> _allHistory = const [
    DockingHistoryItem(
      id: 'hist-sinabung-2025',
      year: 2025,
      vesselName: 'KM Sinabung',
      imoNumber: 'IMO 9139622',
      dockingType: 'Special Docking',
      shipyard: 'PT PAL Indonesia (Surabaya)',
      totalHotspots: 32,
      completionDate: '18 Des 2025',
      status: 'SELESAI & DITUTUP',
      reportDocNumber: 'BA-DOCK/PAL-SUB/SNB/2025-12',
    ),
    DockingHistoryItem(
      id: 'hist-kelud-2025',
      year: 2025,
      vesselName: 'KM Kelud',
      imoNumber: 'IMO 8901234',
      dockingType: 'Annual Docking',
      shipyard: 'PT Galangan Surabaya',
      totalHotspots: 18,
      completionDate: '10 Nov 2025',
      status: 'SELESAI & DITUTUP',
      reportDocNumber: 'BA-DOCK/GS-SBY/KLD/2025-11',
    ),
    DockingHistoryItem(
      id: 'hist-labobar-2024',
      year: 2024,
      vesselName: 'KM Labobar',
      imoNumber: 'IMO 9257864',
      dockingType: 'Emergency Repair',
      shipyard: 'PT Dok & Perkapalan Kodja Bahari (Jakarta)',
      totalHotspots: 12,
      completionDate: '24 Agu 2024',
      status: 'SELESAI & DITUTUP',
      reportDocNumber: 'BA-DOCK/KB-JKT/LBR/2024-08',
    ),
    DockingHistoryItem(
      id: 'hist-nusabhakti-2024',
      year: 2024,
      vesselName: 'KMP Nusa Bhakti',
      imoNumber: 'IMO 9128362',
      dockingType: 'Annual Docking',
      shipyard: 'PT Galangan Bahari (Bitung)',
      totalHotspots: 15,
      completionDate: '14 Jun 2024',
      status: 'SELESAI & DITUTUP',
      reportDocNumber: 'BA-DOCK/GB-BTG/NBH/2024-06',
    ),
  ];

  List<DockingHistoryItem> get _filteredHistory {
    return _allHistory.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          item.vesselName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.shipyard.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.dockingType.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesYear = _selectedYear == null || item.year == _selectedYear;
      return matchesQuery && matchesYear;
    }).toList();
  }

  void _openReport(DockingHistoryItem item) {
    // Generate dummy hotspots untuk pratinjau berita acara arsip
    final mockHotspots = [
      DefectHotspot(
        id: 'h1',
        vesselId: item.id,
        vendorId: 'v1',
        pinCode: 'HULL-01',
        deckZone: 'Hull & Bottom Plating',
        normX: 0.3,
        normY: 0.7,
        status: DefectStatus.approved,
        description: 'Blasting Sa 2.5 dan pengecatan ulang antifouling 3 lapis.',
        inspectorNotes: 'Pekerjaan dinyatakan selesai 100% dan lolos uji DFT test.',
      ),
      DefectHotspot(
        id: 'h2',
        vesselId: item.id,
        vendorId: 'v2',
        pinCode: 'ENG-02',
        deckZone: 'Main Engine Room',
        normX: 0.5,
        normY: 0.6,
        status: DefectStatus.approved,
        description: 'Overhaul turbocharger dan penggantian bearing turbin.',
        inspectorNotes: 'Sea trial pengujian getaran mesin normal.',
      ),
    ];

    DockingReportDialog.show(
      context,
      vessel: Vessel(
        id: item.id,
        name: item.vesselName,
        imoNumber: item.imoNumber,
        blueprintUrl:
            'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=1600&auto=format&fit=crop&q=80',
      ),
      hotspots: mockHotspots,
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredHistory;

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
            // ─── Header Halaman Riwayat ───────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: AppColors.pelniNavy,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'RIWAYAT & ARSIP DOCKING ARMADA',
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
                      'Pusat arsip berita acara, riwayat perbaikan fisik kapal, dan sertifikasi laik laut pasca-dok PT PELNI.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Filter Tahun
                _buildYearFilterChips(),
              ],
            ),

            const SizedBox(height: 16),

            // ─── Stat KPI Cards ───────────────────────────────────────────
            _buildSummaryKpis(),

            const SizedBox(height: 20),

            // ─── Search Bar ───────────────────────────────────────────────
            _buildSearchBar(),

            const SizedBox(height: 16),

            // ─── Enterprise Data Table ────────────────────────────────────
            _buildDataTable(list),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryKpis() {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            title: 'TOTAL KAPAL DOK SELESAI',
            value: '${_allHistory.length} Armada',
            subtext: 'Arsip tersimpan aman di cloud',
            icon: Icons.check_circle_rounded,
            color: AppColors.statusApproved,
            bgColor: AppColors.statusApprovedBg,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildKpiCard(
            title: 'RATA-RATA DURASI DOCKING',
            value: '26 Hari',
            subtext: 'Standar efisiensi operasional',
            icon: Icons.timer_outlined,
            color: AppColors.pelniSkyBlue,
            bgColor: AppColors.pelniNavyBg,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildKpiCard(
            title: 'SERTIFIKASI LAIK LAUT (BKI)',
            value: '100% Lulus',
            subtext: 'Biro Klasifikasi Indonesia',
            icon: Icons.verified_rounded,
            color: AppColors.pelniNavy,
            bgColor: AppColors.pelniNavyBg,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required Color bgColor,
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
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1.1,
                  ),
                ),
                Text(
                  subtext,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearFilterChips() {
    final years = [null, 2025, 2024];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: years.map((y) {
        final isSelected = _selectedYear == y;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: InkWell(
            onTap: () => setState(() => _selectedYear = y),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.pelniNavy : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? AppColors.pelniNavy : AppColors.borderColor,
                ),
              ),
              child: Text(
                y == null ? 'Semua Tahun' : '$y',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText:
              'Cari berdasarkan nama kapal (KM Sinabung, KM Kelud), galangan mitra, atau jenis docking...',
          hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          prefixIcon:
              const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<DockingHistoryItem> list) {
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.folder_open_outlined,
                  size: 40, color: AppColors.textMuted),
              SizedBox(height: 10),
              Text(
                'Tidak ada riwayat dok yang cocok dengan pencarian.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Baris Tabel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    'NO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'TAHUN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'NAMA KAPAL / NO. IMO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'JENIS DOK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'GALANGAN MITRA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'TOTAL DEFECT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Text(
                    'TGL SELESAI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Text(
                    'AKSI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pelniNavy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Daftar Baris Data
          ...list.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final item = entry.value;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: idx % 2 == 0 ? const Color(0xFFFBFBFD) : Colors.white,
                border: const Border(
                  bottom: BorderSide(color: AppColors.borderColor, width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      '$idx',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.pelniNavyBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.year}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pelniNavy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.vesselName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pelniNavy,
                          ),
                        ),
                        Text(
                          item.imoNumber,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.dockingType,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.shipyard,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Text(
                          '${item.totalHotspots} Titik',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: Text(
                      item.completionDate,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusApprovedBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.statusApprovedBorder,
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                size: 10, color: AppColors.statusApproved),
                            SizedBox(width: 4),
                            Text(
                              'SELESAI & DITUTUP',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.statusApproved,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _openReport(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          foregroundColor: AppColors.pelniNavy,
                          elevation: 0,
                          side: const BorderSide(
                              color: AppColors.pelniNavy, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                        ),
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 13),
                        label: const Text(
                          'Lihat Berita Acara',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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
}
