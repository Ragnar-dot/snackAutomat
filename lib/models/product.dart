class Product {
  final int id;
  final String name;
  final int price;
  int quantity;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  Product copyWith({
    int? id,
    String? name,
    int? price,
    int? quantity,
    String? image,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        image: image ?? this.image,
      );
}
