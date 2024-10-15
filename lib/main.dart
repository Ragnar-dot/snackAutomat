import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Hinzugefügt
import 'screens/home_screen.dart'; // Importieren Sie Ihren HomeScreen
import 'screens/vendor_screen.dart'; // Importieren Sie den neuen VendorScreen

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp())); // ProviderScope hinzugefügt
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snackautomat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VendorScreen(),
    );
  }
}
