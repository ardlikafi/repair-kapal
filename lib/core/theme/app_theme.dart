import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// Tema Aplikasi Light: Official PELNI Corporate Design System
/// Mengikuti panduan identitas korporat PT PELNI (Persero) — pelni.co.id
class AppTheme {
  AppTheme._();

  static ThemeData get pelniLightTheme {
    final baseTextTheme = GoogleFonts.robotoTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.canvasBg,
      primaryColor: AppColors.pelniNavy,
      colorScheme: const ColorScheme.light(
        primary: AppColors.pelniNavy,
        onPrimary: Colors.white,
        secondary: AppColors.pelniSkyBlue,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimary,
        error: AppColors.statusOpen,
        onError: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimens.borderMd,
          side: BorderSide(color: AppColors.borderColor, width: 1.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderColor,
        thickness: 1.0,
        space: 1.0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: AppColors.pelniNavy,
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pelniNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          shape: const RoundedRectangleBorder(borderRadius: AppDimens.borderMd),
          textStyle: GoogleFonts.roboto(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.pelniNavy,
          side: const BorderSide(color: AppColors.borderStrong, width: 1.0),
          shape: const RoundedRectangleBorder(borderRadius: AppDimens.borderMd),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          textStyle: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceCard,
        border: const OutlineInputBorder(
          borderRadius: AppDimens.borderMd,
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppDimens.borderMd,
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppDimens.borderMd,
          borderSide: BorderSide(color: AppColors.pelniNavy, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        hintStyle: GoogleFonts.roboto(color: AppColors.textMuted, fontSize: 13.0),
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.roboto(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.roboto(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        titleMedium: GoogleFonts.roboto(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        bodyLarge: GoogleFonts.roboto(color: AppColors.textPrimary, fontSize: 14),
        bodyMedium: GoogleFonts.roboto(color: AppColors.textSecondary, fontSize: 13),
        labelSmall: GoogleFonts.robotoMono(color: AppColors.textMuted, fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }

  /// Teks monospace untuk Kode Tag & Koordinat Teknis
  static TextStyle monoTagStyle({
    Color color = AppColors.textPrimary,
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.jetBrainsMono(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.4,
    );
  }
}
