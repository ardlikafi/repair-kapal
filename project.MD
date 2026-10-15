LANGUAGE RULE:
- All communications with the developer must be conducted in Bahasa Indonesia.
- All application UI labels, status text, and buttons must be in professional formal Bahasa Indonesia (Maritime standard).

# SYSTEM ARCHITECTURE & CODING PROMPT: PELNI VESSEL REPAIR & DEFECT TRACKER (POC)

You are a Senior Flutter & Supabase Systems Architect specializing in industrial enterprise maritime software.
We are developing a high-utility Mobile/Tablet POC for PT PELNI (Indonesian National Shipping Company) to monitor drydock repairs across multiple third-party vendors.

A previous prototype was REJECTED by the General Manager due to:
1. Cramped canvas (blueprint floating inside tiny padded cards).
2. Nested scrollbar modals for issue details.
3. Vague 0-100% manual sliders instead of verified technical checklists.
4. Generic "AI Slop" aesthetics (oversized round corners, pastel wash, zero industrial utility).

Your task is to build a rock-solid, production-grade Flutter + Supabase solution that fixes all of the above.

---

## 1. DESIGN SYSTEM: "INDUSTRIAL MARITIME SPECIFICATION"
Strictly implement these styling rules to prevent AI Slop:
- Color Palette:
  * Primary Canvas/Sidebar: Dark Steel Navy (#0A192F or #0E1E2E)
  * Surface/Card: Pure White (#FFFFFF) and Cool Technical Slate (#F8FAFC)
  * Subtle Lines & Borders: Technical Gray (#E2E8F0)
  * Action/CTA: PELNI Amber (#D97706 or #B45309)
  * Pin Status Colors:
    - OPEN (Defect Reported): Safety Red (#DC2626)
    - IN_PROGRESS: Amber Warning (#F59E0B)
    - WAITING_APPROVAL: Cobalt Blue (#2563EB)
    - APPROVED_CLOSED: Dockyard Emerald (#059669)
- Geometry: Maximum border radius is 6px (NO 24px+ round pill shapes).
- Typography: Utilitarian Sans (e.g., Roboto / Plus Jakarta) + Monospace (JetBrains / Roboto Mono) for Tag IDs (e.g., [PIN-084]) and Coordinates.
- Layout Principle: FULL-BLEED WORKSPACE. The ship blueprint must take 100% of the canvas area. When a pin is selected, open a crisp SIDE DRAWER (or Bottom Sheet on small phones), NEVER a nested modal with scrollbars.

---

## 2. PIN COORDINATE SYSTEM (MATHEMATICAL RULE)
To ensure pins never shift when resized or viewed on different screen ratios:
- Store coordinates as NORMALIZED FLOATS (0.000 to 1.000) relative to the original image dimensions.
  * normalized_x = tap_x / rendered_image_width
  * normalized_y = tap_y / rendered_image_height
- Rendering formula on dynamic canvas:
  * pin_screen_x = normalized_x * current_canvas_width
  * pin_screen_y = normalized_y * current_canvas_height
- Canvas MUST support smooth infinite pan & zoom using Flutter's `InteractiveViewer`.

---

## 3. SUPABASE DATABASE SPECIFICATION (SQL)
Generate the complete SQL migration script with RLS disabled for POC:

-- Tables:
1. `vessels` (id uuid pk, name text, imo_number text, blueprint_url text)
2. `vendors` (id uuid pk, company_name text, trade_zone text [e.g., 'Hull Sandblasting', 'Engine Overhaul', 'Deck Carpentry'], color_hex text)
3. `defect_hotspots`:
   - id (uuid pk)
   - vessel_id (fk vessels)
   - vendor_id (fk vendors)
   - pin_code text (e.g., 'CARDECK-01')
   - deck_zone text (e.g., 'Main Cardeck Stern')
   - norm_x double precision (0.0 to 1.0)
   - norm_y double precision (0.0 to 1.0)
   - status text (CHECK: 'OPEN', 'IN_PROGRESS', 'WAITING_APPROVAL', 'APPROVED')
   - description text
   - before_photo_url text
   - after_photo_url text
   - inspector_notes text
   - created_at timestamp with time zone default now()

Include mock seeding data:
- 1 Vessel: "KMP Nusa Bhakti" (Provide a reliable fallback CAD/Ship vector image URL like: https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=1200 or an embedded high-contrast SVG schematic).
- 3 Vendors: "PT Galangan Bahari (Hull)", "PT Dieselindo Utama (Engine)", "PT Karya Baja (Deck)".
- 4 Hotspots distributed realistically across the vessel profile with different statuses.

---

## 4. FLUTTER IMPLEMENTATION REQUIREMENTS
Structure the app using clean, feature-first modular architecture:

### Core Screens & Components:
1. `WorkspaceView`:
   - Top Bar: Vessel Name, Stats Counter (Total, Open, Review, Done), Multi-Vendor Filter dropdown.
   - Main Area: Full-screen `InteractiveViewer` containing the ship schematic.
   - Pinned Markers: High-contrast circular badges displaying the Vendor's colored ring and the status icon. Pulsing effect for 'WAITING_APPROVAL'.
   - Tap Blank Canvas: Open quick-create pin dialogue (captures tapped norm_x, norm_y).
   - Tap Pin: Trigger Right-Side Inspection Drawer (`InspectionDrawer`).

2. `InspectionDrawer` (Replaces the rejected modal):
   - Header: [PIN-CODE], Status Badge, Vendor badge.
   - Section 1: Defect Description & Deck Location.
   - Section 2: Before & After Photo Side-by-Side Comparator.
   - Section 3: Dual Action Bar (Role-based):
     * If Vendor: Button to "Upload After Photo" -> Move to 'WAITING_APPROVAL'.
     * If PELNI Inspector/GM: Prominent [REJECT] and [APPROVE REPAIR] action buttons.

---

## EXECUTION ORDER:
Proceed with Step 1 immediately:
1. Output the complete, copy-pasteable Supabase SQL Migration (Schema + Sample Data).
2. Scaffold the Flutter Clean Architecture structure and write the `InteractiveCanvasWidget` with normalized coordinate tagging logic.