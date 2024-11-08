import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';

class AusgabeScreen extends ConsumerWidget {
  const AusgabeScreen({
    super.key,
  });

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
            Text(
              'Wechselgeld: Ł ${stack.wechselgeld}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ihr Produkt:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: stack.ausgabefach.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: stack.ausgabefach.length,
                      itemBuilder: (context, index) {
                        final product = stack.ausgabefach[index];
                        return Card(
                          child: Column(
                            children: [
                              Image.asset(
                                product.image,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 250);
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Preis: Ł ${product.price}',
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