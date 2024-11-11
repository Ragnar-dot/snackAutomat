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

  // Constructor to initialize products and coins
  StackManager();

  // Get the current wallet balance
  // int get walletBalance => state.walletBalance;

  // Handle coin insertion: deduct from wallet, add coin to inventory, and add to revenue
  void onCoinInserted(int coinValue) {}

  // Get a product by its ID
  Product getProductById(int productId) {
    return state.products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Kein Produkt mit der ID $productId gefunden.'),
    );
  }

  // Restock all coins to the default level of 10 each
  void restockAllCoins() {
    final newCoins = <int, int>{};
    for (final coin in allCoins) {
      newCoins[coin.value] = 10;
    }
    state = state.copyWith(coinInventory: newCoins);
  }

  // Restock a specific product by ID
  void restockProduct(int productId, int amount) {
    final oldProduct = getProductById(productId);
    final newProduct = oldProduct.copyWith(
      quantity: oldProduct.quantity + amount,
    );
    final newProducts = state.products
        .map(
          (p) => p != oldProduct ? p : newProduct,
        )
        .toList();
    state = state.copyWith(products: newProducts);
  }

  // Calculate change based on the change amount and update coin inventory
  List<int> calculateChange(int changeAmount) {
    List<int> change = [];
    int remainingAmount = changeAmount;
    List<int> coinValues = state.coinInventory.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var coinValue in coinValues) {
      int coinCount = state.coinInventory[coinValue]!;
      while (remainingAmount >= coinValue && coinCount > 0) {
        remainingAmount = remainingAmount - coinValue;
        coinCount--;
        // state.coinInventory[coinValue] = coinCount;
        change.add(coinValue);
      }
    }

    if (remainingAmount == 0) {
      return change;
    } else {
      // Reset the coin inventory if exact change cannot be provided
      // for (var coin in change) {
      //   // state.coinInventory[coin] = state.coinInventory[coin]! + 1;
      // }
      return [];
    }
  }

  void addCoin(int value) {
    state = state.copyWith(walletBalance: state.walletBalance - value);
    state = state.copyWith(transaction: state.transaction + value);
  }

  void resetTransaction() {
    state = state.copyWith(transaction: 0);
  }

void buy(Product product) {
    if (canBuy(product)) { 
        // Reset transaction amount after purchase
        resetTransaction();

        // Calculate the total change amount by summing the list from calculateChange
        List<int> changeCoins = calculateChange(state.transaction - product.price);
        int totalChange = changeCoins.fold(0, (sum, coin) => sum + coin);

        // Update the state with the purchased product and calculated total change
        state = state.copyWith(
          ausgabefach: [...state.ausgabefach, product],
          wechselgeld: totalChange,
        );

        // Reduce the quantity of the purchased product
        final updatedProduct = product.copyWith(quantity: product.quantity - 1);
        final updatedProducts = state.products.map((p) => p.id == product.id ? updatedProduct : p).toList();
        state = state.copyWith(products: updatedProducts);
    }
}

  bool canBuy(Product product) {
    if (state.transaction < product.price) return false;
    if (state.walletBalance < 0) return false;
    if (product.quantity < 1) return false;
    if (!canGiveChange(state.transaction - product.price)) return false;
    return true;
  }

  bool canGiveChange(int change) {
    int remainingAmount = change;
    List<int> coinValues = state.coinInventory.keys.toList()..sort((a, b) => b.compareTo(a));
    for (var coinValue in coinValues) {
      int coinCount = state.coinInventory[coinValue]!;
      while (remainingAmount >= coinValue && coinCount > 0 && remainingAmount > 0) {
        remainingAmount = remainingAmount - coinValue;
        coinCount--;
      }
    }
    if (remainingAmount == 0) return true;
    return false;
  }


  
}




