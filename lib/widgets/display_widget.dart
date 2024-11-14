import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
          color: const Color.fromARGB(255, 231, 231, 231).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          'Betrag: ${(transactionAmount / 100).toStringAsFixed(2)}Ł', 
          style: GoogleFonts.tektur(
            fontSize: 18.0,
            color: const Color.fromARGB(193, 10, 104, 10),
          ),
        ),
      ),
    );
  }
}