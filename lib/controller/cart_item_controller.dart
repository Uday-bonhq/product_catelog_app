import 'package:get/get.dart';
import 'package:product_catelog_app/data/cart_item.dart';
import 'package:product_catelog_app/data/cart_item_cache.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromCache();
  }

  // Load cart items from local storage (offline)
  Future<void> loadCartFromCache() async {
    isLoading.value = true;
    var items = await CartCache.getCartItems();
    cartItems.value = items;
    isLoading.value = false;
  }

  // Add item to cart (both offline & online)
  Future<void> addToCart(CartItem item) async {
    await CartCache.addToCart(item);  // Save to local storage
    cartItems.add(item);  // Update GetX state
  }

  // Remove item from cart
  Future<void> removeFromCart(int id) async {
    await CartCache.removeFromCart(id);
    cartItems.removeWhere((item) => item.id == id);
  }

  // Clear the cart
  Future<void> clearCart() async {
    await CartCache.clearCart();
    cartItems.clear();
  }

  void updateCartItem(CartItem item) async {
    removeFromCart(item.id);       // Remove old entry
    addToCart(item);               // Add updated entry
    await CartCache.addToCart(item); // Sync with Hive
  }

}
