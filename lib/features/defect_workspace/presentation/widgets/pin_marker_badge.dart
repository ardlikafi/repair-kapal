import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/defect_hotspot.dart';

/// Penanda Pin Defect pada kanvas blueprint kapal — Light Theme.
class PinMarkerBadge extends StatefulWidget {
  final DefectHotspot hotspot;
  final bool isSelected;
  final VoidCallback onTap;

  const PinMarkerBadge({
    super.key,
    required this.hotspot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PinMarkerBadge> createState() => _PinMarkerBadgeState();
}

class _PinMarkerBadgeState extends State<PinMarkerBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.40).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    if (widget.hotspot.status == DefectStatus.waitingApproval) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PinMarkerBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hotspot.status == DefectStatus.waitingApproval) {
      if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.hotspot.status;
    final vendor = widget.hotspot.vendor;
    final vendorColor = vendor?.color ?? AppColors.textMuted;
    final isWaiting = status == DefectStatus.waitingApproval;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (isWaiting)
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: AppDimens.pinPulseRingSize,
                    height: AppDimens.pinPulseRingSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.statusWaitingApproval.withValues(alpha: 0.45),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              child!,
            ],
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: AppDimens.pinMarkerSize,
          height: AppDimens.pinMarkerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Selected: warna penuh status | Unselected: putih bersih dengan border vendor
            color: widget.isSelected ? status.color : AppColors.surfaceLight,
            border: Border.all(
              color: widget.isSelected ? status.color : vendorColor,
              width: widget.isSelected ? 2.0 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: status.color.withValues(alpha: widget.isSelected ? 0.5 : 0.25),
                blurRadius: widget.isSelected ? 10 : 5,
                spreadRadius: widget.isSelected ? 1 : 0,
              ),
              // Shadow putih bersih agar pin terlihat di atas foto
              const BoxShadow(
                color: Color(0x33FFFFFF),
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: _StatusIcon(status: status, isSelected: widget.isSelected),
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final DefectStatus status;
  final bool isSelected;
  const _StatusIcon({required this.status, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : status.color;
    return switch (status) {
      DefectStatus.open => Icon(Icons.warning_rounded, size: 16, color: color),
      DefectStatus.inProgress => Icon(Icons.build_circle_outlined, size: 16, color: color),
      DefectStatus.waitingApproval => Icon(Icons.hourglass_top_rounded, size: 15, color: color),
      DefectStatus.approved => Icon(Icons.verified_rounded, size: 16, color: color),
    };
  }
}

/// Label kode pin di bawah penanda — hanya muncul saat pin dipilih
class PinCodeLabel extends StatelessWidget {
  final String pinCode;
  final bool isSelected;

  const PinCodeLabel({
    super.key,
    required this.pinCode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.pelniNavy,
        borderRadius: AppDimens.borderSm,
        boxShadow: [
          BoxShadow(
            color: AppColors.pelniNavy.withValues(alpha: 0.3),
            blurRadius: 4,
          )
        ],
      ),
      child: Text(
        pinCode,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
