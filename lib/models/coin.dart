class Coin {
  final int value;
  final String image;
  final bool isBill; // Neu hinzugefügt

  const Coin({required this.value, required this.image, this.isBill = false});
}