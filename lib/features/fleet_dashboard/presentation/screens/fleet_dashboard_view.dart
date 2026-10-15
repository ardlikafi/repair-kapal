import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../defect_workspace/presentation/controllers/workspace_controller.dart';
import '../../../defect_workspace/presentation/screens/workspace_view.dart';

/// Data Model Ringkas untuk Katalog Armada Kapal PELNI
class VesselFleetItem {
  final String id;
  final String name;
  final String imoNumber;
  final String vesselType;
  final String shipyard;
  final double progress; // 0.0 - 1.0
  final String statusLabel;
  final Color statusBgColor;
  final Color statusTextColor;
  final Color statusBorderColor;
  final int totalDefects;
  final int inProgressDefects;
  final int waitingDefects;
  final String callSign;

  const VesselFleetItem({
    required this.id,
    required this.name,
    required this.imoNumber,
    required this.vesselType,
    required this.shipyard,
    required this.progress,
    required this.statusLabel,
    required this.statusBgColor,
    required this.statusTextColor,
    required this.statusBorderColor,
    required this.totalDefects,
    required this.inProgressDefects,
    required this.waitingDefects,
    required this.callSign,
  });
}

/// Dashboard Utama: Sistem Manajemen Armada & Docking PT PELNI
class FleetDashboardView extends StatefulWidget {
  final WorkspaceController controller;
  final void Function(int)? onSwitchTab;

  const FleetDashboardView({
    super.key,
    required this.controller,
    this.onSwitchTab,
  });

  @override
  State<FleetDashboardView> createState() => _FleetDashboardViewState();
}

class _FleetDashboardViewState extends State<FleetDashboardView> {
  // Role switcher: Superintendent PELNI vs Mitra Vendor
  String _selectedRole = 'Superintendent PELNI';

  final List<String> _roleOptions = [
    'Superintendent PELNI',
    'Mitra Vendor: PT Galangan Bahari',
  ];

  // Data 3 Armada Realistis PT PELNI
  final List<VesselFleetItem> _vessels = const [
    VesselFleetItem(
      id: 'e5a1b32d-8f90-4c3e-9012-78d10b710001',
      name: 'KMP Nusa Bhakti',
      imoNumber: 'IMO 9123456',
      vesselType: 'Ro-Ro Ferry',
      shipyard: 'Galangan Dok Bitung',
      progress: 0.45,
      statusLabel: 'Sedang Docking',
      statusBgColor: AppColors.statusInProgressBg,
      statusTextColor: AppColors.statusInProgress,
      statusBorderColor: AppColors.statusInProgressBorder,
      totalDefects: 4,
      inProgressDefects: 2,
      waitingDefects: 1,
      callSign: 'YBBD',
    ),
    VesselFleetItem(
      id: 'vessel-kelud-surabaya-002',
      name: 'KM Kelud',
      imoNumber: 'IMO 8901234',
      vesselType: 'Kapal Penumpang',
      shipyard: 'Galangan Dok Surabaya',
      progress: 0.25,
      statusLabel: 'Sedang Docking',
      statusBgColor: AppColors.statusInProgressBg,
      statusTextColor: AppColors.statusInProgress,
      statusBorderColor: AppColors.statusInProgressBorder,
      totalDefects: 8,
      inProgressDefects: 5,
      waitingDefects: 2,
      callSign: 'YFPA',
    ),
    VesselFleetItem(
      id: 'vessel-sinabung-jakarta-003',
      name: 'KM Sinabung',
      imoNumber: 'IMO 7789012',
      vesselType: 'Kapal Penumpang',
      shipyard: 'Galangan Dok Jakarta',
      progress: 0.90,
      statusLabel: 'Finishing',
      statusBgColor: AppColors.statusApprovedBg,
      statusTextColor: AppColors.statusApproved,
      statusBorderColor: AppColors.statusApprovedBorder,
      totalDefects: 2,
      inProgressDefects: 1,
      waitingDefects: 0,
      callSign: 'YERB',
    ),
  ];

  void _navigateToWorkspace(VesselFleetItem vessel) {
    if (widget.onSwitchTab != null) {
      widget.onSwitchTab!(1);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkspaceView(
            controller: widget.controller,
            onBack: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasBg,
      body: Column(
        children: [
          // ─── Top Bar Korporat PELNI ─────────────────────────────────────
          _buildTopBar(),

          // ─── Area Konten Dashboard (Scrollable) ─────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space24,
                vertical: AppDimens.space20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Executive Summary Title ───────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.pelniNavy,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'RINGKASAN EKSEKUTIF DOCKING',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pelniNavy,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.borderColor, width: 1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 12, color: AppColors.textSecondary),
                            SizedBox(width: 6),
                            Text(
                              'Tahun Anggaran 2026',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space12),

                  // ─── 4 Kartu Metrik Eksekutif ──────────────────────────
                  _buildExecutiveMetrics(),

                  const SizedBox(height: AppDimens.space24),

                  // ─── Header Katalog Armada ─────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.pelniSkyBlue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'KATALOG ARMADA DOCKING AKTIF',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pelniNavy,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.pelniNavyBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: const Color(0xFFBFD3F5), width: 1),
                        ),
                        child: const Text(
                          '3 Unit Terpantau',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pelniNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pilih armada untuk membuka lembar kerja denah kapal, inspeksi visual titik defect, dan persetujuan perbaikan.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppDimens.space16),

                  // ─── Grid Kartu Armada ─────────────────────────────────
                  _buildFleetGrid(),

                  const SizedBox(height: AppDimens.space32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Top Bar Korporat ───────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      height: 68 + MediaQuery.paddingOf(context).top,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
        left: AppDimens.space20,
        right: AppDimens.space20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo Resmi PELNI
          Image.asset(
            'assets/images/pelni_logo.png',
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Text(
              'PELNI',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.pelniNavy,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Divider Vertikal
          Container(
            width: 1,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: AppColors.borderColor,
          ),

          // Judul Aplikasi Korporat
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sistem Monitoring Docking Terintegrasi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pelniNavy,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'PT PELAYARAN NASIONAL INDONESIA (PERSERO) • DIVISI DOCKING & ARMADA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted.withValues(alpha: 0.9),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ─── Role Switcher ────────────────────────────────────────────────
          _buildRoleSwitcher(),
        ],
      ),
    );
  }

  // ─── Role Switcher (Dropdown / Selector) ───────────────────────────────────
  Widget _buildRoleSwitcher() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          icon: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(
              Icons.unfold_more_rounded,
              size: 16,
              color: AppColors.pelniNavy,
            ),
          ),
          dropdownColor: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.pelniNavy,
          ),
          onChanged: (String? newRole) {
            if (newRole != null) {
              setState(() => _selectedRole = newRole);
            }
          },
          items: _roleOptions.map((role) {
            final isPelni = role.contains('PELNI');
            return DropdownMenuItem<String>(
              value: role,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPelni
                        ? Icons.shield_outlined
                        : Icons.handyman_outlined,
                    size: 14,
                    color: isPelni
                        ? AppColors.pelniNavy
                        : AppColors.pelniSkyBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isPelni
                          ? AppColors.pelniNavy
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── 4 Kartu Metrik Eksekutif ──────────────────────────────────────────────
  Widget _buildExecutiveMetrics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final cardWidth = isNarrow
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        final metrics = [
          _ExecutiveMetricData(
            title: 'TOTAL KAPAL DOCKING',
            value: '3',
            unit: 'Armada',
            subtitle: 'Aktif di galangan mitra',
            icon: Icons.directions_boat_filled_rounded,
            accentColor: AppColors.pelniNavy,
            bgColor: AppColors.pelniNavyBg,
            borderColor: const Color(0xFFBFD3F5),
          ),
          _ExecutiveMetricData(
            title: 'PROYEK BERJALAN',
            value: '2',
            unit: 'Kapal',
            subtitle: 'Tahap pengerjaan fisik',
            icon: Icons.engineering_rounded,
            accentColor: AppColors.statusInProgress,
            bgColor: AppColors.statusInProgressBg,
            borderColor: AppColors.statusInProgressBorder,
          ),
          _ExecutiveMetricData(
            title: 'MENUNGGU VERIFIKASI GM',
            value: '1',
            unit: 'Titik',
            subtitle: 'Butuh approval inspeksi',
            icon: Icons.assignment_late_rounded,
            accentColor: AppColors.statusWaitingApproval,
            bgColor: AppColors.statusWaitingApprovalBg,
            borderColor: AppColors.statusWaitingApprovalBorder,
          ),
          _ExecutiveMetricData(
            title: 'DOK SELESAI (2026)',
            value: '1',
            unit: 'Kapal',
            subtitle: 'KM Sinabung tahap akhir',
            icon: Icons.verified_rounded,
            accentColor: AppColors.statusApproved,
            bgColor: AppColors.statusApprovedBg,
            borderColor: AppColors.statusApprovedBorder,
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: metrics.map((m) {
            return SizedBox(
              width: cardWidth,
              child: _MetricCardWidget(data: m),
            );
          }).toList(),
        );
      },
    );
  }

  // ─── Katalog Armada (Grid Cards) ───────────────────────────────────────────
  Widget _buildFleetGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossAxisCount = width > 1100 ? 3 : (width > 700 ? 2 : 1);
        final itemWidth = (width - ((crossAxisCount - 1) * 16)) / crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _vessels.map((vessel) {
            return SizedBox(
              width: itemWidth,
              child: _VesselCard(
                vessel: vessel,
                onOpenWorkspace: () => _navigateToWorkspace(vessel),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─── Data Helper untuk Kartu Eksekutif ────────────────────────────────────────
class _ExecutiveMetricData {
  final String title;
  final String value;
  final String unit;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final Color borderColor;

  const _ExecutiveMetricData({
    required this.title,
    required this.value,
    required this.unit,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    required this.borderColor,
  });
}

// ─── Komponen Kartu Metrik Eksekutif ──────────────────────────────────────────
class _MetricCardWidget extends StatelessWidget {
  final _ExecutiveMetricData data;

  const _MetricCardWidget({required this.data});

  @override
  Widget build(BuildContext context) {
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
                data.title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: data.bgColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: data.borderColor, width: 1),
                ),
                child: Icon(data.icon, size: 15, color: data.accentColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                data.value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: data.accentColor,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                data.unit,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Komponen Kartu Armada Kapal PELNI ────────────────────────────────────────
class _VesselCard extends StatefulWidget {
  final VesselFleetItem vessel;
  final VoidCallback onOpenWorkspace;

  const _VesselCard({
    required this.vessel,
    required this.onOpenWorkspace,
  });

  @override
  State<_VesselCard> createState() => _VesselCardState();
}

class _VesselCardState extends State<_VesselCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final v = widget.vessel;
    final percentText = '${(v.progress * 100).toInt()}%';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
          border: Border.all(
            color: _isHovered ? AppColors.pelniSkyBlue : AppColors.borderColor,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? const Color(0x141A3B70) : const Color(0x06000000),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Kartu: Status Badge & IMO ────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
                top: AppDimens.space16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: v.statusBgColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: v.statusBorderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: v.statusTextColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          v.statusLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: v.statusTextColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    v.imoNumber,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ─── Nama & Tipe Kapal ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.pelniNavy,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.directions_boat_outlined,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        v.vesselType,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '• Call Sign: ${v.callSign}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ─── Lokasi Galangan Dok ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.pelniOrange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        v.shipyard,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Progress Bar Docking ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progres Pekerjaan Docking',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        percentText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pelniNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: v.progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        v.progress >= 0.8
                            ? AppColors.statusApproved
                            : AppColors.pelniSkyBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ─── Divider Pemisah ─────────────────────────────────────────
            const Divider(height: 1, color: AppColors.borderColor),

            // ─── Tombol Aksi [Buka Lembar Kerja Inspeksi ->] ──────────────
            InkWell(
              onTap: widget.onOpenWorkspace,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.space16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _isHovered ? AppColors.pelniNavyBg : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Buka Lembar Kerja Inspeksi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _isHovered ? AppColors.pelniNavy : AppColors.pelniNavy,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: _isHovered ? AppColors.pelniOrange : AppColors.pelniNavy,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
