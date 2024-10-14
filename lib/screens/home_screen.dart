// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/providers/secure_storage_provider.dart';
import '../providers/product_provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/coin_widget.dart';
import '../widgets/display_widget.dart';
import '../widgets/output_slot_widget.dart';
import 'admin_screen.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<String> outputItems = [];

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final coins = ref.watch(coinListProvider);

return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.white, // Optional: Hintergrundfarbe anpassen
    actionsIconTheme: const IconThemeData(color: Colors.black), // Optional: Icon-Farbe anpassen
    title: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Ihre Auswahl...',
          textStyle: const TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 90, 90, 90),
          ),
          speed: const Duration(milliseconds: 200),
        ),
      ],
      totalRepeatCount: 20, // Animation nur einmal abspielen
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    ),
        actions: [
          IconButton(
            icon: const Icon(Icons.key),
            iconSize: 50,
            onPressed: () {
              _showPasswordDialog();
            },
          ),
          // Temporäre Schaltfläche zum Zurücksetzen des Passworts                                     //aktivieren durch ausklammern der Zeilen
          // IconButton(
          //   icon: const Icon(Icons.restore),
          //   onPressed: () {
          //     _resetAdminPassword();
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          const DisplayWidget(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return ProductWidget(
                  product: products[index],
                  onProductPurchased: (productName) {
                    setState(() {
                      outputItems.add(productName);
                    });
                  },
                );
              },
            ),
          ),
          OutputSlotWidget(outputItems: outputItems),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: coins.length,
              itemBuilder: (context, index) {
                return CoinWidget(coin: coins[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
                                                                                                         //aktivieren durch ausklammern der Zeilen
  // void _resetAdminPassword() async {                       
  //   final secureStorage = ref.read(secureStorageProvider);
  //   await secureStorage.delete(key: 'admin_password');
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Das Admin-Passwort wurde zurückgesetzt. Bitte setzen Sie ein neues Passwort.'),
  //     ),
  //   );
  // }

  void _showPasswordDialog() {
    TextEditingController passwordController = TextEditingController();
    final secureStorage = ref.read(secureStorageProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Admin Login"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Passwort",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Passwort überprüfen
                String? storedHashedPassword = await secureStorage.read(key: 'admin_password');

                if (storedHashedPassword == null) {
                  // Kein Passwort gesetzt, neues Passwort speichern
                  String hashedPassword = hashPassword(passwordController.text);
                  await secureStorage.write(key: 'admin_password', value: hashedPassword);

                  Navigator.pop(context); // Dialog schließen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminScreen()),
                  );
                } else {
                  // Passwort überprüfen
                  String hashedInputPassword = hashPassword(passwordController.text);
                  if (hashedInputPassword == storedHashedPassword) {
                    Navigator.pop(context); // Dialog schließen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminScreen()),
                    );
                  } else {
                    // Falsches Passwort
                    Navigator.pop(context); // Dialog schließen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Falsches Passwort')),
                    );
                  }
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog schließen
              },
              child: const Text("Abbrechen"),
            ),
          ],
        );
      },
    );
  }

  String hashPassword(String password) {
    // Importieren 'dart:convert' und 'package:crypto/crypto.dart'
    // für die folgenden Funktionen

    // Ein statisches Salt (für Demo-Zwecke)
    const String salt = "EinSicheresSalt";

    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
