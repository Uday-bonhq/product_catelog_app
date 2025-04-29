import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catelog_app/data/product.dart';
import 'package:product_catelog_app/data/product_detail.dart';

class ProductDetailCache {
  static const String _boxName = 'productDetailBox';

  // Initialize Hive for ProductDetail
  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductDetailAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ReviewAdapter());
    }



    await Hive.openBox<ProductDetail>(_boxName);
  }

  // Store a single product detail
  static Future<void> storeProductDetail(ProductDetail productDetail) async {
    final box = await Hive.openBox<ProductDetail>(_boxName);
    await box.put(productDetail.id, productDetail);
  }

  // Get a product detail by ID
  static Future<ProductDetail?> getProductDetail(int id) async {
    final box = await Hive.openBox<ProductDetail>(_boxName);
    return box.get(id);
  }

  // Optionally get all stored product details
  static Future<List<ProductDetail>> getAllStoredDetails() async {
    final box = await Hive.openBox<ProductDetail>(_boxName);
    return box.values.toList();
  }

  // Clear cache (if needed)
  static Future<void> clearCache() async {
    final box = await Hive.openBox<ProductDetail>(_boxName);
    await box.clear();
  }
}
