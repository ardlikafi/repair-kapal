import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/utils/coordinate_math.dart';
import '../../domain/entities/defect_hotspot.dart';
import 'pin_marker_badge.dart';

/// Kanvas Penuh Interaktif Blueprint Kapal — Light Theme Korporat
/// Mendukung pan bebas horizontal (haluan ↔ buritan) + floating zoom toolbar.
class InteractiveCanvasWidget extends StatefulWidget {
  final String blueprintUrl;
  final List<DefectHotspot> hotspots;
  final String? selectedHotspotId;
  final void Function(Offset normalizedPosition) onTapCanvas;
  final void Function(DefectHotspot hotspot) onTapHotspot;

  const InteractiveCanvasWidget({
    super.key,
    required this.blueprintUrl,
    required this.hotspots,
    required this.onTapCanvas,
    required this.onTapHotspot,
    this.selectedHotspotId,
  });

  @override
  State<InteractiveCanvasWidget> createState() =>
      _InteractiveCanvasWidgetState();
}

class _InteractiveCanvasWidgetState extends State<InteractiveCanvasWidget> {
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _imageKey = GlobalKey();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Offset _toScreenPosition(double normX, double normY) {
    final box = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Offset.zero;
    return CoordinateMath.toCanvasPosition(
      normX: normX,
      normY: normY,
      currentCanvasSize: box.size,
    );
  }

  Offset _toNormalized(Offset localPos) {
    final box = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Offset.zero;
    return CoordinateMath.toNormalized(
      localPosition: localPos,
      renderedSize: box.size,
    );
  }

  void _zoomIn() {
    final current = _transformController.value;
    final scale = current.getMaxScaleOnAxis();
    if (scale >= 4.0) return;
    final factor = (scale * 1.3).clamp(0.2, 4.0) / scale;
    _applyZoom(current, factor);
  }

  void _zoomOut() {
    final current = _transformController.value;
    final scale = current.getMaxScaleOnAxis();
    if (scale <= 0.2) return;
    final factor = (scale / 1.3).clamp(0.2, 4.0) / scale;
    _applyZoom(current, factor);
  }

  void _applyZoom(Matrix4 current, double factor) {
    final size = context.size ?? Size.zero;
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Terjemahkan pusat → scale → terjemahkan kembali (tanpa API deprecated)
    final toCenter = Matrix4.translationValues(cx, cy, 0);
    final scaleM = Matrix4.diagonal3Values(factor, factor, 1.0);
    final fromCenter = Matrix4.translationValues(-cx, -cy, 0);
    _transformController.value = toCenter * scaleM * fromCenter * current;
  }

  void _resetView() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvasBg,
      child: Stack(
        children: [
          // ─── InteractiveViewer: kanvas blueprint ──────────────────────
          ClipRect(
            child: InteractiveViewer(
              transformationController: _transformController,
              // boundaryMargin lebar agar bisa geser bebas ke haluan & buritan
              boundaryMargin: const EdgeInsets.symmetric(
                horizontal: 1600,
                vertical: 600,
              ),
              minScale: 0.2,
              maxScale: 4.0,
              constrained: false,
              panEnabled: true,
              scaleEnabled: true,
              child: GestureDetector(
                onTapUp: (details) {
                  final norm = _toNormalized(details.localPosition);
                  widget.onTapCanvas(norm);
                },
                child: Stack(
                  children: [
                    // ─── Blueprint Kapal ────────────────────────────────
                    _BlueprintImage(key: _imageKey, url: widget.blueprintUrl),

                    // ─── Overlay Pin ────────────────────────────────────
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _PinOverlayLayer(
                            hotspots: widget.hotspots,
                            selectedHotspotId: widget.selectedHotspotId,
                            imageKey: _imageKey,
                            onTapHotspot: widget.onTapHotspot,
                            toScreenPosition: _toScreenPosition,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Floating Mini Toolbar (Zoom Controls) ────────────────────
          // Pojok kiri bawah — putih bersih, shadow halus, border tipis
          Positioned(
            left: 16,
            bottom: 16,
            child: _ZoomToolbar(
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onReset: _resetView,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Floating Zoom Toolbar ────────────────────────────────────────────────────
class _ZoomToolbar extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const _ZoomToolbar({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight, // Putih bersih #FFFFFF
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToolbarButton(
            icon: Icons.add,
            tooltip: 'Perbesar',
            onTap: onZoomIn,
            isTop: true,
          ),
          Container(height: 1, color: AppColors.borderColor),
          _ToolbarButton(
            icon: Icons.remove,
            tooltip: 'Perkecil',
            onTap: onZoomOut,
          ),
          Container(height: 1, color: AppColors.borderColor),
          _ToolbarButton(
            icon: Icons.crop_free_rounded,
            tooltip: 'Reset Tampilan',
            onTap: onReset,
            isBottom: true,
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isTop;
  final bool isBottom;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isTop = false,
    this.isBottom = false,
  });

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      preferBelow: false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered ? AppColors.pelniNavyBg : Colors.transparent,
              borderRadius: BorderRadius.vertical(
                top: widget.isTop ? const Radius.circular(7) : Radius.zero,
                bottom: widget.isBottom ? const Radius.circular(7) : Radius.zero,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hovered ? AppColors.pelniNavy : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Gambar Blueprint (CAD Drafting Sheet Frame) ──────────────────────────────
class _BlueprintImage extends StatelessWidget {
  final String url;
  const _BlueprintImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        width: screenSize.width,
        height: screenSize.height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: screenSize.width,
          height: screenSize.height,
          color: AppColors.surfaceLight,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                    color: AppColors.pelniNavy, strokeWidth: 2),
                SizedBox(height: 12),
                Text(
                  'Memuat Denah Kapal...',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: screenSize.width,
          height: screenSize.height,
          color: AppColors.surfaceLight,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image_not_supported_outlined,
                  size: 48, color: AppColors.textMuted),
              const SizedBox(height: 8),
              const Text(
                'Foto dokumentasi tidak tersedia',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: AppDimens.borderSm,
                  color: AppColors.surfaceCard,
                ),
                child: Text(url,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Lapisan Overlay Pin ──────────────────────────────────────────────────────
class _PinOverlayLayer extends StatelessWidget {
  final List<DefectHotspot> hotspots;
  final String? selectedHotspotId;
  final GlobalKey imageKey;
  final void Function(DefectHotspot) onTapHotspot;
  final Offset Function(double, double) toScreenPosition;

  const _PinOverlayLayer({
    required this.hotspots,
    required this.selectedHotspotId,
    required this.imageKey,
    required this.onTapHotspot,
    required this.toScreenPosition,
  });

  @override
  Widget build(BuildContext context) {
    if (hotspots.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: hotspots.map((hotspot) {
        final pos = toScreenPosition(hotspot.normX, hotspot.normY);
        final isSelected = hotspot.id == selectedHotspotId;
        final halfPin = AppDimens.pinMarkerSize / 2;
        final halfPulse = AppDimens.pinPulseRingSize / 2;

        return Positioned(
          left: pos.dx -
              (hotspot.status == DefectStatus.waitingApproval
                  ? halfPulse
                  : halfPin),
          top: pos.dy -
              (hotspot.status == DefectStatus.waitingApproval
                  ? halfPulse
                  : halfPin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PinMarkerBadge(
                hotspot: hotspot,
                isSelected: isSelected,
                onTap: () => onTapHotspot(hotspot),
              ),
              PinCodeLabel(pinCode: hotspot.pinCode, isSelected: isSelected),
            ],
          ),
        );
      }).toList(),
    );
  }
}
