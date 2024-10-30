import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coin.dart';
import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class CoinWidget extends ConsumerWidget {
  final Coin coin;

  const CoinWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackManager = ref.read(stackManagerProvider);

    return GestureDetector( // GestureDetector für die Interaktion mit dem Coin
      onTap: () async {
        // Abspielen des Sounds
        final player = AudioPlayer();
        await player.play(AssetSource('sounds/coinsound.mp3'));

        // Bestehende Funktionalität
        ref.read(transactionProvider.notifier).addCoin(coin.value);
        stackManager.addCoinToInventory(coin.value);
      },
      child: Container(
        width: 35,
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              coin.image,
              height: 50,
            ),
            Text(' ${coin.value.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
