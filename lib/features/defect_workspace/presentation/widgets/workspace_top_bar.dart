import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/vendor.dart';

/// Top Bar Workspace Resmi — Identitas Korporat PT PELNI
/// Layout: Logo | Nama Kapal | Statistik Counter (Flexible & Responsive) | Filter Vendor
class WorkspaceTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String vesselName;
  final String imoNumber;
  final int countTotal;
  final int countOpen;
  final int countInProgress;
  final int countWaiting;
  final int countApproved;
  final List<Vendor> vendors;
  final String? selectedVendorId;
  final void Function(String?) onVendorFilterChanged;
  final VoidCallback? onBack;
  final VoidCallback? onPrintReport;

  const WorkspaceTopBar({
    super.key,
    required this.vesselName,
    required this.imoNumber,
    required this.countTotal,
    required this.countOpen,
    required this.countInProgress,
    required this.countWaiting,
    required this.countApproved,
    required this.vendors,
    required this.selectedVendorId,
    required this.onVendorFilterChanged,
    this.onBack,
    this.onPrintReport,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + MediaQuery.paddingOf(context).top,
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight, // Putih bersih #FFFFFF
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1.0), // Border bawah tipis
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── Tombol Navigasi Kembali ke Armada ──────────────────────────
            if (onBack != null) ...[
              InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderColor, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, size: 14, color: AppColors.pelniNavy),
                      SizedBox(width: 6),
                      Text(
                        'Kembali ke Armada',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pelniNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.borderColor,
              ),
            ],

            // ─── Logo PELNI di kiri ──────────────────────────────────────
            _PelniLogo(),

            // Divider vertikal
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              color: AppColors.borderColor,
            ),

            // ─── Identitas Kapal (pelniNavy) ─────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vesselName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.pelniNavy,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  imoNumber,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(width: AppDimens.space16),

            // ─── Statistik Counter (Flexible & Scrollable Wrap – Bebas Overflow) ───
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      _StatCard(
                        label: 'TOTAL',
                        count: countTotal,
                        textColor: AppColors.pelniNavy,
                        bgColor: AppColors.pelniNavyBg,
                        borderColor: const Color(0xFFBFD3F5),
                      ),
                      _StatCard(
                        label: 'BARU',
                        count: countOpen,
                        textColor: AppColors.statusOpen,
                        bgColor: AppColors.statusOpenBg,
                        borderColor: AppColors.statusOpenBorder,
                      ),
                      _StatCard(
                        label: 'PROSES',
                        count: countInProgress,
                        textColor: AppColors.statusInProgress,
                        bgColor: AppColors.statusInProgressBg,
                        borderColor: AppColors.statusInProgressBorder,
                      ),
                      _StatCard(
                        label: 'REVIEW',
                        count: countWaiting,
                        textColor: AppColors.statusWaitingApproval,
                        bgColor: AppColors.statusWaitingApprovalBg,
                        borderColor: AppColors.statusWaitingApprovalBorder,
                      ),
                      _StatCard(
                        label: 'SELESAI',
                        count: countApproved,
                        textColor: AppColors.statusApproved,
                        bgColor: AppColors.statusApprovedBg,
                        borderColor: AppColors.statusApprovedBorder,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppDimens.space16),

            // ─── Filter Vendor ────────────────────────────────────────────
            _VendorFilterDropdown(
              vendors: vendors,
              selectedVendorId: selectedVendorId,
              onChanged: onVendorFilterChanged,
            ),

            // ─── Tombol Aksi Utama: Cetak Laporan Dok ────────────────────
            if (onPrintReport != null) ...[
              const SizedBox(width: AppDimens.space12),
              InkWell(
                onTap: onPrintReport,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.pelniNavy,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A1A3B70),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.description_outlined,
                          size: 15, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Cetak Laporan Dok',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Logo PELNI (Image + Fallback Teks Resmi) ────────────────────────────────
class _PelniLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/pelni_logo.png',
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Text(
        'PELNI',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A3B70),
          fontSize: 18,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;

  const _StatCard({
    required this.label,
    required this.count,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor,
              height: 1.1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dropdown Filter Vendor ───────────────────────────────────────────────────
class _VendorFilterDropdown extends StatelessWidget {
  final List<Vendor> vendors;
  final String? selectedVendorId;
  final void Function(String?) onChanged;

  const _VendorFilterDropdown({
    required this.vendors,
    required this.selectedVendorId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedVendorId,
          isDense: true,
          icon: const Icon(Icons.filter_list_rounded,
              size: 15, color: AppColors.pelniNavy),
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: AppColors.surfaceLight,
          hint: const Text(
            'Semua Vendor',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          onChanged: onChanged,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text(
                'Semua Vendor',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ),
            ...vendors.map((v) => DropdownMenuItem<String>(
                  value: v.id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: v.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 110),
                        child: Text(
                          v.companyName,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
