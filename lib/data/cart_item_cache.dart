import 'package:hive_flutter/hive_flutter.dart';
import 'cart_item.dart';

class CartCache {
  static const String _boxName = 'cartBox';

  // Initialize Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CartItemAdapter());  // Register CartItem adapter
    await Hive.openBox<CartItem>(_boxName);
  }

  // Add item to cart (offline)
  static Future<void> addToCart(CartItem cartItem) async {
    final box = await Hive.openBox<CartItem>(_boxName);
    var existingItem = box.values.firstWhere(
          (item) => item.id == cartItem.id,
      orElse: () => CartItem(id: cartItem.id, title: cartItem.title, price: cartItem.price),
    );
    existingItem.quantity += cartItem.quantity;
    await box.put(cartItem.id, existingItem);
  }

  // Get all cart items (offline)
  static Future<List<CartItem>> getCartItems() async {
    final box = await Hive.openBox<CartItem>(_boxName);
    return box.values.toList();
  }

  // Remove item from cart (offline)
  static Future<void> removeFromCart(int id) async {
    final box = await Hive.openBox<CartItem>(_boxName);
    await box.delete(id);
  }

  // Clear all cart items (offline)
  static Future<void> clearCart() async {
    final box = await Hive.openBox<CartItem>(_boxName);
    await box.clear();
  }
}
