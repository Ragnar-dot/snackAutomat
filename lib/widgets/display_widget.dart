import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';

class DisplayWidget extends ConsumerWidget {
  const DisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAmount = ref.watch(refStack.select((state) => state.transaction));

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(97, 75, 85, 95).withOpacity(0.5),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          'Betrag ${(transactionAmount / 100).toStringAsFixed(2)}Ł', 
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}