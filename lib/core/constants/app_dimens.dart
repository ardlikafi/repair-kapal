import 'package:flutter/material.dart';

/// Aturan Geometri dan Spasial Industri
/// Larangan keras: Tidak menggunakan rounded pill besar (>24px) untuk mencegah AI Slop.
class AppDimens {
  AppDimens._();

  // Batas Maksimal Radius Sudut (Strict <= 6px)
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0; // Maksimal border radius

  static const BorderRadius borderNone = BorderRadius.zero;
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(radiusMd));

  // Spacing Standard
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Dimensi Komponen Khusus
  static const double topBarHeight = 56.0;
  static const double drawerWidthDesktop = 440.0;
  static const double pinMarkerSize = 34.0;
  static const double pinPulseRingSize = 48.0;
}
