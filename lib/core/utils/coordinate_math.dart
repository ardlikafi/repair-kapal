import 'package:flutter/material.dart';

/// Utilitas Perhitungan Koordinat Normalisasi (Mathematical Coordinate System)
/// Sesuai Section 2 spesifikasi teknis: memastikan penanda pin tidak pernah bergeser
/// ketika ukuran layar atau rasio kanvas berubah (responsive multi-platform).
class CoordinateMath {
  CoordinateMath._();

  /// Mengonversi posisi sentuhan (tap) pada kanvas menjadi koordinat normalisasi (0.0000 - 1.0000)
  static Offset toNormalized({
    required Offset localPosition,
    required Size renderedSize,
  }) {
    if (renderedSize.width <= 0 || renderedSize.height <= 0) {
      return Offset.zero;
    }

    final double normX = (localPosition.dx / renderedSize.width).clamp(0.0, 1.0);
    final double normY = (localPosition.dy / renderedSize.height).clamp(0.0, 1.0);

    return Offset(
      double.parse(normX.toStringAsFixed(4)),
      double.parse(normY.toStringAsFixed(4)),
    );
  }

  /// Mengonversi koordinat normalisasi (0.0000 - 1.0000) menjadi koordinat piksel aktual layar kanvas
  static Offset toCanvasPosition({
    required double normX,
    required double normY,
    required Size currentCanvasSize,
  }) {
    final double screenX = normX * currentCanvasSize.width;
    final double screenY = normY * currentCanvasSize.height;

    return Offset(screenX, screenY);
  }

  /// Format string standar untuk log teknis atau tampilan inspeksi [X: 0.2650, Y: 0.5820]
  static String formatCoordinate(double normX, double normY) {
    return 'X:${normX.toStringAsFixed(4)} Y:${normY.toStringAsFixed(4)}';
  }
}
