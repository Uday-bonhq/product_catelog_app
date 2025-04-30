import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/product_detail_controller.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';
import 'package:product_catelog_app/core/utils/common_exports.dart';
import 'package:product_catelog_app/screens/product_detail/product_deatil_screen.dart';
import 'package:product_catelog_app/widgets/cache_network_image.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ProductDetailController controller = Get.isRegistered() ? Get.find() : Get.put(ProductDetailController());

  List<ProductDetail> favorites = [];
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    favorites = await controller.getAllFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return  GestureDetector(
            onTap: (){
              Get.to(ProductDetailPage(productId: product.id ?? 0));
              // buildGetPage(ProductDetailPage(productId: product.id ?? 0));
            },
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: buildNetworkImage(
                  width: 70,
                  height: 70,
                  imageUrl: product.thumbnail ?? "",),
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
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text('${product.rating}'),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.favorite, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
