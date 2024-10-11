import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';

class DisplayWidget extends ConsumerWidget {
  const DisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAmount = ref.watch(transactionProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Eingeworfener Betrag: Coin ${transactionAmount.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}