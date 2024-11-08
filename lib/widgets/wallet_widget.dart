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
    final stack = ref.read(refStack);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 80,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 60,
            ),
            Text('Guthaben: ${stack.walletBalance} Ł'),
          ],
        ),
      ),
    );
  }
}
