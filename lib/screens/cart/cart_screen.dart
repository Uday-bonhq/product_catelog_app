import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/cart_item_controller.dart';
import 'package:product_catelog_app/controller/product_detail_controller.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';
import 'package:product_catelog_app/core/utils/utils.dart';
import 'package:product_catelog_app/data/cart_item_cache.dart';
import 'package:product_catelog_app/domain/cart_item.dart';
import 'package:product_catelog_app/screens/product_detail/product_deatil_screen.dart';
import 'package:product_catelog_app/widgets/cache_network_image.dart';
import 'package:product_catelog_app/widgets/quantity_btn_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ProductDetailController productController = Get.isRegistered() ? Get
      .find() : Get.put(ProductDetailController());

  final CartController cartController = Get.find();

  List<CartItem> cartItems = [];

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  getData() async {
    cartItems = cartController.cartItems();
    cartController.getCartTotalValue(cartItems);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final product = cartItems[index];
          final total = product.price * product.quantity;
          return GestureDetector(
            onTap: () {
              buildGetPage(ProductDetailPage(productId: product.id ?? 0));
            },
            child: ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: buildNetworkImage(
                    width: 70,
                    height: 70,
                    imageUrl: product.thumbnail ?? "",)
              ),
              title: Text(product.title ?? ''),
              subtitle: Row(
                children: [
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(fontSize: 16,
                        color: AppColors.primary,),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              trailing: buildCartButton(product),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: AppColors.primary,
        child: Row(

          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Icon(Icons.shopping_cart_rounded, color: Colors.white,),
            ),
            Obx(() {
              return Text(
                "Total: \$${cartController.cartTotal.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white, fontSize: 20),);
            }),
          ],
        ),
      ),
    );
  }

  buildCartButton(CartItem product) {
    return Obx(() {
      var cartItem = cartController.cartItems
          .firstWhereOrNull((e) => e.id == product.id) ??
          CartItem(id: product.id ?? 0,
              title: product.title ?? "",
              thumbnail: product.thumbnail ?? "",
              price: product.price ?? 0,
              quantity: 0);

      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: cartItem.quantity > 0
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        secondChild: GestureDetector(
          onTap: () {
            cartItem.quantity = cartItem.quantity + 1;
            cartController.addToCart(cartItem);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                Text("Add to Cart", style: TextStyle(fontSize: 14,
                    color:AppColors.primary,
                    fontWeight: FontWeight.bold)),
                SizedBox(width: 5,),
                Icon(Icons.add, color: AppColors.primary, size: 18,),
                SizedBox(width: 1,),
              ],
            ),
          ),
        ),
        firstChild: QuantityButton(
          quantity: cartItem.quantity,
          onAdd: () {
            cartItem.quantity++;
            cartController.updateCartItem(
                cartItem); // Updates both memory & Hive

            cartController.getCartTotalValue(cartItems);
          },
          onRemove: () {
            if (cartItem.quantity > 1) {
              cartItem.quantity--;
              cartController.updateCartItem(cartItem); // Decrease and update
            } else {
              cartController.removeFromCart(cartItem.id); // Remove from cart
              CartCache.removeFromCart(cartItem.id); // Remove from Hive
            }

            cartController.getCartTotalValue(cartItems);
          },
        ),

      );
    });
  }
}
