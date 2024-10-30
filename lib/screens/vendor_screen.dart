// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'home_screen.dart'; // Importieren Sie Ihren HomeScreen

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _zoomAnimation;

  bool _isButtonPressed = false; // Um den Button nach dem Drücken auszublenden

  @override
  void initState() {
    super.initState();

    _isButtonPressed = false; // Button anzeigen

    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Gesamtdauer der Animation
      vsync: this,
    );

    // Animation für den Bildwechsel (0.0 bis 1.0)
    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Animation für den Zoom-in-Effekt
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    // Listener für das Ende der Animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reset des Buttons und Controllers beim erneuten Aufbau
    if (_controller.status == AnimationStatus.dismissed && _isButtonPressed) {
      setState(() {
        _isButtonPressed = false;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Bestimmen, welches Bild angezeigt werden soll
                String imagePath;
                if (_imageAnimation.value < 0.33) {
                  imagePath = 'assets/Vendor/Vendor1.png';
                } else if (_imageAnimation.value < 0.66) {
                  imagePath = 'assets/Vendor/Vendor2.png';
                } else {
                  imagePath = 'assets/Vendor/Vendor3.png';
                }

                // Anwenden des Zoom-in-Effekts
                return Transform.scale(
                  scale: _zoomAnimation.value,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
            if (!_isButtonPressed) // Button nur anzeigen, wenn er nicht gedrückt wurde
              Stack(
              children: [
                 Positioned(
                    top: 550, // Abstand vom oberen Rand
                    right: 228, // Abstand vom rechten Rand
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                    ),
                    onPressed: () {
                  setState(() {
                    _isButtonPressed = true; // Button ausblenden
                  });
            _controller.forward(from: 0.0); // Animation starten
          },
          child: const Text(
            'Tap to Start',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    ],
  ),
],
),
);
}
}

  
