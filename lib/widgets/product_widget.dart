import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';

class ProductWidget extends ConsumerWidget {
  final Product product;
  final Function(String) onProductPurchased;

  ProductWidget({required this.product, required this.onProductPurchased});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAmount = ref.watch(transactionProvider);
    final stackManager = ref.read(stackManagerProvider);

    double remainingAmount = double.parse((product.price - transactionAmount).toStringAsFixed(2));

    return Card(
      child: Column(
        children: [
          Image.asset(
            product.image,
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(product.name),
          Text('Coin ${product.price.toStringAsFixed(2)}'),
          Text('Verfügbar: ${product.quantity}'),
          product.quantity < 1
              ? Text(
                  'Ausverkauft',
                  style: TextStyle(color: Colors.red),
                )
              : remainingAmount > 0
                  ? Text('Noch fehlend: Coin ${remainingAmount.toStringAsFixed(2)}')
                  : Container(),
          ElevatedButton(
            onPressed: transactionAmount >= product.price && product.quantity > 0
                ? () {
                    // Produkt kaufen
                    stackManager.addRevenue(product.price);
                    ref.read(transactionProvider.notifier).resetTransaction();
                    stackManager.reduceProductStock(product.id);
                    onProductPurchased(product.name);

                    // Wechselgeld berechnen
                    double changeAmount = transactionAmount - product.price;
                    if (changeAmount > 0) {
                      List<double> change = stackManager.calculateChange(changeAmount);
                      if (change.isNotEmpty) {
                        onProductPurchased('Wechselgeld: Coin ${changeAmount.toStringAsFixed(2)}');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nicht genügend Wechselgeld verfügbar.')),
                        );
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} gekauft!')),
                    );
                  }
                : null,
            child: Text('Kaufen'),
          ),
        ],
      ),
    );
  }
}