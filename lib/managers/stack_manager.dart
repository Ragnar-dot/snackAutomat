import '../models/coin.dart';
import '../models/product.dart';

class StackManager {
  final List<Product> _products;
  final Map<double, int> _coinInventory;
  double _totalRevenue = 0.0; // Initial total revenue set to 0 coins Einnahmen
  double _walletBalance = 200.0; // Initial wallet balance set to 200 coins
  final List<String> _transactionHistory = [];

  // Constructor to initialize products and coins
  StackManager({
    required List<Product> initialProducts,
    required List<Coin> initialCoins,
  })  : _products = initialProducts,
        _coinInventory = {
          for (var coin in initialCoins) coin.value: 10,
        };

  // Get the current wallet balance
  double get walletBalance => _walletBalance;

  // Update wallet balance by deducting the specified amount
  void updateWalletBalance(double amount) {
    if (_walletBalance - amount >= 0) {
      _walletBalance -= amount;
    } else {
      throw Exception('Nicht genug Guthaben im Wallet.');
    }
  }

  // Handle coin insertion: deduct from wallet, add coin to inventory, and add to revenue
  void onCoinInserted(double coinValue) {
    try {
      // Deduct the coin value from the customer's wallet
      deductFromCoinstack(coinValue);
      
      // Add the coin to the inventory (admin area)
      addCoinToInventory(coinValue);
      
      // Add the coin value to the total revenue (profit)
      addRevenue(coinValue);
      
      // Log the transaction
      addTransaction('Münze $coinValue eingeworfen.');
    } catch (e) {
      print('Fehler: ${e.toString()}');
    }
  }

  // Deduct a specific coin value from the wallet balance
  void deductFromCoinstack(double coinValue) {
    updateWalletBalance(coinValue);
  }

  // Add a transaction record to the history
  void addTransaction(String transaction) {
    _transactionHistory.add(transaction);
  }

  // Retrieve the transaction history
  List<String> get transactionHistory => _transactionHistory;

  // Retrieve the list of products
  List<Product> get products => _products;

  // Retrieve the coin inventory
  Map<double, int> get coinInventory => _coinInventory;

  // Retrieve the total revenue
  double get totalRevenue => _totalRevenue;

  // Get a product by its ID
  Product getProductById(int productId) {
    return _products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Kein Produkt mit der ID $productId gefunden.'),
    );
  }

  // Decrease product stock when a product is purchased
  void reduceProductStock(int productId) {
    final product = getProductById(productId);
    if (product.quantity > 0) {
      product.quantity--;
    } else {
      throw Exception('Produkt ausverkauft.');
    }
  }

  // Add amount to total revenue
  void addRevenue(double amount) {
    _totalRevenue += amount;
  }

  // Add a coin to the inventory
  void addCoinToInventory(double coinValue) {
    if (_coinInventory.containsKey(coinValue)) {
      _coinInventory[coinValue] = _coinInventory[coinValue]! + 1;
    } else {
      _coinInventory[coinValue] = 1;
    }
  }

  // Restock all coins to the default level of 10 each
  void restockAllCoins() {
    _coinInventory.updateAll((key, value) => 10);
  }

  // Restock a specific product by ID
  void restockProduct(int productId, int amount) {
    final product = getProductById(productId);
    product.quantity += amount;
  }

  // Calculate change based on the change amount and update coin inventory
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
      // Reset the coin inventory if exact change cannot be provided
      for (var coin in change) {
        _coinInventory[coin] = _coinInventory[coin]! + 1;
      }
      return [];
    }
  }
}
