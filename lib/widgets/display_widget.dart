// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';

class DisplayWidget extends ConsumerStatefulWidget {
  const DisplayWidget({super.key});

  @override
  _DisplayWidgetState createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends ConsumerState<DisplayWidget> {
  @override
  Widget build(BuildContext context) {
    final stack = ref.watch(refStack);
    final transactionAmount = stack.transaction;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        padding: const EdgeInsets.all(6.0), // Optional: Innenabstand hinzufügen
        decoration: BoxDecoration(
          color: const Color.fromARGB(97, 75, 85, 95).withOpacity(0.5), // Hintergrundfarbe mit Opazität
          borderRadius: BorderRadius.circular(6.0), // Optional: Abgerundete Ecken
        ),
        child: Text(
          'Betrag ${(transactionAmount / 100).toStringAsFixed(2)}Ł', 
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255), // Textfarbe anpassen, um Kontrast zu gewährleisten
          ),
        ),
      ),
    );
  }
}