import '../entities/defect_hotspot.dart';
import '../entities/vendor.dart';
import '../entities/vessel.dart';

/// Kontrak Repositori Defect & Monitoring Galangan Kapal
abstract class DefectRepository {
  /// Mengambil data kapal aktif berdasarkan ID
  Future<Vessel> getVesselById(String vesselId);

  /// Mengambil semua vendor galangan
  Future<List<Vendor>> getVendors();

  /// Mengambil semua daftar titik defect untuk kapal tertentu
  Future<List<DefectHotspot>> getHotspotsByVesselId(String vesselId);

  /// Menambah titik hotspot baru
  Future<DefectHotspot> createHotspot(DefectHotspot hotspot);

  /// Memperbarui status dan data hotspot (misal: upload foto selesai, approve, reject)
  Future<DefectHotspot> updateHotspot(DefectHotspot hotspot);

  /// Menghapus titik hotspot
  Future<void> deleteHotspot(String hotspotId);

  /// Aliran data realtime untuk pembaruan pin defect secara langsung
  Stream<List<DefectHotspot>> streamHotspotsByVesselId(String vesselId);
}
