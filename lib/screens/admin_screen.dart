import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});
    
    

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stack = ref.watch(refStack);
    final stackManager = ref.read(refStack.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin-Bereich',
          style: GoogleFonts.tektur(fontSize: 20),
        ),
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
                style: GoogleFonts.tektur(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(193, 10, 104, 10),
                ),
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
              Text(
                'Münzbestand:',
                style: GoogleFonts.tektur(fontSize: 20),
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
              Text(
                'Produktbestand:',
                style: GoogleFonts.tektur(fontSize: 20),
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
              Text(
                'Kaufhistorie:',
                style: GoogleFonts.tektur(fontSize: 20),
              ),
              stack.transactionHistory.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stack.transactionHistory.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> transaction = stack.transactionHistory[index];
                        return ListTile(
                        title: Text(
                              'Produkt: ${transaction['Produkt']}, '
                              'Preis: ${transaction['Preis']} €, '
                              'Zeit: ${transaction['Zeit']}, '
                              'Wechselgeld: ${transaction['Wechselgeld']} €',
                            ),
                        );  
                      },
                    )
                  : Center(
                      child: Text(
                        'Keine Transaktionen vorhanden',
                        style: GoogleFonts.tektur(fontSize: 20),
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