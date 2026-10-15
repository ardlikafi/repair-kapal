/// Definisi Dek Kapal untuk Fitur Deck Switcher PELNI
enum VesselDeck {
  profile,
  mainDeck,
  bridgeDeck;

  String get label {
    switch (this) {
      case VesselDeck.profile:
        return 'Tampak Samping (Profile)';
      case VesselDeck.mainDeck:
        return 'Geladak Utama (Main Deck)';
      case VesselDeck.bridgeDeck:
        return 'Anjungan (Bridge Deck)';
    }
  }

  String get iconEmoji {
    switch (this) {
      case VesselDeck.profile:
        return '⚓';
      case VesselDeck.mainDeck:
        return '🚢';
      case VesselDeck.bridgeDeck:
        return '🧭';
    }
  }

  /// URL Denah Blueprint per Dek
  String blueprintUrl(String defaultUrl) {
    switch (this) {
      case VesselDeck.profile:
        return defaultUrl;
      case VesselDeck.mainDeck:
        // Denah teknis Geladak Utama (Main Deck / Cardeck)
        return 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=1600&auto=format&fit=crop&q=80';
      case VesselDeck.bridgeDeck:
        // Denah teknis Anjungan (Navigation Bridge Deck)
        return 'https://images.unsplash.com/photo-1505705694340-019e1e335916?w=1600&auto=format&fit=crop&q=80';
    }
  }
}
