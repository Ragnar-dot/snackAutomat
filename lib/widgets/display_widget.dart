// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';

class DisplayWidget extends ConsumerStatefulWidget {
  const DisplayWidget({super.key});

  @override
  _DisplayWidgetState createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends ConsumerState<DisplayWidget> {
  double _oldTransactionAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    final transactionAmount = ref.watch(transactionProvider);

    final tween = Tween<double>(
      begin: _oldTransactionAmount,
      end: transactionAmount,
    );

    _oldTransactionAmount = transactionAmount;

return Padding(
  padding: const EdgeInsets.all(1.0),
  child: TweenAnimationBuilder<double>(
    tween: tween,
    duration: const Duration(milliseconds: 200),
    builder: (context, value, child) {
      return Container(
        padding: const EdgeInsets.all(6.0), // Optional: Innenabstand hinzufügen
        decoration: BoxDecoration(
          color: const Color.fromARGB(97, 75, 85, 95).withOpacity(0.9), // Hintergrundfarbe mit Opazität
          borderRadius: BorderRadius.circular(6.0), // Optional: Abgerundete Ecken
        ),
        child: Text(
          'Betrag: Ł ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255), // Textfarbe anpassen, um Kontrast zu gewährleisten
          ),
        ),
      );
    },
  ),
);
  }
}

