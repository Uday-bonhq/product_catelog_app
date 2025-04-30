import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/cart_item_controller.dart';
import 'package:product_catelog_app/controller/product_controller.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';
import 'package:product_catelog_app/core/utils/utils.dart';
import 'package:product_catelog_app/screens/cart/cart_screen.dart';
import 'package:product_catelog_app/screens/favorate/favorate_list_screen.dart';
import 'package:product_catelog_app/screens/product_list/product_itmes.dart';
import 'package:product_catelog_app/widgets/theme_switch_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((callback){
      productController.refreshController = RefreshController(initialRefresh: false);
      productController.refreshData();
      productController.currentPage.value = 1;
      productController.fetchProducts(isRefresh: true);
    });
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ThemeSwitch(),
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              // color: Colors.black,
            ),
            onPressed: () {
              buildGetPage(FavoritePage());
            },
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: (){
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
              hintStyle: const TextStyle(),
              // fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary,),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary,),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: productController.onSearchChanged,
          ),
        ),
        Expanded(child: buildRefreshChild(child: const ProductItem())),
      ],
    );
  }

  Widget buildRefreshChild({required Widget child}){
    return SmartRefresher(
      header: const WaterDropHeader(
        waterDropColor: AppColors.primary,
      ),
      physics: const BouncingScrollPhysics(),
      controller: productController.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      // enablePullUp: AppointmentProvider.appointmentInstance.hasMore,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: child,
    );
  }





}
