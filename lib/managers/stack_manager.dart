import '../models/coin.dart';
import '../models/product.dart';

class StackManager {
  final List<Product> _products;
  final Map<double, int> _coinInventory;
  double _totalRevenue = 0.0;
  double _walletBalance = 200.0; // Wallet Balance set to 200 coin initially
  final List<String> _transactionHistory = [];

  StackManager({
    required List<Product> initialProducts,
    required List<Coin> initialCoins,
  })  : _products = initialProducts,
        _coinInventory = {
          for (var coin in initialCoins) coin.value: 10,
        };

  // Getter und Methoden bleiben weitgehend gleich...

  // Wallet Guthaben abrufen
  double get walletBalance => _walletBalance;

  // Wallet Guthaben aktualisieren
  void updateWalletBalance(double amount) {
    if (_walletBalance - amount >= 0) {
      _walletBalance -= amount;
    } else {
      throw Exception('Nicht genug Guthaben im Wallet.');
    }
  }

  // Transaktion speichern
  void addTransaction(String transaction) {
    _transactionHistory.add(transaction);
  }

  // Transaktionshistorie abrufen
  List<String> get transactionHistory => _transactionHistory;

  // Produkte verwalten
  List<Product> get products => _products;

  // Münzbestand anzeigen
  Map<double, int> get coinInventory => _coinInventory;

  // Gesamtumsatz abrufen
  double get totalRevenue => _totalRevenue;

  // Produkt nach ID suchen
  Product getProductById(int productId) {
    return _products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Kein Produkt mit der ID $productId gefunden.'),
    );
  }

  // Produktbestand verringern (bei Kauf)
  void reduceProductStock(int productId) {
    final product = getProductById(productId);
    if (product.quantity > 0) {
      product.quantity--;
    } else {
      throw Exception('Produkt ausverkauft.');
    }
  }

  // Umsatz erhöhen
  void addRevenue(double amount) {
    _totalRevenue += amount;
  }

  // Münzen hinzufügen (wenn Benutzer Münzen einwirft)
  void addCoinToInventory(double coinValue) {
    if (_coinInventory.containsKey(coinValue)) {
      _coinInventory[coinValue] = _coinInventory[coinValue]! + 1;
    } else {
      _coinInventory[coinValue] = 1;
    }
  }

  // Münzen nachfüllen
  void restockAllCoins() {
    _coinInventory.updateAll((key, value) => 10);
  }

  // Produkt nachfüllen
  void restockProduct(int productId, int amount) {
    final product = getProductById(productId);
    product.quantity += amount;
  }

  // Wechselgeld berechnen und Münzbestand aktualisieren
  List<double> calculateChange(double changeAmount) {
    List<double> change = [];
    double remainingAmount = double.parse(changeAmount.toStringAsFixed(2));
    List<double> coinValues = _coinInventory.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var coinValue in coinValues) {
      int coinCount = _coinInventory[coinValue]!;
      while (remainingAmount >= coinValue && coinCount > 0) {
        remainingAmount = double.parse((remainingAmount - coinValue).toStringAsFixed(2));
        coinCount--;
        _coinInventory[coinValue] = coinCount;
        change.add(coinValue);
      }
    }

    if (remainingAmount == 0) {
      return change;
    } else {
      // Nicht genügend Münzen für Wechselgeld
      // Münzbestand zurücksetzen
      for (var coin in change) {
        _coinInventory[coin] = _coinInventory[coin]! + 1;
      }
      return [];
    }
  }
}