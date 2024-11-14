import 'dart:ui'; // Für BackdropFilter
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import '../models/product.dart';
import '../screens/ausgabe_screen.dart';

class ProductWidget extends ConsumerWidget {
  final Product product;

  const ProductWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stack = ref.watch(refStack);
    final transactionAmount = stack.transaction;
    final stackManager = ref.read(refStack.notifier);

    double remainingAmount = double.parse((product.price - transactionAmount).toStringAsFixed(2));

    return SizedBox(
      width: 100,
      height: 300,
      child: Stack(
        children: [
          // Äußerer Container mit Glassmorphism-Rahmen
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    width: 2.0, // Dicke des Rahmens
                    color: const Color.fromARGB(61, 134, 131, 131).withOpacity(0.6),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 1.0),
                  child: Container(
                    color: const Color.fromARGB(0, 241, 241, 241),
                  ),
                ),
              ),
            ),
          ),
          // Innerer Container für den Card-Inhalt
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(3.0), // Abstand zum Rahmen
              decoration: BoxDecoration(
                color: const Color.fromARGB(55, 238, 235, 235), // Hintergrundfarbe der Card
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Produktbild
                  Image.asset(
                    product.image,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height:1),
                  // Produktname
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Preis as integer
                  Text(
                    'Ł ${(product.price / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  // Verfügbarkeit
                  Text(
                    'Verfügbar: ${product.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status oder fehlender Betrag
                  product.quantity < 1
                      ? const Text(
                          'Ausverkauft',
                          style: TextStyle(color: Colors.redAccent),
                        )
                      : remainingAmount > 0
                          ? Text(
                              'Noch fehlend: Ł ${(remainingAmount / 100).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            )
                          : Container(),
                  const SizedBox(height: 8),
                  // Kaufen-Button
                  ElevatedButton(
                    onPressed: transactionAmount >= product.price && product.quantity > 0
                        ? () async {
                            if (!stackManager.canBuy(product)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Nicht genügend Wechselgeld verfügbar.',
                                  ),
                                ),
                              );
                            }
                            // Sound abspielen
                            final player = AudioPlayer();
                            await player.play(
                              AssetSource('sounds/vending-machine-output.mp3'),
                            );

                            // Produkt kaufen
                            stackManager.buy(product);

                            // Zum AusgabeScreen navigieren
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AusgabeScreen(),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Kaufen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}