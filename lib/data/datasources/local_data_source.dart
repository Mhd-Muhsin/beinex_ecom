import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';

abstract class LocalDataSource {
  Future<void> saveCart(Map<String, dynamic> cartMap);
  Map<String, dynamic> getCart();
  Future<void> clearCart();
}

class LocalDataSourceImpl implements LocalDataSource {
  final Box box = Hive.box(Constants.hiveCartBox);

  @override
  Future<void> saveCart(Map<String, dynamic> cartMap) async {
    await box.put('cart', cartMap);
  }

  @override
  Map<String, dynamic> getCart() {
    final raw = box.get('cart');
    if (raw == null) return {};
    return Map<String, dynamic>.from(raw);
  }

  @override
  Future<void> clearCart() async {
    await box.delete('cart');
  }
}
