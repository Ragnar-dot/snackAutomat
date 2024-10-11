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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        title: const Text('Der Beste Snackautomat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              _showPasswordDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          DisplayWidget(),
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
          Container(
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

  void _showPasswordDialog() {
    TextEditingController _passwordController = TextEditingController();
    final secureStorage = ref.read(secureStorageProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Admin Login"),
          content: TextField(
            controller: _passwordController,
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
                  // Erstmaliges Setzen des Passworts
                  String hashedPassword = hashPassword(_passwordController.text);
                  await secureStorage.write(key: 'admin_password', value: hashedPassword);
                  Navigator.pop(context); // Dialog schließen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminScreen()),
                  );
                } else {
                  // Passwort überprüfen
                  String hashedInputPassword = hashPassword(_passwordController.text);
                  if (hashedInputPassword == storedHashedPassword) {
                    Navigator.pop(context); // Dialog schließen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
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