import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/defect_hotspot.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/entities/vessel_deck.dart';

/// Modal Dialog Formulir Pendaftaran Titik Temuan Baru (Quick Add Pin)
class AddHotspotDialog extends StatefulWidget {
  final String vesselId;
  final List<Vendor> vendors;
  final VesselDeck currentDeck;
  final int totalExistingHotspots;
  final Future<void> Function(DefectHotspot) onSave;

  const AddHotspotDialog({
    super.key,
    required this.vesselId,
    required this.vendors,
    required this.currentDeck,
    required this.totalExistingHotspots,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required String vesselId,
    required List<Vendor> vendors,
    required VesselDeck currentDeck,
    required int totalExistingHotspots,
    required Future<void> Function(DefectHotspot) onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddHotspotDialog(
        vesselId: vesselId,
        vendors: vendors,
        currentDeck: currentDeck,
        totalExistingHotspots: totalExistingHotspots,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddHotspotDialog> createState() => _AddHotspotDialogState();
}

class _AddHotspotDialogState extends State<AddHotspotDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _pinCodeController;
  late TextEditingController _descController;
  late TextEditingController _notesController;
  late TextEditingController _photoUrlController;

  String? _selectedVendorId;
  late VesselDeck _selectedDeck;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedDeck = widget.currentDeck;

    // Generate kode tag default realistis
    final prefix = _getDeckPrefix(_selectedDeck);
    final nextNumber = widget.totalExistingHotspots + 1;
    _pinCodeController = TextEditingController(
      text: '$prefix-${nextNumber.toString().padLeft(2, '0')}',
    );

    _descController = TextEditingController();
    _notesController = TextEditingController();
    _photoUrlController = TextEditingController(
      text: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=900&auto=format&fit=crop&q=80',
    );

    if (widget.vendors.isNotEmpty) {
      _selectedVendorId = widget.vendors.first.id;
    }
  }

  String _getDeckPrefix(VesselDeck deck) {
    switch (deck) {
      case VesselDeck.profile:
        return 'HULL';
      case VesselDeck.mainDeck:
        return 'DECK';
      case VesselDeck.bridgeDeck:
        return 'BRG';
    }
  }

  @override
  void dispose() {
    _pinCodeController.dispose();
    _descController.dispose();
    _notesController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVendorId == null) return;

    setState(() => _isSubmitting = true);

    final selectedVendor = widget.vendors.firstWhere(
      (v) => v.id == _selectedVendorId,
      orElse: () => widget.vendors.first,
    );

    // Hitung posisi normalisasi awal sesuai dek agar langsung terlihat di area kerja
    double normX = 0.50;
    double normY = 0.50;
    if (_selectedDeck == VesselDeck.profile) {
      normX = 0.35;
      normY = 0.60;
    } else if (_selectedDeck == VesselDeck.mainDeck) {
      normX = 0.48;
      normY = 0.45;
    } else {
      normX = 0.62;
      normY = 0.35;
    }

    final newHotspot = DefectHotspot(
      id: 'hotspot-${DateTime.now().millisecondsSinceEpoch}',
      vesselId: widget.vesselId,
      vendorId: _selectedVendorId!,
      pinCode: _pinCodeController.text.trim().toUpperCase(),
      deckZone: '${_selectedDeck.label} (Area Inspeksi Baru)',
      normX: normX,
      normY: normY,
      status: DefectStatus.open,
      description: _descController.text.trim(),
      beforePhotoUrl: _photoUrlController.text.trim().isEmpty
          ? null
          : _photoUrlController.text.trim(),
      afterPhotoUrl: null,
      inspectorNotes: _notesController.text.trim().isEmpty
          ? 'Temuan baru dicatat oleh Superintendent. Menunggu pengerjaan mitra vendor.'
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
      vendor: selectedVendor,
    );

    await widget.onSave(newHotspot);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.pelniNavy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                'Titik temuan [${newHotspot.pinCode}] berhasil ditambahkan pada denah.',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Dialog ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLight,
                border: Border(
                  bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.pelniNavyBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFD3F5)),
                    ),
                    child: const Icon(
                      Icons.add_location_alt_rounded,
                      size: 18,
                      color: AppColors.pelniNavy,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pendaftaran Titik Temuan Kerusakan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pelniNavy,
                          ),
                        ),
                        Text(
                          'Formulir pendaftaran inspeksi lapangan baru pada denah kapal',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 18,
                  ),
                ],
              ),
            ),

            // ─── Body Formulir ───────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: Kode Pin & Pilihan Dek
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildTextField(
                              label: 'KODE TAG (PIN CODE)',
                              controller: _pinCodeController,
                              hint: 'Misal: HULL-14',
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildDeckDropdown(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Baris 2: Mitra Vendor Pelaksana
                      _buildVendorDropdown(),

                      const SizedBox(height: 14),

                      // Baris 3: Deskripsi Kerusakan
                      _buildTextField(
                        label: 'DESKRIPSI KERUSAKAN / CACAT MATERIAL',
                        controller: _descController,
                        hint: 'Jelaskan temuan teknis (ketebalan plat aus, korosi, kebocoran pipa, dsb)...',
                        maxLines: 3,
                        isRequired: true,
                      ),

                      const SizedBox(height: 14),

                      // Baris 4: Foto Dokumentasi (URL)
                      _buildTextField(
                        label: 'URL FOTO DOKUMENTASI (BEFORE)',
                        controller: _photoUrlController,
                        hint: 'https://...',
                        prefixIcon: Icons.link_rounded,
                      ),

                      const SizedBox(height: 14),

                      // Baris 5: Catatan Rekomendasi Teknis
                      _buildTextField(
                        label: 'CATATAN REKOMENDASI TEKNIS / SUPERINTENDENT',
                        controller: _notesController,
                        hint: 'Misal: Wajib replating plat marine grade sebelum hydro test...',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Footer Aksi ─────────────────────────────────────────────
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
                    onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Batal',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
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
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 16),
                    label: Text(
                      _isSubmitting
                          ? 'Menyimpan...'
                          : 'Simpan & Tempatkan Titik',
                      style: const TextStyle(
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool isRequired = false,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(color: AppColors.statusOpen, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 16, color: AppColors.textSecondary)
                : null,
            filled: true,
            fillColor: AppColors.surfaceCard,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  const BorderSide(color: AppColors.pelniNavy, width: 1.5),
            ),
          ),
          validator: isRequired
              ? (val) => (val == null || val.trim().isEmpty)
                  ? 'Field ini wajib diisi'
                  : null
              : null,
        ),
      ],
    );
  }

  Widget _buildDeckDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PILIH ZONA DEK',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<VesselDeck>(
              value: _selectedDeck,
              isExpanded: true,
              dropdownColor: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
              onChanged: (newDeck) {
                if (newDeck != null) {
                  setState(() {
                    _selectedDeck = newDeck;
                    final prefix = _getDeckPrefix(newDeck);
                    _pinCodeController.text =
                        '$prefix-${(widget.totalExistingHotspots + 1).toString().padLeft(2, '0')}';
                  });
                }
              },
              items: VesselDeck.values.map((deck) {
                return DropdownMenuItem<VesselDeck>(
                  value: deck,
                  child: Row(
                    children: [
                      Text(deck.iconEmoji, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 8),
                      Text(
                        deck.label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVendorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MITRA VENDOR PELAKSANA',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedVendorId,
              isExpanded: true,
              dropdownColor: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
              onChanged: (newVendorId) {
                if (newVendorId != null) {
                  setState(() => _selectedVendorId = newVendorId);
                }
              },
              items: widget.vendors.map((vendor) {
                return DropdownMenuItem<String>(
                  value: vendor.id,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: vendor.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        vendor.companyName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
