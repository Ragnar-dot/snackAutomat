import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_state.dart';
import 'package:snackautomat/providers/coin_provider.dart';

import '../models/product.dart';

final refStack = NotifierProvider<StackManager, StackState>(() => StackManager());

class StackManager extends Notifier<StackState> {
  StackState build() => StackState(
        products: [
          Product(
            id: 1,
            name: 'Lays KFC Chips',
            price: 150,
            quantity: 10,
            image: 'assets/products/Lays KFC Chips.png',
          ),

          Product(
            id: 2,
            name: 'Adelholzener Naturell 0,5 l',
            price: 170,
            quantity: 10,
            image: 'assets/products/Adelholzener Naturell 0,5 l.png',
          ),

          Product(
            id: 3,
            name: 'Ball und Ovidias belgische Schokolade',
            price: 200,
            quantity: 10,
            image: 'assets/products/Ball und Ovidias belgische Schokolade.png',
          ),

          Product(
            id: 4,
            name: 'BeefJerky',
            price: 250,
            quantity: 10,
            image: 'assets/products/BeefJerky.png',
          ),

          Product(
            id: 5,
            name: 'Celebrations Pop Geschenkbox',
            price: 270,
            quantity: 10,
            image: 'assets/products/Celebrations Pop Geschenkbox.png',
          ),

          Product(
            id: 6,
            name: 'Coca Cola Dose 0,33 l',
            price: 120,
            quantity: 10,
            image: 'assets/products/Coca Cola Dose 0,33 l.png',
          ),

          Product(
            id: 7,
            name: 'Crunchy Nuts Spicy',
            price: 115,
            quantity: 10,
            image: 'assets/products/Crunchy Nuts Spicy.png',
          ),

          Product(
            id: 8,
            name: 'Elephant Prezels',
            price: 120,
            quantity: 10,
            image: 'assets/products/Elephant Prezels.png',
          ),

          Product(
            id: 9,
            name: 'Fanta Dose 0,33 l',
            price: 170,
            quantity: 10,
            image: 'assets/products/Fanta Dose 0,33 l.png',
          ),

          Product(
            id: 10,
            name: 'Iso Sport Drink light 0,25 l',
            price: 190,
            quantity: 10,
            image: 'assets/products/Iso Sport Drink light 0,25 l.png',
          ),

          Product(
            id: 11,
            name: 'Kichererbsen Chips',
            price: 170,
            quantity: 10,
            image: 'assets/products/Kichererbsen Chips.png',
          ),

          Product(
            id: 12,
            name: 'Knoppers',
            price: 090,
            quantity: 10,
            image: 'assets/products/Knoppers.png',
          ),

          Product(
            id: 13,
            name: 'Knorr Pasta Pot XXL',
            price: 170,
            quantity: 10,
            image: 'assets/products/Knorr Pasta Pot XXL.png',
          ),

          Product(
            id: 14,
            name: 'Knusprige Krabbencracker',
            price: 150,
            quantity: 10,
            image: 'assets/products/Knusprige Krabbencracker.png',
          ),

          Product(
            id: 15,
            name: 'Kortoffel Sticks',
            price: 120,
            quantity: 10,
            image: 'assets/products/Kortoffel Sticks.png',
          ),

          Product(
            id: 16,
            name: 'Elephant Prezels',
            price: 150,
            quantity: 10,
            image: 'assets/products/Elephant Prezels.png',
          ),

          Product(
            id: 18,
            name: 'BeefJerky',
            price: 270,
            quantity: 10,
            image: 'assets/products/BeefJerky.png',
          ),

          Product(
            id: 19,
            name: 'Celebrations Pop Geschenkbox',
            price: 150,
            quantity: 10,
            image: 'assets/products/Celebrations Pop Geschenkbox.png',
          ),

          Product(
            id: 20,
            name: 'Coca Cola Dose 0,33 l',
            price: 150,
            quantity: 10,
            image: 'assets/products/Coca Cola Dose 0,33 l.png',
          ),

          Product(
            id: 21,
            name: 'Crunchy Nuts Spicy',
            price: 150,
            quantity: 10,
            image: 'assets/products/Crunchy Nuts Spicy.png',
          ),

          // Weitere Produkte hinzufügen...
        ],
        coinInventory: {},
        totalRevenue: 0,
        walletBalance: 20000,
        transaction: 0,
        wechselgeld: 0,
        ausgabefach: [],
      );

  StackManager();


  /// Method to handle buying a product
  void buy(Product product) {
    if (canBuy(product)) {
      // Calculate change based on transaction amount and product price
      int changeAmount = state.transaction - product.price;
      List<int> changeCoins = calculateChange(changeAmount);
      int totalChange = changeCoins.fold(0, (sum, coin) => sum + coin);

      // Update the state with the purchased product, calculated change, total revenue, and transaction history
      state = state.copyWith(
        ausgabefach: [...state.ausgabefach, product], // Add product to output slot
        wechselgeld: totalChange, // Set the calculated change
        totalRevenue: state.totalRevenue + product.price, // Update total revenue
        transactionHistory: [
          ...state.transactionHistory,
          {
            'Produkt': product.name,
            'Preis': (product.price / 100).toStringAsFixed(2),
            'Zeit': DateTime.now().toString()
          }
        ], // Add transaction details to history
      );

      // Reduce the quantity of the purchased product
      final updatedProduct = product.copyWith(quantity: product.quantity - 1);
      final updatedProducts = state.products.map((p) => p.id == product.id ? updatedProduct : p).toList();
      state = state.copyWith(products: updatedProducts);

      // Add change back to wallet and reset transaction
      state = state.copyWith(
        walletBalance: state.walletBalance + totalChange, // Add change to wallet
        transaction: 0, // Reset transaction amount after purchase
      );
    }
  }

  /// Method to restock all coins in the machine to a default level
  void restockAllCoins() {
    final newCoins = <int, int>{};
    for (final coin in allCoins) {
      newCoins[coin.value] = 10; // Assuming 10 coins of each denomination by default
    }
    state = state.copyWith(coinInventory: newCoins);
  }

  /// Method to restock a specific product by ID
  void restockProduct(int productId, int amount) {
    final oldProduct = getProductById(productId);
    final newProduct = oldProduct.copyWith(
      quantity: oldProduct.quantity + amount,
    );
    final newProducts = state.products.map((p) => p.id == productId ? newProduct : p).toList();
    state = state.copyWith(products: newProducts);
  }

  /// Utility to get a product by its ID
  Product getProductById(int productId) {
    return state.products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Kein Produkt mit der ID $productId gefunden.'),
    );
  }

  /// Utility method to reset the transaction
  void resetTransaction() {
    state = state.copyWith(transaction: 0);
  }

  /// Method to reset the transaction and return the amount to the wallet
  void resetTransactionAndReturnToWallet() {
    state = state.copyWith(
      walletBalance: state.walletBalance + state.transaction,
      transaction: 0,
    );
  }

  /// Method to check if the customer can afford the product and if change can be provided
  bool canBuy(Product product) {
    return state.transaction >= product.price &&
           state.walletBalance >= 0 &&
           product.quantity > 0 &&
           canGiveChange(state.transaction - product.price);
  }

  /// Method to calculate change based on the change amount and update coin inventory
  List<int> calculateChange(int changeAmount) {
    List<int> change = [];
    int remainingAmount = changeAmount;
    List<int> coinValues = state.coinInventory.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var coinValue in coinValues) {
      int coinCount = state.coinInventory[coinValue] ?? 0;
      while (remainingAmount >= coinValue && coinCount > 0) {
        remainingAmount -= coinValue;
        coinCount--;
        change.add(coinValue);
      }
    }

    return remainingAmount == 0 ? change : [];
  }

  /// Checks if the machine can provide the exact change with the available coins
  bool canGiveChange(int change) {
    int remainingAmount = change;
    List<int> coinValues = state.coinInventory.keys.toList()..sort((a, b) => b.compareTo(a));
    for (var coinValue in coinValues) {
      int coinCount = state.coinInventory[coinValue] ?? 0;
      while (remainingAmount >= coinValue && coinCount > 0) {
        remainingAmount -= coinValue;
        coinCount--;
      }
    }
    return remainingAmount == 0;
  }

  /// Adds a coin to the transaction, deducting it from the wallet balance
  void addCoin(int value) {
    state = state.copyWith(
      walletBalance: state.walletBalance - value,
      transaction: state.transaction + value,
    );
  }
}



