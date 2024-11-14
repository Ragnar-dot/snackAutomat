import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import 'package:google_fonts/google_fonts.dart';

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
        width: 62,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Image.asset(
              'assets/Wallet/Wallet.png',
              height: 35,
            ),
            Text(
              'Guthaben ${(stack.walletBalance / 100).toStringAsFixed(2)} Ł',
              style: GoogleFonts.tektur(
            fontSize: 12.0,
            color: const Color.fromARGB(193, 0, 0, 0),
            fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
