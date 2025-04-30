import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catelog_app/core/utils/common_exports.dart';
import 'package:product_catelog_app/domain/product.dart';

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

  // Get a product detail by matching the product.id field
  static Future<ProductDetail?> getProductDetail(int id) async {
    final box = await Hive.openBox<ProductDetail>(_boxName);
    return box.values.firstWhere(
          (product) => product.id == id,
      orElse: () => ProductDetail(),
    );
  }
}
