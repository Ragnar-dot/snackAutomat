import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, double>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<double> {
  TransactionNotifier() : super(0.0);

  void addCoin(double value) {
    state += value;
  }

  void resetTransaction() {
    state = 0.0;
  }
}