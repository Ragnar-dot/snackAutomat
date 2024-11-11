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
    final transactionAmount = stack.transaction;
    final stackManager = ref.read(refStack.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ausgabe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display calculated Wechselgeld from stack
            Text(
              'Wechselgeld: Ł ${(stack.wechselgeld / 100).toStringAsFixed(2)}', // Display as float for clarity
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ihr Produkt:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Display the last purchased product
            Expanded(
              child: stack.ausgabefach.isNotEmpty
                  ? Card(
                      child: Column(
                        children: [
                          Image.asset(
                            stack.ausgabefach.last.image, // Display last purchased product image
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 250);
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            stack.ausgabefach.last.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Preis: Ł ${stack.ausgabefach.last.price ~/ 100}', // Display price as an integer
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
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