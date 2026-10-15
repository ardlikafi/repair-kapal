import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_colors.dart';
import 'core/network/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/defect_workspace/data/datasources/defect_remote_datasource.dart';
import 'features/defect_workspace/data/repositories/defect_repository_impl.dart';
import 'features/defect_workspace/presentation/controllers/workspace_controller.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientasi landscape optimal untuk denah teknis maritim, mendukung juga portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  // Inisialisasi Supabase
  await SupabaseConfig.initialize();

  // Dependency Injection Manual (tanpa provider agar POC tetap ringan)
  final dataSource = DefectSupabaseDataSourceImpl(
    supabaseClient: SupabaseConfig.client,
  );
  final repository = DefectRepositoryImpl(remoteDataSource: dataSource);
  final controller = WorkspaceController(repository: repository);

  runApp(PelniDefectTrackerApp(controller: controller));
}

class PelniDefectTrackerApp extends StatelessWidget {
  final WorkspaceController controller;

  const PelniDefectTrackerApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PELNI Docking Monitoring System (PDMS)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.pelniLightTheme,
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.surfaceLight,
          systemNavigationBarIconBrightness: Brightness.dark,
        ));
        return child!;
      },
      home: SplashScreen(controller: controller),
    );
  }
}
