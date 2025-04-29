// lib/data/product_cache.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catelog_app/data/product.dart'; // Your Product model

class ProductCache {
  static const String _boxName = 'productBox';

  // Initialize Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());  // Register the product adapter
    await Hive.openBox<Product>(_boxName);
  }

  // Store products in local storage
  static Future<void> storeProducts(List<Product> products) async {
    final box = await Hive.openBox<Product>(_boxName);
    await box.clear(); // Optionally clear the box
    for (var product in products) {
      await box.add(product);
    }
  }

  // Get products from local storage
  static Future<List<Product>> getStoredProducts() async {
    final box = await Hive.openBox<Product>(_boxName);
    return box.values.toList();
  }
}
