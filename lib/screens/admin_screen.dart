import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import '../providers/stack_manager_provider.dart';
import '../models/product.dart';

class AdminScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackManager = ref.watch(stackManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin-Bereich'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Gesamtumsatz: Coin ${stackManager.totalRevenue.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  stackManager.restockAllCoins();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Münzbestand nachgefüllt')),
                  );
                },
                child: Text('Münzbestand nachfüllen'),
              ),
              SizedBox(height: 20),
              Text(
                'Münzbestand:',
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: stackManager.coinInventory.length,
                itemBuilder: (context, index) {
                  double coinValue = stackManager.coinInventory.keys.elementAt(index);
                  int coinCount = stackManager.coinInventory[coinValue]!;
                  return ListTile(
                    title: Text('Coin ${coinValue.toStringAsFixed(2)}'),
                    trailing: Text('Anzahl: $coinCount'),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Produktbestand:',
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: stackManager.products.length,
                itemBuilder: (context, index) {
                  Product product = stackManager.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Preis: Coin ${product.price.toStringAsFixed(2)}'),
                    trailing: Text('Anzahl: ${product.quantity}'),
                    onTap: () {
                      _showRestockDialog(context, product, stackManager);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Transaktionshistorie:',
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: stackManager.transactionHistory.length,
                itemBuilder: (context, index) {
                  String transaction = stackManager.transactionHistory[index];
                  return ListTile(
                    title: Text(transaction),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRestockDialog(BuildContext context, Product product, StackManager stackManager) {
    TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nachfüllen: ${product.name}'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Anzahl',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int quantity = int.tryParse(_quantityController.text) ?? 0;
                stackManager.restockProduct(product.id, quantity);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} um $quantity nachgefüllt')),
                );
              },
              child: Text('Nachfüllen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }
}