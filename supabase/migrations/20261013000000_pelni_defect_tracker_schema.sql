-- ==============================================================================
-- SISTEM PELACAK PERBAIKAN & DEFECT KAPAL PT PELNI (POC)
-- Skrip Migrasi Skema Basis Data & Data Awal (Dummy Seeding)
-- Target Platform: Supabase PostgreSQL
-- ==============================================================================

-- 1. BERSIHKAN TABEL SEBELUMNYA (JIKA ADA)
DROP TABLE IF EXISTS public.defect_hotspots CASCADE;
DROP TABLE IF EXISTS public.vendors CASCADE;
DROP TABLE IF EXISTS public.vessels CASCADE;

-- Aktifkan ekstensi UUID (pgcrypto atau uuid-ossp) jika belum aktif
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================================================
-- 2. STRUKTUR TABEL
-- ==============================================================================

-- Tabel 1: vessels (Data Kapal Armada PELNI)
CREATE TABLE public.vessels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    imo_number TEXT NOT NULL UNIQUE,
    blueprint_url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

COMMENT ON TABLE public.vessels IS 'Daftar armada kapal PELNI yang sedang dalam proses docking/perbaikan.';
COMMENT ON COLUMN public.vessels.blueprint_url IS 'URL skematik/blueprint CAD profil kapal resolusi tinggi untuk kanvas penandaan.';

-- Tabel 2: vendors (Mitra Galangan / Vendor Spesialis Pengerjaan)
CREATE TABLE public.vendors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name TEXT NOT NULL,
    trade_zone TEXT NOT NULL, -- e.g., 'Hull Sandblasting', 'Engine Overhaul', 'Deck Carpentry'
    color_hex TEXT NOT NULL,  -- e.g., '#2563EB', '#DC2626', '#D97706'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

COMMENT ON TABLE public.vendors IS 'Mitra galangan & sub-kontraktor teknis dengan zona keahlian dan kode warna identifikasi.';

-- Tabel 3: defect_hotspots (Titik Temuan Defect / Hotspot Koordinat Normal)
CREATE TABLE public.defect_hotspots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vessel_id UUID NOT NULL REFERENCES public.vessels(id) ON DELETE CASCADE,
    vendor_id UUID NOT NULL REFERENCES public.vendors(id) ON DELETE RESTRICT,
    pin_code TEXT NOT NULL,                                  -- e.g., 'CARDECK-01', 'ENG-04'
    deck_zone TEXT NOT NULL,                                 -- e.g., 'Main Cardeck Stern'
    norm_x DOUBLE PRECISION NOT NULL,                        -- Normalisasi 0.0000 - 1.0000
    norm_y DOUBLE PRECISION NOT NULL,                        -- Normalisasi 0.0000 - 1.0000
    status TEXT NOT NULL,                                    -- 'OPEN', 'IN_PROGRESS', 'WAITING_APPROVAL', 'APPROVED'
    description TEXT NOT NULL,
    before_photo_url TEXT,
    after_photo_url TEXT,
    inspector_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

    -- Validasi Koordinat dan Status
    CONSTRAINT chk_defect_norm_x CHECK (norm_x >= 0.0 AND norm_x <= 1.0),
    CONSTRAINT chk_defect_norm_y CHECK (norm_y >= 0.0 AND norm_y <= 1.0),
    CONSTRAINT chk_defect_status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'WAITING_APPROVAL', 'APPROVED'))
);

COMMENT ON TABLE public.defect_hotspots IS 'Titik koordinat temuan kerusakan pada denah kapal beserta status perbaikan dan bukti foto.';
COMMENT ON COLUMN public.defect_hotspots.norm_x IS 'Posisi horizontal ternormalisasi (0.0000 s/d 1.0000) relatif terhadap lebar blueprint.';
COMMENT ON COLUMN public.defect_hotspots.norm_y IS 'Posisi vertikal ternormalisasi (0.0000 s/d 1.0000) relatif terhadap tinggi blueprint.';

-- ==============================================================================
-- 3. PENGATURAN INDEKS & PERFORMA
-- ==============================================================================
CREATE INDEX idx_defect_hotspots_vessel_id ON public.defect_hotspots(vessel_id);
CREATE INDEX idx_defect_hotspots_vendor_id ON public.defect_hotspots(vendor_id);
CREATE INDEX idx_defect_hotspots_status ON public.defect_hotspots(status);
CREATE INDEX idx_defect_hotspots_pin_code ON public.defect_hotspots(pin_code);

-- ==============================================================================
-- 4. KEBIJAKAN KEAMANAN (RLS - ROW LEVEL SECURITY)
-- Catatan POC: Sesuai spesifikasi proyek, RLS dinonaktifkan untuk pengujian cepat.
-- ==============================================================================
ALTER TABLE public.vessels DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendors DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.defect_hotspots DISABLE ROW LEVEL SECURITY;

-- Tambahkan publikasi realtime Supabase agar perubahan pin langsung tersinkronisasi di mobile/tablet
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.defect_hotspots;
    END IF;
END $$;

-- ==============================================================================
-- 5. DATA AWAL (MOCK SEEDING DATA)
-- ==============================================================================

-- ID Statis untuk relasi deterministik
DO $$
DECLARE
    v_vessel_id UUID := 'e5a1b32d-8f90-4c3e-9012-78d10b710001';
    v_vendor_hull UUID := 'd1a2b3c4-0001-4000-8000-000000000001';
    v_vendor_engine UUID := 'd1a2b3c4-0002-4000-8000-000000000002';
    v_vendor_deck UUID := 'd1a2b3c4-0003-4000-8000-000000000003';
BEGIN
    -- 5.1 Seed Kapal PELNI: KMP Nusa Bhakti
    INSERT INTO public.vessels (id, name, imo_number, blueprint_url)
    VALUES (
        v_vessel_id,
        'KMP Nusa Bhakti',
        'IMO 9128362',
        -- Skematik Blueprint kapal profil teknis resolusi tinggi
        'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=1600&auto=format&fit=crop&q=80'
    );

    -- 5.2 Seed 3 Vendor Galangan & Spesialis Teknis
    INSERT INTO public.vendors (id, company_name, trade_zone, color_hex)
    VALUES
        (
            v_vendor_hull,
            'PT Galangan Bahari (Hull)',
            'Hull Sandblasting & Coating',
            '#2563EB' -- Cobalt Blue
        ),
        (
            v_vendor_engine,
            'PT Dieselindo Utama (Engine)',
            'Engine Overhaul & Piping Systems',
            '#DC2626' -- Safety Red / Crimson
        ),
        (
            v_vendor_deck,
            'PT Karya Baja (Deck)',
            'Deck Carpentry & Structural Steel',
            '#D97706' -- PELNI Industrial Amber
        );

    -- 5.3 Seed 4 Hotspot Defect Realistis Melintasi Profil Kapal
    -- Titik 1: CARDECK-01 (Status: OPEN - Safety Red)
    INSERT INTO public.defect_hotspots (
        id, vessel_id, vendor_id, pin_code, deck_zone,
        norm_x, norm_y, status, description,
        before_photo_url, after_photo_url, inspector_notes
    ) VALUES (
        'f1111111-0001-4000-8000-000000000001',
        v_vessel_id,
        v_vendor_deck,
        'CARDECK-01',
        'Main Cardeck Stern (Frame 12-18)',
        0.2650,
        0.5820,
        'OPEN',
        'Pelat geladak aus korosi piting >35% pada area lintasan roda ramp door buritan. Perlu pemotongan plat (cropping) dan replating baja marine grade ketebalan 12mm sesuai standar klasifikasi BKI.',
        'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=900&auto=format&fit=crop&q=80',
        NULL,
        'Temuan prioritas tinggi. Wajib diselesaikan sebelum pengujian beban ramp door akhir pekan ini.'
    );

    -- Titik 2: ENG-04 (Status: IN_PROGRESS - Amber Warning)
    INSERT INTO public.defect_hotspots (
        id, vessel_id, vendor_id, pin_code, deck_zone,
        norm_x, norm_y, status, description,
        before_photo_url, after_photo_url, inspector_notes
    ) VALUES (
        'f1111111-0002-4000-8000-000000000002',
        v_vessel_id,
        v_vendor_engine,
        'ENG-04',
        'Lower Engine Room Deck 2 (Auxiliary Engine PS)',
        0.4420,
        0.7250,
        'IN_PROGRESS',
        'Kebocoran pada sambungan flange pipa pendingin sea chest bantu utama sisi kiri (Portside). Stud bolt mengalami korosi berat dan paking karet aus tergerus air laut.',
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=900&auto=format&fit=crop&q=80',
        NULL,
        'Tahap pembongkaran flange sedang berlangsung oleh tim PT Dieselindo Utama. Penggantian stud bolt SS316 dan paking teflon dalam proses instalasi.'
    );

    -- Titik 3: HULL-12 (Status: WAITING_APPROVAL - Cobalt Blue, Pulsing)
    INSERT INTO public.defect_hotspots (
        id, vessel_id, vendor_id, pin_code, deck_zone,
        norm_x, norm_y, status, description,
        before_photo_url, after_photo_url, inspector_notes
    ) VALUES (
        'f1111111-0003-4000-8000-000000000003',
        v_vessel_id,
        v_vendor_hull,
        'HULL-12',
        'Bulbous Bow & Forepeak Shell Plate (Starboard)',
        0.8350,
        0.6650,
        'WAITING_APPROVAL',
        'Lekukan (indentation) pada lambung haluan sisi kanan akibat benturan dermaga. Pekerjaan blasting standar Sa 2.5, fairing plat, dan pelapisan anti-fouling epoxy primer telah rampung.',
        'https://images.unsplash.com/photo-1505705694340-019e1e335916?w=900&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=900&auto=format&fit=crop&q=80',
        'Pihak PT Galangan Bahari telah mengajukan permohonan verifikasi. Menunggu persetujuan inspeksi visual lapangan dan pengukuran ketebalan cat (DFT test) oleh Superintendent PELNI.'
    );

    -- Titik 4: BRG-02 (Status: APPROVED - Dockyard Emerald)
    INSERT INTO public.defect_hotspots (
        id, vessel_id, vendor_id, pin_code, deck_zone,
        norm_x, norm_y, status, description,
        before_photo_url, after_photo_url, inspector_notes
    ) VALUES (
        'f1111111-0004-4000-8000-000000000004',
        v_vessel_id,
        v_vendor_deck,
        'BRG-02',
        'Navigation Bridge Wing Portside (Weather Deck)',
        0.6280,
        0.2850,
        'APPROVED',
        'Handle dan engsel pintu kedap cuaca (weathertight door) anjungan sisi kiri macet parah serta karet seal getas pecah-pecah sehingga berpotensi rembes saat ombak tinggi.',
        'https://images.unsplash.com/photo-1578328819058-b69f3a3b0f6b?w=900&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=900&auto=format&fit=crop&q=80',
        'Pekerjaan overhaul engsel, pelumasan marine grease, dan penggantian rubber gasket selesai. Uji semprot air bertekanan (hose test) dinyatakan kedap 100%. Disetujui dan ditutup oleh Superintendent GM PELNI.'
    );

END $$;
