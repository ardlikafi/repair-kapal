import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'vendor.dart';

/// Status Temuan Defect Berdasarkan Standar Maritim PELNI
enum DefectStatus {
  open,
  inProgress,
  waitingApproval,
  approved;

  static DefectStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'OPEN':
        return DefectStatus.open;
      case 'IN_PROGRESS':
        return DefectStatus.inProgress;
      case 'WAITING_APPROVAL':
        return DefectStatus.waitingApproval;
      case 'APPROVED':
      case 'APPROVED_CLOSED':
        return DefectStatus.approved;
      default:
        return DefectStatus.open;
    }
  }

  String toDbValue() {
    switch (this) {
      case DefectStatus.open:
        return 'OPEN';
      case DefectStatus.inProgress:
        return 'IN_PROGRESS';
      case DefectStatus.waitingApproval:
        return 'WAITING_APPROVAL';
      case DefectStatus.approved:
        return 'APPROVED';
    }
  }

  /// Label Bahasa Indonesia Formal (Standar Pelaporan Maritim)
  String get displayLabel {
    switch (this) {
      case DefectStatus.open:
        return 'TEMUAN BARU';
      case DefectStatus.inProgress:
        return 'DALAM PENGERJAAN';
      case DefectStatus.waitingApproval:
        return 'MENUNGGU PERSETUJUAN';
      case DefectStatus.approved:
        return 'DISETUJUI (CLOSED)';
    }
  }

  /// Warna Kode Status
  Color get color {
    switch (this) {
      case DefectStatus.open:
        return AppColors.statusOpen;
      case DefectStatus.inProgress:
        return AppColors.statusInProgress;
      case DefectStatus.waitingApproval:
        return AppColors.statusWaitingApproval;
      case DefectStatus.approved:
        return AppColors.statusApproved;
    }
  }

  /// Warna Latar Badge
  Color get badgeBgColor {
    switch (this) {
      case DefectStatus.open:
        return AppColors.statusOpenBg;
      case DefectStatus.inProgress:
        return AppColors.statusInProgressBg;
      case DefectStatus.waitingApproval:
        return AppColors.statusWaitingApprovalBg;
      case DefectStatus.approved:
        return AppColors.statusApprovedBg;
    }
  }

  /// Alias eksplisit untuk background badge
  Color get backgroundColor => badgeBgColor;

  /// Warna Border Badge
  Color get borderColor {
    switch (this) {
      case DefectStatus.open:
        return AppColors.statusOpenBorder;
      case DefectStatus.inProgress:
        return AppColors.statusInProgressBorder;
      case DefectStatus.waitingApproval:
        return AppColors.statusWaitingApprovalBorder;
      case DefectStatus.approved:
        return AppColors.statusApprovedBorder;
    }
  }
}

/// Entitas Titik Temuan Kerusakan (Defect Hotspot)
class DefectHotspot {
  final String id;
  final String vesselId;
  final String vendorId;
  final String pinCode;
  final String deckZone;
  final double normX;
  final double normY;
  final DefectStatus status;
  final String description;
  final String? beforePhotoUrl;
  final String? afterPhotoUrl;
  final String? inspectorNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Vendor? vendor; // Relasi data vendor yang mengerjakan

  const DefectHotspot({
    required this.id,
    required this.vesselId,
    required this.vendorId,
    required this.pinCode,
    required this.deckZone,
    required this.normX,
    required this.normY,
    required this.status,
    required this.description,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.inspectorNotes,
    this.createdAt,
    this.updatedAt,
    this.vendor,
  });

  DefectHotspot copyWith({
    String? id,
    String? vesselId,
    String? vendorId,
    String? pinCode,
    String? deckZone,
    double? normX,
    double? normY,
    DefectStatus? status,
    String? description,
    String? beforePhotoUrl,
    String? afterPhotoUrl,
    String? inspectorNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Vendor? vendor,
  }) {
    return DefectHotspot(
      id: id ?? this.id,
      vesselId: vesselId ?? this.vesselId,
      vendorId: vendorId ?? this.vendorId,
      pinCode: pinCode ?? this.pinCode,
      deckZone: deckZone ?? this.deckZone,
      normX: normX ?? this.normX,
      normY: normY ?? this.normY,
      status: status ?? this.status,
      description: description ?? this.description,
      beforePhotoUrl: beforePhotoUrl ?? this.beforePhotoUrl,
      afterPhotoUrl: afterPhotoUrl ?? this.afterPhotoUrl,
      inspectorNotes: inspectorNotes ?? this.inspectorNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vendor: vendor ?? this.vendor,
    );
  }
}
