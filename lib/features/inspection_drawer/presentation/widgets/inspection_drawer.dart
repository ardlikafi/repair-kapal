import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../defect_workspace/domain/entities/defect_hotspot.dart';
import '../../../defect_workspace/presentation/controllers/workspace_controller.dart';

/// InspectionDrawer — Panel Samping Kanan, Identitas Korporat PELNI (Light Theme).
/// Background: Putih (#FFFFFF), Teks & Konten Gelap (#0F172A), Anti-Overflow.
class InspectionDrawer extends StatelessWidget {
  final DefectHotspot hotspot;
  final WorkspaceController controller;

  const InspectionDrawer({
    super.key,
    required this.hotspot,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final vendor = hotspot.vendor;

    return Container(
      width: AppDimens.drawerWidthDesktop,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight, // Putih #FFFFFF
        border: Border(
          left: BorderSide(color: AppColors.borderColor, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header Drawer Tetap di Atas ─────────────────────────────────
          _DrawerHeader(hotspot: hotspot, onClose: controller.clearSelection),

          // ─── Seluruh Isi Drawer Dibungkus SingleChildScrollView ──────────
          // Mencegah RenderFlex Overflow (94 pixels) di layar/window yang lebih pendek
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (vendor != null) ...[
                    _VendorBadgeRow(vendor: vendor),
                    const SizedBox(height: AppDimens.space16),
                  ],

                  const _SectionTitle(label: '01  INFORMASI KERUSAKAN'),
                  const SizedBox(height: AppDimens.space8),
                  _DetailRow(label: 'ZONA KAPAL', value: hotspot.deckZone),
                  const SizedBox(height: AppDimens.space12),
                  _DetailBlock(label: 'DESKRIPSI TEKNIS', content: hotspot.description),

                  const SizedBox(height: AppDimens.space20),

                  const _SectionTitle(label: '02  DOKUMENTASI FOTO'),
                  const SizedBox(height: AppDimens.space8),
                  Row(
                    children: [
                      Expanded(
                        child: _PhotoCard(
                          label: 'SEBELUM',
                          photoUrl: hotspot.beforePhotoUrl,
                          accentColor: AppColors.statusOpen,
                          accentBg: AppColors.statusOpenBg,
                        ),
                      ),
                      const SizedBox(width: AppDimens.space8),
                      Expanded(
                        child: _PhotoCard(
                          label: 'SESUDAH',
                          photoUrl: hotspot.afterPhotoUrl,
                          accentColor: AppColors.statusApproved,
                          accentBg: AppColors.statusApprovedBg,
                        ),
                      ),
                    ],
                  ),

                  if (hotspot.inspectorNotes?.isNotEmpty == true) ...[
                    const SizedBox(height: AppDimens.space20),
                    const _SectionTitle(label: '03  CATATAN INSPEKTUR'),
                    const SizedBox(height: AppDimens.space8),
                    _InspectorNotesCard(notes: hotspot.inspectorNotes!),
                  ],

                  const SizedBox(height: AppDimens.space20),
                  const _SectionTitle(label: '04  DATA KOORDINAT'),
                  const SizedBox(height: AppDimens.space8),
                  _CoordinateChip(normX: hotspot.normX, normY: hotspot.normY),

                  const SizedBox(height: AppDimens.space24),

                  // ─── Tombol Aksi di dalam scrollable content ─────────────
                  _ActionBar(hotspot: hotspot, controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header (Putih Bersih, Senada dengan Body Drawer) ────────────────────────
class _DrawerHeader extends StatelessWidget {
  final DefectHotspot hotspot;
  final VoidCallback onClose;

  const _DrawerHeader({required this.hotspot, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight, // Putih bersih #FFFFFF — senada body drawer
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Aksen garis vertikal biru navy kecil di kiri kode pin
          Container(
            width: 3,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.pelniNavy,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          // Kode pin dalam navy tegas — terbaca jelas
          Text(
            '[${hotspot.pinCode}]',
            style: AppTheme.monoTagStyle(
              color: AppColors.pelniNavy,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: AppDimens.space12),
          _StatusBadge(status: hotspot.status),
          const Spacer(),
          // Tombol silang rapi: border tipis, icon navy
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderColor, width: 1.0),
              ),
              child: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DefectStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // Latar sesuai status (misal: merah muda, amber, biru, hijau)
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: status.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status.displayLabel,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: status.color, // Warna teks sesuai status (navy/merah/dll)
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vendor Badge ─────────────────────────────────────────────────────────────
class _VendorBadgeRow extends StatelessWidget {
  final dynamic vendor;
  const _VendorBadgeRow({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: vendor.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
              border: Border.all(color: vendor.color.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: vendor.color, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.companyName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary, // Gelap terbaca #0F172A
                  ),
                ),
                Text(
                  vendor.tradeZone,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          margin: const EdgeInsets.only(right: 7),
          color: AppColors.pelniNavy,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary, // Gelap terbaca #0F172A
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Detail Block ─────────────────────────────────────────────────────────────
class _DetailBlock extends StatelessWidget {
  final String label;
  final String content;
  const _DetailBlock({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.space12),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary, // Gelap terbaca #0F172A
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Kartu Foto ───────────────────────────────────────────────────────────────
class _PhotoCard extends StatelessWidget {
  final String label;
  final String? photoUrl;
  final Color accentColor;
  final Color accentBg;

  const _PhotoCard({
    required this.label,
    required this.photoUrl,
    required this.accentColor,
    required this.accentBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: accentBg,
            borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: accentColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
            border: Border.all(
              color: photoUrl != null
                  ? accentColor.withValues(alpha: 0.3)
                  : AppColors.borderColor,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: photoUrl != null
              ? CachedNetworkImage(
                  imageUrl: photoUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (ctx, url) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.pelniNavy,
                      strokeWidth: 1.5,
                    ),
                  ),
                  errorWidget: (ctx, url, err) => const _EmptyPhotoPlaceholder(
                      message: 'Foto dokumentasi tidak tersedia',
                      isError: true,
                    ),
                )
              : const _EmptyPhotoPlaceholder(message: 'Belum ada foto'),
        ),
      ],
    );
  }
}

class _EmptyPhotoPlaceholder extends StatelessWidget {
  final String message;
  final bool isError;
  const _EmptyPhotoPlaceholder({required this.message, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceCard, // Abu-abu muda #F8FAFC
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError
                  ? Icons.image_not_supported_outlined
                  : Icons.camera_alt_outlined,
              size: 24,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Catatan Inspektur ────────────────────────────────────────────────────────
class _InspectorNotesCard extends StatelessWidget {
  final String notes;
  const _InspectorNotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sticky_note_2_outlined,
              size: 14, color: AppColors.statusInProgress),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              notes,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textPrimary, // Gelap terbaca #0F172A
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Koordinat ────────────────────────────────────────────────────────────────
class _CoordinateChip extends StatelessWidget {
  final double normX;
  final double normY;
  const _CoordinateChip({required this.normX, required this.normY});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.my_location_outlined,
              size: 12, color: AppColors.pelniSkyBlue),
          const SizedBox(width: 6),
          Text(
            'X: ${normX.toStringAsFixed(4)}  /  Y: ${normY.toStringAsFixed(4)}',
            style: AppTheme.monoTagStyle(
              color: AppColors.textPrimary, // Gelap terbaca #0F172A
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dual Action Bar ──────────────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  final DefectHotspot hotspot;
  final WorkspaceController controller;
  const _ActionBar({required this.hotspot, required this.controller});

  @override
  Widget build(BuildContext context) {
    final status = hotspot.status;
    Widget content;

    if (status == DefectStatus.open) {
      content = _ActionButton(
        label: 'MULAI PENGERJAAN',
        icon: Icons.build_outlined,
        bgColor: AppColors.pelniNavy, // Warna pelniNavy
        onTap: () => controller.changeStatus(hotspot.id, DefectStatus.inProgress),
      );
    } else if (status == DefectStatus.inProgress) {
      content = _ActionButton(
        label: 'AJUKAN PERSETUJUAN',
        icon: Icons.send_rounded,
        bgColor: AppColors.pelniNavy, // Warna pelniNavy
        onTap: () => controller.submitForApproval(hotspot.id),
      );
    } else if (status == DefectStatus.waitingApproval) {
      content = Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'TOLAK',
              icon: Icons.cancel_outlined,
              bgColor: AppColors.statusOpen,
              outlined: true,
              onTap: () => controller.rejectHotspot(hotspot.id),
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            flex: 2,
            child: _ActionButton(
              label: 'SETUJUI PERBAIKAN',
              icon: Icons.verified_rounded,
              bgColor: AppColors.statusApproved, // Hijau APPROVED (0xFF059669)
              onTap: () => controller.approveHotspot(hotspot.id),
            ),
          ),
        ],
      );
    } else {
      content = Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.statusApprovedBg,
          borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
          border: Border.all(color: AppColors.statusApprovedBorder),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_rounded, size: 14, color: AppColors.statusApproved),
            SizedBox(width: 6),
            Text(
              'PERBAIKAN TELAH DISETUJUI & DITUTUP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.statusApproved,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: content,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : bgColor,
          borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
          border: Border.all(
            color: outlined ? bgColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: outlined ? bgColor : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: outlined ? bgColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
