import 'package:flutter/material.dart';

/// Official PELNI Corporate Color Palette
/// Referensi: Identitas Visual Korporat PT PELNI (Persero) — pelni.co.id
class AppColors {
  AppColors._();

  // ─── Brand Utama PELNI ────────────────────────────────────────────────────
  static const Color pelniNavy = Color(0xFF1A3B70);       // Biru tua korporat utama
  static const Color pelniNavyDark = Color(0xFF0F2650);   // Hover/pressed state navy
  static const Color pelniSkyBlue = Color(0xFF0284C7);    // Biru laut sekunder/aksen
  static const Color pelniOrange = Color(0xFFEA580C);     // Aksen peringatan / CTA interaksi

  // ─── Surface & Background (Light Theme) ──────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);     // Putih bersih kartu & drawer
  static const Color canvasBg = Color(0xFFF1F5F9);         // Cool Technical Slate – latar kanvas denah
  static const Color surfaceCard = Color(0xFFF8FAFC);      // Slate 50 – kartu informasi
  static const Color surfaceMuted = Color(0xFFE2E8F0);     // Slate 200 – zona abu netral

  // ─── Border ───────────────────────────────────────────────────────────────
  static const Color borderColor = Color(0xFFE2E8F0);      // Slate 200 – border halus
  static const Color borderStrong = Color(0xFFCBD5E1);     // Slate 300 – border kuat

  // ─── Teks (pada Light Theme) ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);       // Slate 900 – teks utama gelap
  static const Color textSecondary = Color(0xFF475569);     // Slate 600 – teks sekunder
  static const Color textMuted = Color(0xFF94A3B8);         // Slate 400 – teks redup/placeholder
  static const Color textOnDark = Color(0xFFFFFFFF);        // Teks putih di atas latar gelap/navy

  // ─── Status Pin Kerusakan (Standar Maritim PELNI) ─────────────────────────
  static const Color statusOpen = Color(0xFFDC2626);              // OPEN: Safety Red
  static const Color statusOpenBg = Color(0xFFFEF2F2);           // Latar badge open
  static const Color statusOpenBorder = Color(0xFFFECACA);        // Border badge open

  static const Color statusInProgress = Color(0xFFD97706);        // IN_PROGRESS: Amber Warning
  static const Color statusInProgressBg = Color(0xFFFFFBEB);
  static const Color statusInProgressBorder = Color(0xFFFDE68A);

  static const Color statusWaitingApproval = Color(0xFF0284C7);   // WAITING_APPROVAL: PELNI Blue
  static const Color statusWaitingApprovalBg = Color(0xFFEFF6FF);
  static const Color statusWaitingApprovalBorder = Color(0xFFBFDBFE);

  static const Color statusApproved = Color(0xFF059669);          // APPROVED: Spruce Emerald
  static const Color statusApprovedBg = Color(0xFFECFDF5);
  static const Color statusApprovedBorder = Color(0xFFA7F3D0);

  // ─── Pelni Navy Tints (untuk komponen di atas putih) ─────────────────────
  static const Color pelniNavyBg = Color(0xFFEFF4FC);        // Tint latar navy sangat muda
  static const Color pelniOrangeBg = Color(0xFFFFF7ED);      // Tint latar orange
}
