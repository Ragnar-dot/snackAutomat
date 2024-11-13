import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import '../models/product.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});
    
    

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stack = ref.watch(refStack);
    final stackManager = ref.read(refStack.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin-Bereich'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Total Revenue
              Text(
                'Gesamtumsatz: Ł ${(stack.totalRevenue / 100).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  stackManager.restockAllCoins();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Münzbestand nachgefüllt')),
                  );
                },
                child: const Text('Münzbestand nachfüllen'),
              ),
              const SizedBox(height: 20),
              
              // Display Coin Inventory
              const Text(
                'Münzbestand:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stack.coinInventory.length,
                itemBuilder: (context, index) {
                  int coinValue = stack.coinInventory.keys.elementAt(index);
                  int coinCount = stack.coinInventory[coinValue]!;
                  return ListTile(
                    title: Text('Coin ${(coinValue / 100).toStringAsFixed(2)} Ł'),
                    trailing: Text('Anzahl: $coinCount'),
                  );
                },
              ),
              
              const SizedBox(height: 20),

              // Display Product Inventory
              const Text(
                'Produktbestand:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stack.products.length,
                itemBuilder: (context, index) {
                  Product product = stack.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Preis: Ł ${(product.price / 100).toStringAsFixed(2)}'),
                    trailing: Text('Anzahl: ${product.quantity}'),
                    onTap: () {
                      _showRestockDialog(context, product, ref);
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // Display Purchase History
              const Text(
                'Kaufhistorie:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              stack.transactionHistory.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stack.transactionHistory.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> transaction = stack.transactionHistory[index];
                        return ListTile(
                          title: Text(transaction.toString()),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Keine Transaktionen vorhanden',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show the restocking dialog for a product
  void _showRestockDialog(BuildContext context, Product product, WidgetRef ref) {
    TextEditingController quantityController = TextEditingController();
    final stackManager = ref.read(refStack.notifier);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nachfüllen: ${product.name}'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Anzahl',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                stackManager.restockProduct(product.id, quantity);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} um $quantity nachgefüllt')),
                );
              },
              child: const Text('Nachfüllen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }
}