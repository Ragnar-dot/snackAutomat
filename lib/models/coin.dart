class Coin {
  final double value;
  final String image;
  final bool isBill; // Neu hinzugefügt

  Coin({required this.value, required this.image, this.isBill = false});
}