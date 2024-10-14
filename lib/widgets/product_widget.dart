import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/transaction_provider.dart';
import '../providers/stack_manager_provider.dart';

class ProductWidget extends ConsumerWidget {
  final Product product;
  final Function(String) onProductPurchased;

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

    return GlowContainer(
      color: Colors.transparent,
      glowColor: const Color.fromRGBO(255, 255, 255, 1),
      borderRadius: BorderRadius.circular(8.0),
      blurRadius: 3.0,
      spreadRadius: 1.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Column(
          children: [
            Image.asset(
              product.image,
              height: 90,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text('Preis: Coin ${product.price.toStringAsFixed(2)}'),
            Text('Verfügbar: ${product.quantity}'),
            const SizedBox(height: 3.0),
            product.quantity < 1
                ? const Text(
                    'Ausverkauft',
                    style: TextStyle(color: Colors.red),
                  )
                : remainingAmount > 0
                    ? Text(
                        'Noch fehlend: Coin ${remainingAmount.toStringAsFixed(2)}')
                    : Container(),
            const SizedBox(height: 8.0),
            _AnimatedPurchaseButton(
              isEnabled: transactionAmount >= product.price &&
                  product.quantity > 0,
              onPressed: () {
                // Produkt kaufen
                stackManager.addRevenue(product.price);
                ref.read(transactionProvider.notifier).resetTransaction();
                stackManager.reduceProductStock(product.id);
                onProductPurchased(product.name);

                // Wechselgeld berechnen
                double changeAmount = transactionAmount - product.price;
                if (changeAmount > 0) {
                  List<double> change =
                      stackManager.calculateChange(changeAmount);
                  if (change.isNotEmpty) {
                    onProductPurchased(
                        'Wechselgeld: Coin ${changeAmount.toStringAsFixed(2)}');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Nicht genügend Wechselgeld verfügbar.')),
                    );
                  }
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} gekauft!')),
                );
              },
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class _AnimatedPurchaseButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _AnimatedPurchaseButton({
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  __AnimatedPurchaseButtonState createState() =>
      __AnimatedPurchaseButtonState();
}

class __AnimatedPurchaseButtonState extends State<_AnimatedPurchaseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? widget.onPressed : null,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color:
                widget.isEnabled ? Colors.blueAccent : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            'Kaufen',
            style: TextStyle(
              color: widget.isEnabled ? Colors.white : Colors.grey.shade200,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}