import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_state.dart';



import '../models/product.dart';

final refStack = NotifierProvider<StackManager, StackState>(() => StackManager());

class StackManager extends Notifier<StackState> {
  @override
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
            price: 200,
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
            price: 280,
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
            price: 120,
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
            price: 180,
            quantity: 10,
            image: 'assets/products/Fanta Dose 0,33 l.png',
          ),

          Product(
            id: 10,
            name: 'Iso Sport Drink light 0,25 l',
            price: 180,
            quantity: 10,
            image: 'assets/products/Iso Sport Drink light 0,25 l.png',
          ),

          Product(
            id: 11,
            name: 'Kichererbsen Chips',
            price: 180,
            quantity: 10,
            image: 'assets/products/Kichererbsen Chips.png',
          ),

          Product(
            id: 12,
            name: 'Knoppers',
            price: 080,
            quantity: 10,
            image: 'assets/products/Knoppers.png',
          ),

          Product(
            id: 13,
            name: 'Knorr Pasta Pot XXL',
            price: 180,
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
            price: 280,
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
   coinInventory: {
      20: 100,
      50: 100,
      100: 100,
      200: 100,
    },
    totalRevenue: 0,
    walletBalance: 20000,
    transaction: 0,
    wechselgeld: 100,
    ausgabefach: [],
  );

  /// Methode zum Kauf eines Produkts
  void buy(Product product) {
    if (canBuy(product)) {
      int changeAmount = state.transaction - product.price;
      List<int> coinInventory = calculateChange(changeAmount);
      int totalChange = coinInventory.fold(0, (sum, coin) => sum + coin);

    state = state.copyWith(
      ausgabefach: [...state.ausgabefach, product],
      wechselgeld: changeAmount,
      totalRevenue: state.totalRevenue + product.price,
      transactionHistory: [
        ...state.transactionHistory,
        {
          'Produkt': product.name,
          'Preis': (product.price / 100).toStringAsFixed(2),
          'Zeit': DateTime.now().toString(),
          'Wechselgeld': (totalChange / 100).toStringAsFixed(2),
        }
      ],
      
    );

      // Produktmenge aktualisieren
      final updatedProduct = product.copyWith(quantity: product.quantity - 1);
      final updatedProducts = state.products
          .map((p) => p.id == product.id ? updatedProduct : p)
          .toList();
      state = state.copyWith(products: updatedProducts);

      // Wechselgeld zur Brieftasche hinzufügen
      state = state.copyWith(walletBalance: state.walletBalance + totalChange);

      // Transaktionsbetrag nach dem Kauf zurücksetzen
      resetTransaction();
    }
  }

  /// Methode, um alle Münzen auf einen Standardwert aufzufüllen
  void restockAllCoins() {
    final newCoins = <int, int>{};
    for (final coin in state.coinInventory.keys) {
      newCoins[coin] = 100; // Annahme: 100 Münzen pro Wert
    }
    state = state.copyWith(coinInventory: newCoins);
  }

  /// Methode, um ein bestimmtes Produkt nach ID aufzufüllen
  void restockProduct(int productId, int amount) {
    final oldProduct = getProductById(productId);
    final newProduct = oldProduct.copyWith(
      quantity: oldProduct.quantity + amount,
    );
    final newProducts = state.products
        .map((p) => p.id == productId ? newProduct : p)
        .toList();
    state = state.copyWith(products: newProducts);
  }

  /// Hilfsfunktion, um ein Produkt anhand der ID zu erhalten
  Product getProductById(int productId) {
    return state.products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Kein Produkt mit der ID $productId gefunden.'),
    );
  }

  /// Hilfsfunktion, um die Transaktion zurückzusetzen
  void resetTransaction() {
    state = state.copyWith(transaction: 0);
  }

  /// Methode, um die Transaktion zurückzusetzen und den Betrag zur Brieftasche zurückzugeben
  void resetTransactionAndReturnToWallet() {
    state = state.copyWith(
      walletBalance: state.walletBalance + state.transaction,
      transaction: 0,
    );
  }

  /// Prüft, ob der Kunde das Produkt kaufen kann und ob Wechselgeld verfügbar ist
  bool canBuy(Product product) {
    return state.transaction >= product.price &&
           state.walletBalance >= 0 &&
           product.quantity > 0 &&
           canGiveChange(state.transaction - product.price);
  }

  /// Methode zur Berechnung des Wechselgeldes auf Basis des Betrags und des Münzbestands
  List<int> calculateChange(int changeAmount) {
    List<int> change = [];
    int remainingAmount = changeAmount;

    // Festgelegte Münzwerte in absteigender Reihenfolge
    List<int> coinValues = [200, 100, 50, 20];

    // Durchlaufe jede Münzgröße von groß nach klein
    for (var coinValue in coinValues) {
      int availableCoins = state.coinInventory[coinValue] ?? 0;

      // Nutze so viele Münzen wie möglich, ohne den verbleibenden Betrag zu überschreiten
      while (remainingAmount >= coinValue && availableCoins > 0) {
        remainingAmount -= coinValue;
        availableCoins--;
        change.add(coinValue);  // Münze zum Rückgabegeld hinzufügen
      }

      // Aktualisiere den Münzbestand nach Verwendung
      state.coinInventory[coinValue] = availableCoins;
    }

    // Überprüfen, ob das exakte Wechselgeld zurückgegeben werden konnte
    if (remainingAmount != 0) {
      // Wenn kein exaktes Wechselgeld möglich ist, die Liste leeren und eine leere Liste zurückgeben
      return [];
    }

    return change;
  }

  /// Prüft, ob der Automat das exakte Wechselgeld mit den verfügbaren Münzen zurückgeben kann
  bool canGiveChange(int change) {
    int remainingAmount = change;
    Map<int, int> tempCoinInventory = Map.from(state.coinInventory);

    for (var coinValue in [200, 100, 50, 20]) {
      int coinCount = tempCoinInventory[coinValue] ?? 0;
      while (remainingAmount >= coinValue && coinCount > 0) {
        remainingAmount -= coinValue;
        coinCount--;
      }
      // Temporärer Münzbestand aktualisieren
      tempCoinInventory[coinValue] = coinCount;
    }

    return remainingAmount == 0;
  }

  /// Fügt eine Münze zur Transaktion hinzu und zieht den Betrag von der Brieftasche ab
  void addCoin(int value) {
    state = state.copyWith(
      walletBalance: state.walletBalance - value,
      transaction: state.transaction + value,
    );
  }
}



