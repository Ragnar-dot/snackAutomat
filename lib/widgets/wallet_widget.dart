import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';

// class Wallet {
//   final double value;
//   final String image;

//   Wallet({required this.value, required this.image});
// }

class WalletWidget extends ConsumerWidget {
  final String image;

  const WalletWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stack = ref.watch(refStack); // Use watch instead of read for reactive updates

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 60,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Image.asset(
              'assets/Wallet/Wallet.png',
              height: 35,
            ),
            Text(
              'Guthaben: ${(stack.walletBalance / 100).toStringAsFixed(2)} Ł',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
