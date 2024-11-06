import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final productListProvider = Provider<List<Product>>((ref) {
  return [
    Product(
      id: 1,
      name: 'Lays KFC Chips',
      price: 1.50,
      quantity: 10,
      image: 'assets/products/Lays KFC Chips.png',
    ),

    Product(
      id: 2,
      name: 'Adelholzener Naturell 0,5 l',
      price: 1.70,
      quantity: 10,
      image: 'assets/products/Adelholzener Naturell 0,5 l.png',
    ),

    Product(
      id: 3,
      name: 'Ball und Ovidias belgische Schokolade',
      price: 2.00,
      quantity: 10,
      image: 'assets/products/Ball und Ovidias belgische Schokolade.png',
    ),

    Product(
      id: 4,
      name: 'BeefJerky',
      price: 2.50,
      quantity: 10,
      image: 'assets/products/BeefJerky.png',
    ),

        Product(
      id: 5,
      name: 'Celebrations Pop Geschenkbox',
      price: 2.70,
      quantity: 10,
      image: 'assets/products/Celebrations Pop Geschenkbox.png',
    ),

    Product(
      id: 6,
      name: 'Coca Cola Dose 0,33 l',
      price: 1.20,
      quantity: 10,
      image: 'assets/products/Coca Cola Dose 0,33 l.png',
    ),

    Product(
      id: 7,
      name: 'Crunchy Nuts Spicy',
      price: 1.15,
      quantity: 10,
      image: 'assets/products/Crunchy Nuts Spicy.png',
    ),

    Product(
      id: 8,
      name: 'Elephant Prezels',
      price: 1.20,
      quantity: 10,
      image: 'assets/products/Elephant Prezels.png',
    ),






    Product(
      id: 9,
      name: 'Fanta Dose 0,33 l',
      price: 1.70,
      quantity: 10,
      image: 'assets/products/Fanta Dose 0,33 l.png',
    ),

    Product(
      id: 10,
      name: 'Iso Sport Drink light 0,25 l',
      price: 1.90,
      quantity: 10,
      image: 'assets/products/Iso Sport Drink light 0,25 l.png',
    ),

    Product(
      id: 11,
      name: 'Kichererbsen Chips',
      price: 1.70,
      quantity: 10,
      image: 'assets/products/Kichererbsen Chips.png',
    ),

    Product(
      id: 12,
      name: 'Knoppers',
      price: 0.90,
      quantity: 10,
      image: 'assets/products/Knoppers.png',
    ),

        Product(
      id: 13,
      name: 'Knorr Pasta Pot XXL',
      price: 1.70,
      quantity: 10,
      image: 'assets/products/Knorr Pasta Pot XXL.png',
    ),

    Product(
      id: 14,
      name: 'Knusprige Krabbencracker',
      price: 1.50,
      quantity: 10,
      image: 'assets/products/Knusprige Krabbencracker.png',
    ),

    Product(
      id:  15,
      name: 'Kortoffel Sticks',
      price: 1.20,
      quantity: 10,
      image: 'assets/products/Kortoffel Sticks.png',

    ),

    Product(
      id: 16,
      name: 'Elephant Prezels',
      price: 1.50,
      quantity: 10,
      image: 'assets/products/Elephant Prezels.png',
    ),









    Product(
      id: 18,
      name: 'BeefJerky',
      price: 2.70,
      quantity: 10,
      image: 'assets/products/BeefJerky.png',
    ),

        Product(
      id: 19,
      name: 'Celebrations Pop Geschenkbox',
      price: 1.50,
      quantity: 10,
      image: 'assets/products/Celebrations Pop Geschenkbox.png',
    ),

    Product(
      id: 20,
      name: 'Coca Cola Dose 0,33 l',
      price: 1.50,
      quantity: 10,
      image: 'assets/products/Coca Cola Dose 0,33 l.png',
    ),

    Product(
      id:  21,
      name: 'Crunchy Nuts Spicy',
      price: 1.50,
      quantity: 10,
      image: 'assets/products/Crunchy Nuts Spicy.png',
    ),




    // Weitere Produkte hinzufügen...
  ];
});