import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/cart_item_controller.dart';
import 'package:product_catelog_app/controller/product_controller.dart';
import 'package:product_catelog_app/core/utils/animated_list.dart';
import 'package:product_catelog_app/core/utils/skeliton_shimmer.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';
import 'package:product_catelog_app/core/utils/utils.dart';
import 'package:product_catelog_app/data/cart_item_cache.dart';
import 'package:product_catelog_app/domain/cart_item.dart';
import 'package:product_catelog_app/screens/product_detail/product_deatil_screen.dart';
import 'package:product_catelog_app/widgets/cache_network_image.dart';
import 'package:product_catelog_app/widgets/quantity_btn_widget.dart';


class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem>
    with TickerProviderStateMixin {

  final CartController cartController = Get.find();
  final ProductController productController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildTestWidget();
  }

  buildTestWidget() {
    return Obx(() {
      return SkeletonSimmer(
        isLoading: productController.isInitLoading.value,
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: productController.products.isNotEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          secondChild: const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 500,
                child: Center(child: Text("No Data Found"))),
          ),
          firstChild: AnimatedListViewBuilder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productController.products.length,
            padding: const EdgeInsets.only(bottom: 100, top: 20,),
            itemBuilder: (context, index) {
              return buildProduct(index);
            },
          ),
        ),
      );
    });
  }

  buildProduct(index) {
    final product = productController.products[index];

    return GestureDetector(
      onTap: () async {
        await buildGetPage(ProductDetailPage(productId: product.id ?? 0))!.then((
            onValue) {
          FocusScope.of(context).unfocus();
        });
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: buildNetworkImage(
              imageUrl: product.thumbnail ?? "", width: 70.0, height: 70.0,)
        ),
        title: Text(
          product.title ?? "N/A",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              '\$${product.price}',
              style:  TextStyle(fontSize: 16, color: AppColors.primary,),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text('${product.rating}'),
              ],
            ),
          ],
        ),
        trailing: Obx(() {
          var cartItem = cartController.cartItems
              .firstWhereOrNull((e) => e.id == product.id) ??
              CartItem(id: product.id ?? 0,
                  title: product.title ?? "",
                  price: product.price ?? 0,
                  thumbnail: product.thumbnail ?? "",
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary,  width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.add, color: AppColors.primary, size: 18,),
              ),
            ),
            firstChild: QuantityButton(
              quantity: cartItem.quantity,
              onAdd: () {
                cartItem.quantity++;
                cartController.updateCartItem(
                    cartItem); // Updates both memory & Hive
              },
              onRemove: () {
                if (cartItem.quantity > 1) {
                  cartItem.quantity--;
                  cartController.updateCartItem(
                      cartItem); // Decrease and update
                } else {
                  cartController.removeFromCart(
                      cartItem.id); // Remove from cart
                  CartCache.removeFromCart(cartItem.id); // Remove from Hive
                }
              },
            ),

          );
        }),
      ),
    );
  }
}