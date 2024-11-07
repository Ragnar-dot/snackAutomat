import 'package:snackautomat/models/product.dart';

class StackState {
  final List<Product> products;
  final Map<int, int> coinInventory;
  final int totalRevenue; // Initial total revenue set to 0 coins Einnahmen
  final int walletBalance; // Initial wallet balance set to 200 coins
  final List<String> transactionHistory = [];
  final int transaction;
  final int wechselgeld;
  final List<Product> ausgabefach;

  StackState({
    required this.products,
    required this.coinInventory,
    required this.totalRevenue,
    required this.walletBalance,
    required this.transaction,
    required this.wechselgeld,
    required this.ausgabefach,
  });

  StackState copyWith({
    List<Product>? products,
    Map<int, int>? coinInventory,
    int? totalRevenue,
    int? walletBalance,
    int? transaction,
    int? wechselgeld,
    List<Product>? ausgabefach,
  }) =>
      StackState(
        products: products ?? this.products,
        coinInventory: coinInventory ?? this.coinInventory,
        totalRevenue: totalRevenue ?? this.totalRevenue,
        walletBalance: walletBalance ?? this.walletBalance,
        transaction: transaction ?? this.transaction,
        wechselgeld: wechselgeld ?? this.wechselgeld,
        ausgabefach: ausgabefach ?? this.ausgabefach,
      );
}
