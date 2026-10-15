import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../defect_workspace/presentation/controllers/workspace_controller.dart';
import '../defect_workspace/presentation/screens/workspace_view.dart';
import '../fleet_dashboard/presentation/screens/fleet_dashboard_view.dart';
import '../history/docking_history_view.dart';
import '../reports/annual_report_view.dart';
import '../splash/splash_screen.dart';

/// MainAppShell: Application Shell Enterprise dengan Global Navbar Persisten
class MainAppShell extends StatefulWidget {
  final WorkspaceController controller;

  const MainAppShell({super.key, required this.controller});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentTabIndex = 0;

  void _setTabIndex(int index) {
    if (_currentTabIndex != index) {
      setState(() => _currentTabIndex = index);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.pelniNavy, size: 20),
            SizedBox(width: 8),
            Text(
              'Konfirmasi Keluar Sistem',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.pelniNavy,
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari sesi Superintendent GM PELNI?',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.borderColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SplashScreen(controller: widget.controller),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pelniNavy,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Ya, Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasBg,
      body: Column(
        children: [
          // ─── Global Navbar Persisten ──────────────────────────────────
          _buildGlobalNavbar(),

          // ─── Konten Sesuai Tab Aktif ──────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                // Tab 0: Dashboard Eksekutif
                FleetDashboardView(
                  controller: widget.controller,
                  onSwitchTab: _setTabIndex,
                ),

                // Tab 1: Armada Aktif (Lembar Kerja Inspeksi & Denah GA)
                WorkspaceView(
                  controller: widget.controller,
                  onBack: () => _setTabIndex(0),
                ),

                // Tab 2: Riwayat Service & Dok (History)
                const DockingHistoryView(),

                // Tab 3: Laporan Tahunan (Executive Report Pak Rian)
                const AnnualReportView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Global Navbar Persisten (Putih Bersih #FFFFFF + Border Bawah #E2E8F0) ───
  Widget _buildGlobalNavbar() {
    return Container(
      height: 60 + MediaQuery.paddingOf(context).top,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
        left: AppDimens.space20,
        right: AppDimens.space20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight, // Putih bersih #FFFFFF
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1.0), // Border bawah halus #E2E8F0
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
          // ─── KIRI: Logo Resmi PELNI + Nama Sistem ───────────────────
          _buildBrandSection(),

          const SizedBox(width: AppDimens.space24),

          // ─── TENGAH: Menu Navigasi Tab ──────────────────────────────
          Expanded(
            child: _buildNavTabs(),
          ),

          const SizedBox(width: AppDimens.space16),

          // ─── KANAN: Indikator Akun + Role Badge + Logout ────────────
          _buildUserAccountSection(),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/pelni_logo.png',
          height: 30,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text(
            'PELNI',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.pelniNavy,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 28,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: AppColors.borderColor,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Text(
                  'PELNI Services',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pelniNavy,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '- Docking Ops',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pelniSkyBlue,
                  ),
                ),
              ],
            ),
            Text(
              'SISTEM MONITORING TERPADU ARMADA',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted.withValues(alpha: 0.9),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavTabs() {
    final navItems = [
      {'icon': '📊', 'title': 'Dashboard Eksekutif'},
      {'icon': '🚢', 'title': 'Armada Aktif'},
      {'icon': '📑', 'title': 'Riwayat Service & Dok'},
      {'icon': '📈', 'title': 'Laporan Tahunan'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _currentTabIndex == index;

          return _NavTabButton(
            icon: item['icon']!,
            title: item['title']!,
            isSelected: isSelected,
            onTap: () => _setTabIndex(index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserAccountSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar Inisial
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.pelniNavyBg,
            borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
            border: Border.all(color: const Color(0xFFBFD3F5), width: 1),
          ),
          child: const Center(
            child: Text(
              'BS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.pelniNavy,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Nama Akun + Role Badge
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bambang S. (Superintendent GM PELNI)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.pelniNavy,
              ),
            ),
            const SizedBox(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.pelniNavyBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFBFD3F5), width: 0.8),
              ),
              child: const Text(
                'SUPERINTENDENT',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pelniNavy,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 14),

        // Tombol Logout
        Tooltip(
          message: 'Keluar Sesi',
          child: InkWell(
            onTap: _handleLogout,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_rounded, size: 13, color: AppColors.statusOpen),
                  SizedBox(width: 4),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.statusOpen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Nav Tab Item Button ──────────────────────────────────────────────────────
class _NavTabButton extends StatefulWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavTabButton> createState() => _NavTabButtonState();
}

class _NavTabButtonState extends State<_NavTabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active
                ? AppColors.pelniNavyBg.withValues(alpha: 0.4)
                : (_isHovered ? AppColors.surfaceCard : Colors.transparent),
            border: Border(
              bottom: BorderSide(
                color: active
                    ? AppColors.pelniOrange // Garis bawah oranye khas PELNI
                    : Colors.transparent,
                width: 3.0,
              ),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.icon,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 7),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? AppColors.pelniNavy : AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
