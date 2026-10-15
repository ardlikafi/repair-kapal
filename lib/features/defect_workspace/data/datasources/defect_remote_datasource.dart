import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/defect_hotspot_model.dart';
import '../models/vendor_model.dart';
import '../models/vessel_model.dart';

abstract class DefectRemoteDataSource {
  Future<VesselModel> fetchVessel(String vesselId);
  Future<List<VendorModel>> fetchVendors();
  Future<List<DefectHotspotModel>> fetchHotspots(String vesselId);
  Future<DefectHotspotModel> insertHotspot(DefectHotspotModel model);
  Future<DefectHotspotModel> updateHotspot(DefectHotspotModel model);
  Future<void> deleteHotspot(String hotspotId);
  Stream<List<DefectHotspotModel>> streamHotspots(String vesselId);
}

/// Implementasi Remote Data Source dengan Supabase Client
class DefectSupabaseDataSourceImpl implements DefectRemoteDataSource {
  final SupabaseClient supabaseClient;

  DefectSupabaseDataSourceImpl({required this.supabaseClient});

  @override
  Future<VesselModel> fetchVessel(String vesselId) async {
    final response = await supabaseClient
        .from('vessels')
        .select()
        .eq('id', vesselId)
        .single();
    return VesselModel.fromJson(response);
  }

  @override
  Future<List<VendorModel>> fetchVendors() async {
    final response = await supabaseClient
        .from('vendors')
        .select()
        .order('company_name');
    final list = response as List<dynamic>;
    return list.map((item) => VendorModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<DefectHotspotModel>> fetchHotspots(String vesselId) async {
    final response = await supabaseClient
        .from('defect_hotspots')
        .select('*, vendors(*)')
        .eq('vessel_id', vesselId)
        .order('created_at');
    final list = response as List<dynamic>;
    return list.map((item) => DefectHotspotModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<DefectHotspotModel> insertHotspot(DefectHotspotModel model) async {
    final payload = model.toJson()..remove('created_at')..remove('updated_at');
    final response = await supabaseClient
        .from('defect_hotspots')
        .insert(payload)
        .select('*, vendors(*)')
        .single();
    return DefectHotspotModel.fromJson(response);
  }

  @override
  Future<DefectHotspotModel> updateHotspot(DefectHotspotModel model) async {
    final payload = model.toJson()
      ..remove('created_at')
      ..['updated_at'] = DateTime.now().toUtc().toIso8601String();

    final response = await supabaseClient
        .from('defect_hotspots')
        .update(payload)
        .eq('id', model.id)
        .select('*, vendors(*)')
        .single();
    return DefectHotspotModel.fromJson(response);
  }

  @override
  Future<void> deleteHotspot(String hotspotId) async {
    await supabaseClient
        .from('defect_hotspots')
        .delete()
        .eq('id', hotspotId);
  }

  @override
  Stream<List<DefectHotspotModel>> streamHotspots(String vesselId) {
    return supabaseClient
        .from('defect_hotspots')
        .stream(primaryKey: ['id'])
        .eq('vessel_id', vesselId)
        .map((rows) => rows.map((r) => DefectHotspotModel.fromJson(r)).toList());
  }
}
