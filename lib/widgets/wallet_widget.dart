import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';


class WalletWidget extends ConsumerWidget {
  final Wallet wallet;

  const WalletWidget({super.key, required this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackManager = ref.read(stackManagerProvider);

    return GestureDetector(
      onTap: () {
        // Bestehende Funktionalität
        ref.read(transactionProvider.notifier).addCoin(wallet.value);
        stackManager.addCoinToInventory(wallet.value);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset(
              wallet.image,
              height: 70,
            ),
            Text('Guthaben ${wallet.value.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}


