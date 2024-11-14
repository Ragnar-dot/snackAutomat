import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import '../models/coin.dart';
import 'package:audioplayers/audioplayers.dart';

class CoinWidget extends ConsumerWidget {
  final Coin coin;

  const CoinWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackManager = ref.read(refStack.notifier);

    return GestureDetector(
      // Interaction with the Coin
      onTap: () async {
        // Play sound
        final player = AudioPlayer();
        await player.play(AssetSource('sounds/coinsound.mp3'));

        // Add coin to stack
        stackManager.addCoin(coin.value);
      },
      child: Container(
        width: 50, // Increased width for better spacing
        margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 1.0), // Adjusted margin
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              coin.image,
              height: 30,
            ),
            const SizedBox(height: 1), // Space between image and text
            Text(
              ' ${(coin.value / 100).toStringAsFixed(2)} Ł',
              textAlign: TextAlign.center,
              style: GoogleFonts.tektur(
            fontSize: 12.0,
            color: const Color.fromARGB(193, 0, 0, 0),
              ),
          ),
          ],
        ),
      ),
    );
  }
}