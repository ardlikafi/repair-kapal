# PELNI Docking Monitoring System (PDMS) • repair-kapal

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![Status](https://img.shields.io/badge/Build-Enterprise%20POC%20v1.0.0-1A3B70)]()

Sistem Pemantauan Perbaikan & Pengedokan Terintegrasi untuk Divisi Armada dan Teknik **PT Pelayaran Nasional Indonesia (Persero)**. Dirancang khusus untuk memonitor pengerjaan drydocking kapal komersial melintasi galangan mitra secara terpusat, realtime, dan bebas dari *AI slop*.

---

## ⚓ Fitur & Modul Utama

1. **Corporate Splash Screen (`lib/features/splash/`)**
   - Latar belakang Deep PELNI Navy (`#1A3B70`) dengan logo resmi dan transisi halus ke Application Shell.
2. **Persistent Global Navbar (`lib/features/shell/`)**
   - Navbar atas enterprise seragam dengan navigasi tab:
     - 📊 **Dashboard Eksekutif**: Ringkasan armada, KPI pengerjaan, katalog kapal aktif.
     - 🚢 **Armada Aktif**: Kanvas denah kapal Full-Bleed GA Plan, Deck Switcher, dan pemetaan defect.
     - 📑 **Riwayat Service & Dok**: Arsip tabel data padat kapal yang telah selesai docking.
     - 📈 **Laporan Tahunan**: Ringkasan analitik anggaran, efisiensi SLA, dan matriks kinerja galangan untuk GM PELNI (Pak Rian).
     - Indikator akun resmi Superintendent GM PELNI dan dialog keamanan sesi.
3. **Interactive CAD Drafting Sheet & Deck Switcher (`lib/features/defect_workspace/`)**
   - Kanvas cetak biru teknik berbingkai CAD dengan bayangan halus.
   - Pilihan zona geladak: **Tampak Samping (Profile)**, **Geladak Utama (Main Deck)**, dan **Anjungan (Bridge Deck)**.
   - Sinkronisasi otomatis skematik denah dan filter titik defect.
4. **Modul Berita Acara & Ekspor PDF (`DockingReportDialog`)**
   - Kop surat resmi BUMN PT PELNI (Persero).
   - Rekapitulasi tabel seluruh temuan kerusakan per zona dek dan vendor.
   - Kotak tanda tangan & stempel digital untuk Superintendent GM PELNI dan Kepala Proyek Galangan Mitra.
5. **Quick Add Pin Lapangan (`AddHotspotDialog`)**
   - Pendaftaran titik temuan baru langsung dari lapangan dengan penugasan vendor dan foto dokumentasi awal.

---

## 🛠️ Panduan Memulai & Konfigurasi Lingkungan (Keamanan Kredensial)

Untuk menjaga keamanan kredensial database agar **tidak terpublikasi ke publik**, sistem ini menggunakan konfigurasi berbasis environment (`.env`).

### 1. Salin Berkas Konfigurasi Lingkungan
```bash
cp .env.example .env
```

### 2. Isi Kredensial Supabase Anda di `.env`
Buka file `.env` dan masukkan URL serta Anon Key Supabase:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key-here
```
> *Catatan: File `.env` telah didaftarkan dalam `.gitignore` sehingga aman dan tidak akan ter-commit ke repositori Git.*

### 3. Jalankan Aplikasi
Gunakan flag `--dart-define-from-file=.env` agar Flutter otomatis membaca variabel lingkungan:

```bash
# Jalankan di Google Chrome (Web)
flutter run -d chrome --dart-define-from-file=.env

# Jalankan di Desktop Windows
flutter run -d windows --dart-define-from-file=.env
```

---

## 📐 Standar Desain Resmi PELNI
- **Palet Warna**:
  - `pelniNavy`: `#1A3B70` (Biru Tua Korporat Utama)
  - `pelniSkyBlue`: `#0284C7` (Biru Laut Sekunder)
  - `pelniOrange`: `#EA580C` (Aksen Peringatan / Interaksi)
  - `canvasBg`: `#F1F5F9` (Cool Technical Slate)
- **Geometri**: Sudut tegas maksimal 6px (`BorderRadius.circular(6)`).
- **Tipografi**: Bersih, tegas, profesional standar maritim BUMN.

---
© 2026 PT Pelayaran Nasional Indonesia (Persero) • Hak Cipta Dilindungi Undang-Undang.
