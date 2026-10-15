import '../../domain/entities/vessel.dart';

class VesselModel extends Vessel {
  const VesselModel({
    required super.id,
    required super.name,
    required super.imoNumber,
    required super.blueprintUrl,
    super.createdAt,
  });

  factory VesselModel.fromJson(Map<String, dynamic> json) {
    return VesselModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imoNumber: json['imo_number'] as String,
      blueprintUrl: json['blueprint_url'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imo_number': imoNumber,
      'blueprint_url': blueprintUrl,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
