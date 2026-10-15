import 'package:flutter/foundation.dart';
import '../../data/repositories/defect_repository_impl.dart';
import '../../domain/entities/defect_hotspot.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/entities/vessel.dart';
import '../../domain/entities/vessel_deck.dart';

/// ID kapal aktif POC — KMP Nusa Bhakti (sesuai data seeding SQL)
const String kActiveVesselId = 'e5a1b32d-8f90-4c3e-9012-78d10b710001';

enum WorkspaceLoadState { idle, loading, loaded, error }

class WorkspaceController extends ChangeNotifier {
  final DefectRepositoryImpl _repo;

  WorkspaceController({required DefectRepositoryImpl repository})
      : _repo = repository;

  // ─── State ─────────────────────────────────────────────────────────────────
  WorkspaceLoadState _loadState = WorkspaceLoadState.idle;
  WorkspaceLoadState get loadState => _loadState;

  Vessel? _vessel;
  Vessel? get vessel => _vessel;

  List<Vendor> _vendors = [];
  List<Vendor> get vendors => _vendors;

  List<DefectHotspot> _allHotspots = [];
  List<DefectHotspot> _filteredHotspots = [];
  List<DefectHotspot> get hotspots => _filteredHotspots;
  List<DefectHotspot> get allHotspots => _allHotspots;

  DefectHotspot? _selectedHotspot;
  DefectHotspot? get selectedHotspot => _selectedHotspot;

  String? _filterVendorId; // null = tampilkan semua vendor
  String? get filterVendorId => _filterVendorId;

  VesselDeck _selectedDeck = VesselDeck.profile;
  VesselDeck get selectedDeck => _selectedDeck;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── Statistik Dashboard Top Bar ──────────────────────────────────────────
  int get totalHotspots => _allHotspots.length;
  int get countOpen => _allHotspots.where((h) => h.status == DefectStatus.open).length;
  int get countInProgress => _allHotspots.where((h) => h.status == DefectStatus.inProgress).length;
  int get countWaitingApproval => _allHotspots.where((h) => h.status == DefectStatus.waitingApproval).length;
  int get countApproved => _allHotspots.where((h) => h.status == DefectStatus.approved).length;

  // ─── Inisialisasi Data ─────────────────────────────────────────────────────
  Future<void> initialize() async {
    _loadState = WorkspaceLoadState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repo.getVesselById(kActiveVesselId),
        _repo.getVendors(),
        _repo.getHotspotsByVesselId(kActiveVesselId),
      ]);

      _vessel = results[0] as Vessel;
      _vendors = results[1] as List<Vendor>;
      _allHotspots = results[2] as List<DefectHotspot>;

      _applyFilter();
      _loadState = WorkspaceLoadState.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat data: ${e.toString()}';
      _loadState = WorkspaceLoadState.error;
      debugPrint('[WorkspaceController] ERROR: $e');
    }

    notifyListeners();
  }

  // ─── Filter Vendor & Deck Switcher ─────────────────────────────────────────
  void setVendorFilter(String? vendorId) {
    _filterVendorId = vendorId;
    _applyFilter();
    notifyListeners();
  }

  void selectDeck(VesselDeck deck) {
    if (_selectedDeck == deck) return;
    _selectedDeck = deck;
    _applyFilter();
    notifyListeners();
  }

  int countHotspotsForDeck(VesselDeck deck) {
    return _allHotspots.where((h) {
      if (_filterVendorId != null && h.vendorId != _filterVendorId) {
        return false;
      }
      switch (deck) {
        case VesselDeck.profile:
          return true;
        case VesselDeck.mainDeck:
          final zone = h.deckZone.toLowerCase();
          final code = h.pinCode.toUpperCase();
          return zone.contains('cardeck') ||
              zone.contains('main') ||
              zone.contains('engine') ||
              code.startsWith('CARDECK') ||
              code.startsWith('ENG');
        case VesselDeck.bridgeDeck:
          final zone = h.deckZone.toLowerCase();
          final code = h.pinCode.toUpperCase();
          return zone.contains('bridge') ||
              zone.contains('navigation') ||
              zone.contains('anjungan') ||
              code.startsWith('BRG');
      }
    }).length;
  }

  void _applyFilter() {
    _filteredHotspots = _allHotspots.where((h) {
      // 1. Filter Vendor
      if (_filterVendorId != null && h.vendorId != _filterVendorId) {
        return false;
      }

      // 2. Filter Deck
      switch (_selectedDeck) {
        case VesselDeck.profile:
          return true;
        case VesselDeck.mainDeck:
          final zone = h.deckZone.toLowerCase();
          final code = h.pinCode.toUpperCase();
          return zone.contains('cardeck') ||
              zone.contains('main') ||
              zone.contains('engine') ||
              code.startsWith('CARDECK') ||
              code.startsWith('ENG');
        case VesselDeck.bridgeDeck:
          final zone = h.deckZone.toLowerCase();
          final code = h.pinCode.toUpperCase();
          return zone.contains('bridge') ||
              zone.contains('navigation') ||
              zone.contains('anjungan') ||
              code.startsWith('BRG');
      }
    }).toList();

    if (_selectedHotspot != null &&
        !_filteredHotspots.any((h) => h.id == _selectedHotspot!.id)) {
      _selectedHotspot = null;
    }
  }

  // ─── Seleksi Pin ───────────────────────────────────────────────────────────
  void selectHotspot(DefectHotspot hotspot) {
    _selectedHotspot = hotspot;
    notifyListeners();
  }

  void clearSelection() {
    _selectedHotspot = null;
    notifyListeners();
  }

  // ─── Aksi Inspektur / GM ───────────────────────────────────────────────────
  Future<void> approveHotspot(String hotspotId) async {
    await _updateStatus(hotspotId, DefectStatus.approved);
  }

  Future<void> rejectHotspot(String hotspotId) async {
    await _updateStatus(hotspotId, DefectStatus.inProgress);
  }

  Future<void> submitForApproval(String hotspotId) async {
    await _updateStatus(hotspotId, DefectStatus.waitingApproval);
  }

  Future<void> changeStatus(String hotspotId, DefectStatus newStatus) => _updateStatus(hotspotId, newStatus);

  Future<void> _updateStatus(String hotspotId, DefectStatus newStatus) async {
    final idx = _allHotspots.indexWhere((h) => h.id == hotspotId);
    if (idx == -1) return;

    final updated = _allHotspots[idx].copyWith(status: newStatus);
    try {
      final saved = await _repo.updateHotspot(updated);
      _allHotspots[idx] = saved;

      if (_selectedHotspot?.id == hotspotId) {
        _selectedHotspot = saved;
      }
      _applyFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('[WorkspaceController] Error updateStatus: $e');
    }
  }

  // ─── Tambah Hotspot Baru (Quick Add Pin & Tap Kanvas) ──────────────────────
  Future<void> createHotspot(DefectHotspot draft) async {
    try {
      final saved = await _repo.createHotspot(draft);
      _allHotspots.add(saved);
      _applyFilter();
      _selectedHotspot = saved;
      notifyListeners();
    } catch (e) {
      debugPrint('[WorkspaceController] createHotspot fallback: $e');
      _allHotspots.add(draft);
      _applyFilter();
      _selectedHotspot = draft;
      notifyListeners();
    }
  }
}
