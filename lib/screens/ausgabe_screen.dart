import 'package:flutter/material.dart';

class AusgabeScreen extends StatelessWidget {
  final double changeAmount;
  final List<String> purchasedProducts;

  const AusgabeScreen({
    super.key,
    required this.changeAmount,
    required this.purchasedProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ausgabe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wechselgeld: Coin ${changeAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ihre gekauften Produkte:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: purchasedProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Image.asset(
                          purchasedProducts[index],
                          height: 250,
                          
                          fit: BoxFit.cover,
                        ),
                        // Weitere Informationen zum Produkt können hier hinzugefügt werden
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
