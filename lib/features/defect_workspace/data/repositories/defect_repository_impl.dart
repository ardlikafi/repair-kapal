import '../../domain/entities/defect_hotspot.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/entities/vessel.dart';
import '../../domain/repositories/defect_repository.dart';
import '../datasources/defect_remote_datasource.dart';
import '../models/defect_hotspot_model.dart';

/// Implementasi Repositori Defect
class DefectRepositoryImpl implements DefectRepository {
  final DefectRemoteDataSource remoteDataSource;

  DefectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Vessel> getVesselById(String vesselId) async {
    return await remoteDataSource.fetchVessel(vesselId);
  }

  @override
  Future<List<Vendor>> getVendors() async {
    return await remoteDataSource.fetchVendors();
  }

  @override
  Future<List<DefectHotspot>> getHotspotsByVesselId(String vesselId) async {
    return await remoteDataSource.fetchHotspots(vesselId);
  }

  @override
  Future<DefectHotspot> createHotspot(DefectHotspot hotspot) async {
    final model = DefectHotspotModel(
      id: hotspot.id,
      vesselId: hotspot.vesselId,
      vendorId: hotspot.vendorId,
      pinCode: hotspot.pinCode,
      deckZone: hotspot.deckZone,
      normX: hotspot.normX,
      normY: hotspot.normY,
      status: hotspot.status,
      description: hotspot.description,
      beforePhotoUrl: hotspot.beforePhotoUrl,
      afterPhotoUrl: hotspot.afterPhotoUrl,
      inspectorNotes: hotspot.inspectorNotes,
      vendor: hotspot.vendor,
    );
    return await remoteDataSource.insertHotspot(model);
  }

  @override
  Future<DefectHotspot> updateHotspot(DefectHotspot hotspot) async {
    final model = DefectHotspotModel(
      id: hotspot.id,
      vesselId: hotspot.vesselId,
      vendorId: hotspot.vendorId,
      pinCode: hotspot.pinCode,
      deckZone: hotspot.deckZone,
      normX: hotspot.normX,
      normY: hotspot.normY,
      status: hotspot.status,
      description: hotspot.description,
      beforePhotoUrl: hotspot.beforePhotoUrl,
      afterPhotoUrl: hotspot.afterPhotoUrl,
      inspectorNotes: hotspot.inspectorNotes,
      vendor: hotspot.vendor,
    );
    return await remoteDataSource.updateHotspot(model);
  }

  @override
  Future<void> deleteHotspot(String hotspotId) async {
    await remoteDataSource.deleteHotspot(hotspotId);
  }

  @override
  Stream<List<DefectHotspot>> streamHotspotsByVesselId(String vesselId) {
    return remoteDataSource.streamHotspots(vesselId);
  }
}
