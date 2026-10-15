import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/vessel_deck.dart';

/// Bar Navigasi Tab Teknis Minimalis untuk Pemilihan Dek Kapal (Deck Switcher)
class DeckSwitcherBar extends StatelessWidget {
  final VesselDeck activeDeck;
  final void Function(VesselDeck) onDeckSelected;
  final int Function(VesselDeck) countHotspots;

  const DeckSwitcherBar({
    super.key,
    required this.activeDeck,
    required this.onDeckSelected,
    required this.countHotspots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      child: Row(
        children: [
          // ─── Label Navigasi Dek ─────────────────────────────────────────
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.layers_outlined, size: 14, color: AppColors.pelniNavy),
              SizedBox(width: 6),
              Text(
                'ZONA GELADAK:',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(width: 12),
            ],
          ),

          // ─── Daftar Tab Dek ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: VesselDeck.values.map((deck) {
                  final isActive = deck == activeDeck;
                  final count = countHotspots(deck);

                  return _DeckTabItem(
                    deck: deck,
                    isActive: isActive,
                    count: count,
                    onTap: () => onDeckSelected(deck),
                  );
                }).toList(),
              ),
            ),
          ),

          // ─── Metadata Teknis Kanvas ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.borderColor, width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.architecture_rounded,
                    size: 11, color: AppColors.textSecondary),
                SizedBox(width: 4),
                Text(
                  'G.A. Plan • Skala 1:200 (BKI Marine Standard)',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
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

class _DeckTabItem extends StatefulWidget {
  final VesselDeck deck;
  final bool isActive;
  final int count;
  final VoidCallback onTap;

  const _DeckTabItem({
    required this.deck,
    required this.isActive,
    required this.count,
    required this.onTap,
  });

  @override
  State<_DeckTabItem> createState() => _DeckTabItemState();
}

class _DeckTabItemState extends State<_DeckTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active
                ? AppColors.pelniNavyBg.withValues(alpha: 0.5)
                : (_isHovered ? AppColors.surfaceCard : Colors.transparent),
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.pelniNavy : Colors.transparent,
                width: 3.0, // Garis bawah tegas pelniNavy
              ),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.deck.iconEmoji,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 7),
                Text(
                  widget.deck.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? AppColors.pelniNavy : AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 8),
                // Counter Badge Jumlah Titik
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.pelniNavy
                        : AppColors.borderColor.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.count}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
