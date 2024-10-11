import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coin.dart';

final coinListProvider = Provider<List<Coin>>((ref) {
  return [
    Coin(value: 0.20, image: 'assets/coins/coin_20.png'),
    Coin(value: 0.50, image: 'assets/coins/coin_50.png'),
    Coin(value: 1.00, image: 'assets/coins/coin_100.png'),
    Coin(value: 2.00, image: 'assets/coins/coin_200.png'),
  ];
});