import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';

class AusgabeScreen extends ConsumerWidget {
  const AusgabeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stack = ref.watch(refStack);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ausgabe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Wechselgeld
            Text(
              'Wechselgeld: Ł ${(stack.wechselgeld / 100).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ihre Produkte:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Display all purchased products
            Expanded(
              child: stack.ausgabefach.isNotEmpty
                  ? ListView.builder(
                      itemCount: stack.ausgabefach.length,
                      itemBuilder: (context, index) {
                        final product = stack.ausgabefach[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Image.asset(
                                product.image,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 150);
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Preis: Ł ${(product.price / 100).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Kein Produkt im Ausgabefach',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}