import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../managers/stack_manager.dart';
import 'coin_provider.dart';
import 'product_provider.dart';

final stackManagerProvider = Provider<StackManager>((ref) {
  return StackManager(
    initialProducts: ref.read(productListProvider),
    initialCoins: ref.read(coinListProvider),
  );
});