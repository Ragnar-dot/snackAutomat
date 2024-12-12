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
          CustomPaint(
            painter: InnerShadowPainter(),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 231, 231, 231).withOpacity(0.5),
                borderRadius: BorderRadius.circular(1.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(34, 81, 255, 0).withOpacity(0.8),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
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
                color: const Color.fromARGB(193, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InnerShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadowPaint = Paint()
      ..color = const Color.fromARGB(255, 13, 170, 13).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 2);

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect outer = RRect.fromRectAndRadius(rect, const Radius.circular(6.0));
    final RRect inner = RRect.fromRectAndRadius(rect.deflate(4.0), const Radius.circular(6.0));

    canvas.drawDRRect(outer, inner, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}