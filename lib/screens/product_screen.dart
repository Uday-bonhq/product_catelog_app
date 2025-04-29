import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/cart_item_controller.dart';
import 'package:product_catelog_app/data/cart_item.dart';
import 'package:product_catelog_app/controller/product_controller.dart';
import 'package:product_catelog_app/data/cart_item_cache.dart';
import 'package:product_catelog_app/screens/favorate_list_screen.dart';
import 'package:product_catelog_app/screens/product_deatil_screen.dart';
import 'package:product_catelog_app/widgets/cache_network_image.dart';
import 'package:product_catelog_app/widgets/quantity_btn_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});


  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CartController cartController = Get.put(CartController());

  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    // productController.refreshController = RefreshController(initialRefresh: false);
    // TODO: implement initState
    super.initState();
  }

  void _onRefresh() async {
    productController.currentPage.value = 1;
    await productController.fetchProducts(isRefresh: true);
  }

  void _onLoading() async {
    if (productController.hasMore.value) {
      productController.currentPage.value =
          productController.currentPage.value + 15;
      await productController.fetchProducts();
      productController.refreshController.loadComplete();
    } else {
      productController.refreshController.loadComplete();
      // await productController.refreshController.loadNoData();
    }
  }

  @override
  void dispose() {
    productController.refreshController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Get.to(() => FavoritePage());
            },
          ),

          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {

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
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            onChanged: productController.onSearchChanged,
          ),
        ),
        Expanded(child: buildPagination()),
      ],
    );
  }


  Widget buildPagination() {
    return Obx(() {
      return SmartRefresher(
        header: const WaterDropHeader(
          waterDropColor: Colors.blue,
        ),
        controller: productController.refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 50, top: 20),
          itemCount: productController.products.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return buildProduct(index);
          },
        ),
      );
    });
  }

  buildProduct(index) {
    final product = productController.products[index];

    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailPage(productId: product.id ?? 0));
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: buildNetworkImage(imageUrl: product.thumbnail ?? "",width : 70.0, height : 70.0,)
        ),
        title: Text(
          product.title ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              '\$${product.price}',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
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
                  border: Border.all(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.add, color: Colors.blue, size: 18,),
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
