import '../../domain/entities/defect_hotspot.dart';
import 'vendor_model.dart';

class DefectHotspotModel extends DefectHotspot {
  const DefectHotspotModel({
    required super.id,
    required super.vesselId,
    required super.vendorId,
    required super.pinCode,
    required super.deckZone,
    required super.normX,
    required super.normY,
    required super.status,
    required super.description,
    super.beforePhotoUrl,
    super.afterPhotoUrl,
    super.inspectorNotes,
    super.createdAt,
    super.updatedAt,
    super.vendor,
  });

  factory DefectHotspotModel.fromJson(Map<String, dynamic> json) {
    return DefectHotspotModel(
      id: json['id'] as String,
      vesselId: json['vessel_id'] as String,
      vendorId: json['vendor_id'] as String,
      pinCode: json['pin_code'] as String,
      deckZone: json['deck_zone'] as String,
      normX: (json['norm_x'] as num).toDouble(),
      normY: (json['norm_y'] as num).toDouble(),
      status: DefectStatus.fromString(json['status'] as String),
      description: json['description'] as String,
      beforePhotoUrl: json['before_photo_url'] as String?,
      afterPhotoUrl: json['after_photo_url'] as String?,
      inspectorNotes: json['inspector_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      vendor: json['vendors'] != null
          ? VendorModel.fromJson(json['vendors'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vessel_id': vesselId,
      'vendor_id': vendorId,
      'pin_code': pinCode,
      'deck_zone': deckZone,
      'norm_x': normX,
      'norm_y': normY,
      'status': status.toDbValue(),
      'description': description,
      'before_photo_url': beforePhotoUrl,
      'after_photo_url': afterPhotoUrl,
      'inspector_notes': inspectorNotes,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
