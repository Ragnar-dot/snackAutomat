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
  width: 200, // Set the desired width
  height: 300, // Adjust height as needed
  child: Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          product.image,
          height: 90,
          width: 90
        ,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8), // Adds spacing between elements
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Ł ${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Verfügbar: ${product.quantity}',
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
            
            product.quantity < 1
                ? const Text(
                    'Ausverkauft',
                    style: TextStyle(color: Colors.red),
                  )
                : remainingAmount > 0
                    ? Text(
                        'Noch fehlend: Ł ${remainingAmount.toStringAsFixed(2)}',
                        style: const TextStyle (
                          fontSize: 12),
                      )
                    : Container(),
            ElevatedButton(
              onPressed: transactionAmount >= product.price &&
                      product.quantity > 0
                        ? () async {
                                                                                              // Play sound
                                                                                             final player = AudioPlayer();
                                                                                             await player.play(AssetSource('sounds/vending-machine-output.mp3'));
                      // Produkt kaufen
                      stackManager.addRevenue(product.price);
                      ref.read(transactionProvider.notifier).resetTransaction();
                      stackManager.reduceProductStock(product.id);
                      onProductPurchased(product.name, product.image);

                      // Wechselgeld berechnen
                      double changeAmount = transactionAmount - product.price;
                      if (changeAmount > 0) {
                        List<double> change =
                            stackManager.calculateChange(changeAmount);
                        if (change.isNotEmpty) {
                          onProductPurchased(
                              'Wechselgeld: Ł ${changeAmount.toStringAsFixed(2)}',
                              '');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Nicht genügend Wechselgeld verfügbar.')),
                          );
                        }
                      }

                      // Zum AusgabeScreen navigieren
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AusgabeScreen(
                            changeAmount: changeAmount > 0 ? changeAmount : 0,
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
    );
  }
}
