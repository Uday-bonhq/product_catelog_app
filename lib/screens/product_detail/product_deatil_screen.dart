import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/cart_item_controller.dart';
import 'package:product_catelog_app/controller/product_detail_controller.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';
import 'package:product_catelog_app/core/utils/utils.dart';
import 'package:product_catelog_app/data/cart_item_cache.dart';
import 'package:product_catelog_app/domain/cart_item.dart';
import 'package:product_catelog_app/domain/product_detail.dart';
import 'package:product_catelog_app/screens/cart/cart_screen.dart';
import 'package:product_catelog_app/widgets/carousel_image_slider.dart';
import 'package:product_catelog_app/widgets/quantity_btn_widget.dart';
import 'package:product_catelog_app/widgets/rating_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';


class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  final ProductDetailController controller = Get.put(ProductDetailController());

  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    // TODO: implement initState
    controller.fetchProductDetail(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        actions: [

          GestureDetector(
            onTap: () {
              buildGetPage(const CartScreen());
            },
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    buildGetPage(const CartScreen());
                  },
                ),

                Obx(() {
                  return Visibility(
                    visible: cartController.cartItems.isNotEmpty,
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                        ),
                        child: Text(
                          (cartController.cartItems.length).toString(),
                          style: TextStyle(color: Colors.white,
                              fontSize: cartController.cartItems.length > 9
                                  ? 10
                                  : 14
                          ),
                        )),
                  );
                })
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        final product = controller.productData.value;
        if (!controller.isLoading.value && product.id == null) return const Center(child: Text("No domain found"));

        return Skeletonizer(
          // enabled: true,
          enabled: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width,height: 250,
                    child: Stack(
                      children: [
                        buildImages(product.images ?? [product.thumbnail ?? ""]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                decoration: BoxDecoration(
                                    color:AppColors.primary,
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: Text('${product.category}'.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,fontSize: 12),
                                )),
                            Obx(() => IconButton(
                              icon: Icon(
                                controller.isFavorite.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: controller.isFavorite.value ? Colors.red : null,
                              ),
                              onPressed: controller.toggleFavorite,
                            )),
                          ],
                        ),


                      ],
                    )),
                const SizedBox(height: 16),
                Text(product.title ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(product.brand ?? '', style: const TextStyle(color: Colors.grey)),




                    const SizedBox(width: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,color: Colors.orange,size: 18,),
                        Text('${product.rating}'),
                      ],
                    ),

                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text('\$${product.price?.toStringAsFixed(2) ?? ''}',
                            style: const TextStyle(fontSize: 20, color: AppColors.primary,)),
                        if (product.discountPercentage != null)
                          Text('${product.discountPercentage}% OFF',
                              style: const TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                    const Spacer(),
                    buildCartButton(product),
                  ],
                ),

                const SizedBox(height: 16),
                Text(product.description ?? '', style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 24),

                const SizedBox(height: 32),
                const Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...?product.reviews?.map((review) => ListTile(
                  subtitle: Text(review.reviewerName, style: const TextStyle(
                      color: AppColors.primary, fontSize: 14),),
                  title: Text(review.comment, style:  TextStyle(fontSize: 16),),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,color: Colors.orange,size: 18,),
                          Text('${review.rating}/5'),
                        ],
                      ),

                      Text(getRelativeTime((review.date ??"").toString()), style: const TextStyle(color: Colors.grey,fontSize: 12),),

                    ],
                  ),
                )),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    showRatingBottomSheet(context);
                  },
                  child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        // border: Border.all(color: AppColors.lightBackground, width: 1.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child:  const Center(child: Text('Submit Review',style: TextStyle(
                        fontSize: 14,fontWeight: FontWeight.bold,
                        color: Colors.white,),))),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  buildCartButton(ProductDetail product){
    return Obx(() {
      var cartItem = cartController.cartItems
          .firstWhereOrNull((e) => e.id == product.id) ??
          CartItem(id: product.id ?? 0, title: product.title ?? "",
              thumbnail: product.thumbnail ?? "", price: product.price ?? 0, quantity: 0);

      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState:  cartItem.quantity > 0 ? CrossFadeState.showFirst: CrossFadeState.showSecond,
        secondChild: GestureDetector(
          onTap: (){
            cartItem.quantity = cartItem.quantity +1;
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold)),
                SizedBox(width: 5,),
                Icon(Icons.add, color:AppColors.primary, size: 18,),
                SizedBox(width: 1,),
              ],
            ),
          ),
        ),
        firstChild: QuantityButton(
          quantity: cartItem.quantity,
          onAdd: () {
            cartItem.quantity++;
            cartController.updateCartItem(cartItem); // Updates both memory & Hive
          },
          onRemove: () {
            if (cartItem.quantity > 1) {
              cartItem.quantity--;
              cartController.updateCartItem(cartItem); // Decrease and update
            } else {
              cartController.removeFromCart(cartItem.id); // Remove from cart
              CartCache.removeFromCart(cartItem.id);      // Remove from Hive
            }
          },
        ),

      );
    });
  }

}
