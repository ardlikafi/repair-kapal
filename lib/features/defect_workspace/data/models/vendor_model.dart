import '../../domain/entities/vendor.dart';

class VendorModel extends Vendor {
  const VendorModel({
    required super.id,
    required super.companyName,
    required super.tradeZone,
    required super.colorHex,
    super.createdAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      tradeZone: json['trade_zone'] as String,
      colorHex: json['color_hex'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'trade_zone': tradeZone,
      'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
