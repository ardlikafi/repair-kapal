import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../defect_workspace/presentation/widgets/interactive_canvas_widget.dart';
import '../../../defect_workspace/presentation/widgets/workspace_top_bar.dart';
import '../../../inspection_drawer/presentation/widgets/inspection_drawer.dart';
import '../controllers/workspace_controller.dart';
import '../widgets/add_hotspot_dialog.dart';
import '../widgets/deck_switcher_bar.dart';
import '../widgets/docking_report_dialog.dart';

/// Layar Utama: Workspace Pemantauan Defect Kapal Drydock PELNI
/// Layout: TopBar + DeckSwitcherBar + FullBleed Canvas + Side Drawer (Light Corporate Theme)
class WorkspaceView extends StatefulWidget {
  final WorkspaceController controller;
  final VoidCallback? onBack;

  const WorkspaceView({
    super.key,
    required this.controller,
    this.onBack,
  });

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView> {
  @override
  void initState() {
    super.initState();
    // Muat data saat layar pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initialize();
    });
  }

  void _openDockingReport(BuildContext context, WorkspaceController ctrl) {
    if (ctrl.vessel == null) return;
    DockingReportDialog.show(
      context,
      vessel: ctrl.vessel!,
      hotspots: ctrl.allHotspots,
    );
  }

  void _openAddPinDialog(BuildContext context, WorkspaceController ctrl) {
    if (ctrl.vessel == null) return;
    AddHotspotDialog.show(
      context,
      vesselId: ctrl.vessel!.id,
      vendors: ctrl.vendors,
      currentDeck: ctrl.selectedDeck,
      totalExistingHotspots: ctrl.allHotspots.length,
      onSave: (newHotspot) async {
        await ctrl.createHotspot(newHotspot);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;

        return Scaffold(
          backgroundColor: AppColors.canvasBg,
          body: Column(
            children: [
              // ─── Top Bar ──────────────────────────────────────────────
              if (ctrl.vessel != null) ...[
                WorkspaceTopBar(
                  vesselName: ctrl.vessel!.name,
                  imoNumber: ctrl.vessel!.imoNumber,
                  countTotal: ctrl.totalHotspots,
                  countOpen: ctrl.countOpen,
                  countInProgress: ctrl.countInProgress,
                  countWaiting: ctrl.countWaitingApproval,
                  countApproved: ctrl.countApproved,
                  vendors: ctrl.vendors,
                  selectedVendorId: ctrl.filterVendorId,
                  onVendorFilterChanged: ctrl.setVendorFilter,
                  onBack: widget.onBack ??
                      (Navigator.canPop(context)
                          ? () => Navigator.pop(context)
                          : null),
                  onPrintReport: () => _openDockingReport(context, ctrl),
                ),

                // ─── Deck Switcher Bar (Pilihan Geladak Kapal) ────────────
                DeckSwitcherBar(
                  activeDeck: ctrl.selectedDeck,
                  onDeckSelected: ctrl.selectDeck,
                  countHotspots: ctrl.countHotspotsForDeck,
                ),
              ] else
                _LoadingTopBarPlaceholder(),

              // ─── Area Utama: Canvas + Drawer ───────────────────────────
              Expanded(
                child: _buildMainArea(ctrl),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainArea(WorkspaceController ctrl) {
    switch (ctrl.loadState) {
      case WorkspaceLoadState.loading:
      case WorkspaceLoadState.idle:
        return _buildLoadingState();

      case WorkspaceLoadState.error:
        return _buildErrorState(ctrl);

      case WorkspaceLoadState.loaded:
        return _buildLoadedState(ctrl);
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.pelniNavy, strokeWidth: 2),
          SizedBox(height: 16),
          Text(
            'Memuat Data Monitoring Galangan PELNI...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WorkspaceController ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 42, color: AppColors.statusOpen),
            const SizedBox(height: 12),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ctrl.errorMessage ?? 'Terjadi kesalahan koneksi ke server.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: ctrl.initialize,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.pelniNavy,
                  borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
                ),
                child: const Text(
                  'COBA LAGI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(WorkspaceController ctrl) {
    final hasDrawer = ctrl.selectedHotspot != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── Kanvas Blueprint (Full-Bleed) ─────────────────────────────
        Expanded(
          child: Stack(
            children: [
              InteractiveCanvasWidget(
                blueprintUrl:
                    ctrl.selectedDeck.blueprintUrl(ctrl.vessel!.blueprintUrl),
                hotspots: ctrl.hotspots,
                selectedHotspotId: ctrl.selectedHotspot?.id,
                onTapCanvas: (normPos) {
                  // Tap area kosong: tutup drawer jika ada yang terbuka
                  if (ctrl.selectedHotspot != null) {
                    ctrl.clearSelection();
                  }
                },
                onTapHotspot: ctrl.selectHotspot,
              ),

              // Overlay grid teknis tipis sebagai panduan denah
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _TechnicalGridPainter()),
                ),
              ),

              // ─── Floating Action Button: + Titik Temuan Baru ───────────
              Positioned(
                bottom: 16,
                right: 16,
                child: _QuickAddPinButton(
                  onPressed: () => _openAddPinDialog(context, ctrl),
                ),
              ),
            ],
          ),
        ),

        // ─── Inspection Drawer (Side Panel Kanan) ──────────────────────
        if (hasDrawer)
          AnimatedSlide(
            offset: hasDrawer ? Offset.zero : const Offset(1.0, 0),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: InspectionDrawer(
              hotspot: ctrl.selectedHotspot!,
              controller: ctrl,
            ),
          ),
      ],
    );
  }
}

/// Grid teknis tipis sebagai overlay panduan latar belakang
class _TechnicalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    const gridSpacing = 80.0;

    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LoadingTopBarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: AppColors.borderColor, width: 1.0)),
      ),
      child: const Center(
        child: Text(
          'Menginisialisasi Sistem Pemantauan PELNI...',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

// ─── Floating Button: Quick Add Pin ──────────────────────────────────────────
class _QuickAddPinButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _QuickAddPinButton({required this.onPressed});

  @override
  State<_QuickAddPinButton> createState() => _QuickAddPinButtonState();
}

class _QuickAddPinButtonState extends State<_QuickAddPinButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF142E57) : AppColors.pelniNavy,
            borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
            border: Border.all(color: const Color(0xFFBFD3F5), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? const Color(0x331A3B70)
                    : const Color(0x221A3B70),
                blurRadius: _isHovered ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_location_alt_rounded,
                  size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '+ Titik Temuan Baru',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
