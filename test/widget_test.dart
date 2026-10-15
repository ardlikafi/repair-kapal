import 'package:flutter_test/flutter_test.dart';
import 'package:pelni_defect_tracker/features/defect_workspace/data/datasources/defect_remote_datasource.dart';
import 'package:pelni_defect_tracker/features/defect_workspace/data/repositories/defect_repository_impl.dart';
import 'package:pelni_defect_tracker/features/defect_workspace/presentation/controllers/workspace_controller.dart';
import 'package:pelni_defect_tracker/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('PelniDefectTrackerApp smoke test', (WidgetTester tester) async {
    // Inisialisasi Supabase dummy untuk unit test
    await Supabase.initialize(
      url: 'https://placeholder-pelni-drydock.supabase.co',
      // ignore: deprecated_member_use
      anonKey: 'test-key',
    );

    final dataSource =
        DefectSupabaseDataSourceImpl(supabaseClient: Supabase.instance.client);
    final repository = DefectRepositoryImpl(remoteDataSource: dataSource);
    final controller = WorkspaceController(repository: repository);

    await tester.pumpWidget(PelniDefectTrackerApp(controller: controller));
    await tester.pump();

    // Verifikasi app dapat dirender tanpa crash
    expect(find.byType(PelniDefectTrackerApp), findsOneWidget);
  });
}
