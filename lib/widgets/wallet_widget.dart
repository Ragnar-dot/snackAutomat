import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';

class Wallet {
  final double value;
  final String image;

  Wallet({required this.value, required this.image});
}

class WalletWidget extends ConsumerWidget {
  final Wallet wallet;

  const WalletWidget({super.key, required this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackManager = ref.read(stackManagerProvider);

    return GestureDetector(
      onTap: () {
        try {
          // Überprüfen, ob genügend Guthaben im Wallet vorhanden ist
          stackManager.updateWalletBalance(wallet.value);
          
          // Bestehende Funktionalität
          ref.read(transactionProvider.notifier).addCoin(wallet.value);
          stackManager.addCoinToInventory(wallet.value);
        } catch (e) {
          // Fehlermeldung anzeigen, wenn nicht genug Guthaben vorhanden ist
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              wallet.image,
              height: 60,
            ),
            Text('Guthaben: ${stackManager.walletBalance.toStringAsFixed(2)} Ł'),
          ],
        ),
      ),
    );
  }
}


