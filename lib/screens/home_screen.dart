import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat/managers/stack_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:snackautomat/providers/coin_provider.dart';
import 'package:snackautomat/screens/admin_screen.dart';
import 'package:snackautomat/screens/vendor_screen.dart';
import '../widgets/product_widget.dart';
import '../widgets/coin_widget.dart';
import '../widgets/display_widget.dart';
import '../widgets/wallet_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<String> outputItems = [];

  @override
  Widget build(BuildContext context) {
    final stack = ref.watch(refStack);
    final stackManager = ref.read(refStack.notifier);
    final products = stack.products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(118, 240, 240, 240),
        actionsIconTheme: const IconThemeData(color: Color.fromARGB(255, 24, 122, 45)),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Ihre Auswahl...',
              textStyle: GoogleFonts.hahmlet(
                fontSize: 30.0,
                color: const Color.fromARGB(147, 21, 109, 9),
              ),
              speed: const Duration(milliseconds: 200),
            ),
          ],
          totalRepeatCount: 1000,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            iconSize: 40,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VendorScreen()),
              );
            },
          ),
          IconButton(
            iconSize: 40,
            color: const Color.fromARGB(26, 214, 51, 51),
            icon: const Icon(Icons.key),
            onPressed: () {
              _showPasswordDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DisplayWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,  // Adjusted height
               child: GridView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  return ProductWidget(
                    product: products[index],
                  );
                },
              ),
            ),
            SizedBox(
              height: 80,
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
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.multiply_square),
                    iconSize: 25.0,
                    onPressed: () {
                      stackManager.resetTransactionAndReturnToWallet();
                    },
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Transaktion abbrechen',
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
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
