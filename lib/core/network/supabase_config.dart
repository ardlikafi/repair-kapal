import 'package:supabase_flutter/supabase_flutter.dart';

/// Konfigurasi Klien Supabase untuk Lingkungan Proyek PELNI
/// Kredensial dibaca secara aman dari environment variable (--dart-define-from-file=.env)
class SupabaseConfig {
  SupabaseConfig._();

  // Pengaturan URL & Kunci Anonim Supabase (Aman dari publikasi GitHub)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://placeholder-project.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'placeholder-anon-key',
  );

  /// Getter Supabase Client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Inisialisasi awal Supabase SDK
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: supabaseAnonKey,
      );
    } catch (e) {
      // Fallback aman untuk mode offline / environment placeholder
    }
  }
}
