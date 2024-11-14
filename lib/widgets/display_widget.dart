import 'dart:ui';

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
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 231, 231, 231).withOpacity(0.5),
              borderRadius: BorderRadius.circular(1.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 81, 255, 0).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0,6), // changes position of shadow
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(15, 31, 30, 30),
                  borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 167, 172, 167).withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Betrag: ${(transactionAmount / 100).toStringAsFixed(2)}Ł',
              style: GoogleFonts.tektur(
                fontSize: 18.0,
                color: const Color.fromARGB(193, 10, 104, 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}