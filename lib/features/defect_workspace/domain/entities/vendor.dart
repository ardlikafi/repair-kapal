import 'package:flutter/material.dart';

/// Entitas Vendor / Kontraktor Galangan Kapal
class Vendor {
  final String id;
  final String companyName;
  final String tradeZone;
  final String colorHex;
  final DateTime? createdAt;

  const Vendor({
    required this.id,
    required this.companyName,
    required this.tradeZone,
    required this.colorHex,
    this.createdAt,
  });

  /// Mengonversi nilai hexadecimal string (#RRGGBB) ke objek Color Flutter
  Color get color {
    final cleanHex = colorHex.replaceFirst('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    } else if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }
    return const Color(0xFF64748B); // Fallback color
  }
}
