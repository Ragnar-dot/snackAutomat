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
          // Hintergrundbild und Animation
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
          // Start-Button nur anzeigen, wenn er nicht gedrückt wurde
          if (!_isButtonPressed)
            Positioned(
              // Passen Sie hier die Position an
              top: 300, // Vertikale Position
              left: 290, // Horizontale Position
              child: Opacity(
                // Stellen Sie hier die Opazität ein (0.0 bis 1.0)
                opacity: 0.5,
                child: SizedBox(
                  // Passen Sie hier die Größe des Buttons an
                  width: 55,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Entfernen Sie die Mindestgröße, um die Größe des Buttons aus dem SizedBox zu übernehmen
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      // Sie können zusätzliche Stile hier hinzufügen
                    ),
                    onPressed: () {
                      setState(() {
                        _isButtonPressed = true; // Button ausblenden
                      });
                      _controller.forward(from: 0.0); // Animation starten
                    },
                    child: const FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Tap to Start',
                        // Entfernen Sie die feste Schriftgröße
                        // style: TextStyle(fontSize: 8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
