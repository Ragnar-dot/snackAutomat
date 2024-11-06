import 'dart:ui'; // Für BackdropFilter
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';
import '../screens/ausgabe_screen.dart';

class ProductWidget extends ConsumerWidget {
  final Product product;
  final Function(String, String) onProductPurchased;

  const ProductWidget({
    super.key,
    required this.product,
    required this.onProductPurchased,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAmount = ref.watch(transactionProvider);
    final stackManager = ref.read(stackManagerProvider);

    double remainingAmount =
        double.parse((product.price - transactionAmount).toStringAsFixed(2));

    return SizedBox(
      width: 200,
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
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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
              margin: const EdgeInsets.all(1.0), // Abstand zum Rahmen
              decoration: BoxDecoration(
                color: const Color.fromARGB(96, 255, 255, 255), // Hintergrundfarbe der Card
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
                  const SizedBox(height: 1),
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
                  // Preis
                  Text(
                    'Ł ${product.price.toStringAsFixed(2)}',
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
                              'Noch fehlend: Ł ${remainingAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            )
                          : Container(),
                  const SizedBox(height: 8),
                  // Kaufen-Button
                  ElevatedButton(
                    onPressed: transactionAmount >= product.price &&
                            product.quantity > 0
                        ? () async {
                            // Sound abspielen
                            final player = AudioPlayer();
                            await player.play(
                              AssetSource('sounds/vending-machine-output.mp3'),
                            );

                            // Produkt kaufen
                            stackManager.addRevenue(product.price);
                            ref
                                .read(transactionProvider.notifier)
                                .resetTransaction();
                            stackManager.reduceProductStock(product.id);
                            onProductPurchased(product.name, product.image);

                            // Wechselgeld berechnen
                            double changeAmount =
                                transactionAmount - product.price;
                            if (changeAmount > 0) {
                              List<double> change = stackManager
                                  .calculateChange(changeAmount);
                              if (change.isNotEmpty) {
                                onProductPurchased(
                                    'Wechselgeld: Ł ${changeAmount.toStringAsFixed(2)}',
                                    '');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Nicht genügend Wechselgeld verfügbar.',
                                    ),
                                  ),
                                );
                              }
                            }

                            // Zum AusgabeScreen navigieren
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AusgabeScreen(
                                  changeAmount:
                                      changeAmount > 0 ? changeAmount : 0,
                                  purchasedProducts: [product.image],
                                ),
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
