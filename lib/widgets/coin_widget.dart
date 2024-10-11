import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coin.dart';
import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';

class CoinWidget extends ConsumerWidget {
  final Coin coin;

  CoinWidget({required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackManager = ref.read(stackManagerProvider);

    return GestureDetector(
      onTap: () {
        ref.read(transactionProvider.notifier).addCoin(coin.value);
        stackManager.addCoinToInventory(coin.value);
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              coin.image,
              height: 50,
            ),
            Text('Coin ${coin.value.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}