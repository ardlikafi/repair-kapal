/// Entitas Kapal Armada PT PELNI
class Vessel {
  final String id;
  final String name;
  final String imoNumber;
  final String blueprintUrl;
  final DateTime? createdAt;

  const Vessel({
    required this.id,
    required this.name,
    required this.imoNumber,
    required this.blueprintUrl,
    this.createdAt,
  });
}
