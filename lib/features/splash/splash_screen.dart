import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../defect_workspace/presentation/controllers/workspace_controller.dart';
import '../shell/main_app_shell.dart';

/// Splash Screen Korporat Resmi PT PELNI (Persero)
class SplashScreen extends StatefulWidget {
  final WorkspaceController controller;

  const SplashScreen({super.key, required this.controller});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    // Timer 2 detik otomatis berpindah ke MainAppShell
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MainAppShell(controller: widget.controller),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pelniNavy, // Deep PELNI Navy (#1A3B70)
      body: Stack(
        children: [
          // Background subtle technical watermarks / grid
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(
                painter: _SplashGridPainter(),
              ),
            ),
          ),

          // Konten Utama di Tengah
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo PELNI berlatar terang/putih elegan (sudut tegas 6px)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6), // Sudut tegas 6px
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/pelni_logo.png',
                      height: 54,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'PELNI',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.pelniNavy,
                          fontSize: 28,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Teks Judul Sistem
                  const Text(
                    'PELNI DOCKING MONITORING SYSTEM (PDMS)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Sub-judul
                  Text(
                    'PT Pelayaran Nasional Indonesia (Persero)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                      letterSpacing: 0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  // Tag Identitas Divisi
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'DIVISI DOCKING & PEMELIHARAAN ARMADA NASIONAL',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Indikator Loading Halus + Teks Versi di Bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.pelniOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'v1.0.0 Enterprise Build (POC)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
