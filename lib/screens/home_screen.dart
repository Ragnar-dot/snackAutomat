import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import 'package:snackautomat/providers/coin_provider.dart';

import 'package:snackautomat/screens/admin_screen.dart';
import 'package:snackautomat/screens/vendor_screen.dart';
import '../widgets/product_widget.dart';
import '../widgets/coin_widget.dart';
import '../widgets/display_widget.dart';
import '../widgets/wallet_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  List<String> outputItems = [];

  late AnimationController _blinkController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 6).animate(_blinkController);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stack = ref.watch(refStack);
    final products = stack.products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 204, 204, 204),
        actionsIconTheme: const IconThemeData(color: Color.fromARGB(255, 24, 122, 45)),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Ihre Auswahl...',
              textStyle: const TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(147, 21, 109, 9),
              ),
              speed: const Duration(milliseconds: 200),
            ),
          ],
          totalRepeatCount: 60,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            iconSize: 45,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VendorScreen()),
              );
            },
          ),
          IconButton(
            iconSize: 45,
            icon: FadeTransition(
              opacity: _animation,
              child: const Icon(Icons.key),
            ),
            onPressed: () {
              _showPasswordDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const DisplayWidget(),
          Expanded( // Expanded sorgt dafür, dass die GridView den verfügbaren Platz nutzt
            child: GridView.builder(
              padding: const EdgeInsets.all(1.0),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.80
              ,
              ),
              itemBuilder: (context, index) {
                return ProductWidget(
                  product: products[index],
                );
              },
            ),
          ),
          SizedBox(
            height: 140,
            child: Row(
              children: [
                const WalletWidget(image: 'assets/Wallet/Wallet.png'),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCoins.length,
                    itemBuilder: (context, index) {
                      return CoinWidget(coin: allCoins[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

void _showPasswordDialog() {
  TextEditingController passwordController = TextEditingController();

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
            onPressed: () {
              // Passwort auf "1234" setzen
              if (passwordController.text == "1234") {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminScreen()),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Falsches Passwort')),
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Abbrechen"),
          ),
        ],
      );
    },
  );
}
}