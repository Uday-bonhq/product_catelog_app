import 'dart:async';
import 'package:get/get.dart';
import 'package:product_catelog_app/core/utils/common_exports.dart';

class ProductDetailController extends GetxController {
  Rx<ProductDetail> productData = ProductDetail().obs;
  var isLoading = false.obs;
  var isError = false.obs;

  RxInt imageIndex = 0.obs;

  var isFavorite = false.obs;

  late Box favoritesBox;

  @override
  void onInit() {
    favoritesBox = Hive.box('favorites');
    super.onInit();
  }

  void setProduct(ProductDetail p) {
    productData.value = p;
    checkFavoriteStatus();
  }


  // Fetch products from API or local storage
  Future<void> fetchProductDetail(id) async {
    if(isLoading.value) return;
    isLoading.value = true;
    String url = "/products/$id";
    Map<String,dynamic> params = {};
    try {
      final response = await ApiService.get(
          url,
          params: params
      );

      print("response.domain");
      print(response.data['products']);
      // print(response.domain['products']);
      // Parse the response
      if (response.statusCode == 200) {

        final ProductDetail fetchedProducts = ProductDetail.fromJson(response.data);

        ProductDetailCache.storeProductDetail(fetchedProducts);
        productData.value = fetchedProducts;

        setProduct(fetchedProducts);

      } else {
        isError(true);
      }
    } catch (e) {

      final storedProducts = await ProductDetailCache.getProductDetail(id);
      print("storedProducts?.id");
      print(storedProducts?.id);
      if (storedProducts?.id != null) {

        productData.value = storedProducts ?? ProductDetail();
        setProduct(productData.value);
        isLoading(false);
      } else {
        final storedProducts = await ProductCache.getStoredProduct(id);
        if (storedProducts?.id != null) {
          productData.value = ProductDetail.fromJson(storedProducts!.toJson());
          productData.value.images = [storedProducts.thumbnail ?? ""];
          productData.refresh();
        }else{
          isError(true);
        }

      }
    } finally {
      isLoading(false);
    }
  }



  void checkFavoriteStatus() {
    if (productData.value.id != null) {
      List<int> ids = favoritesBox.values.cast<int>().toList();
      isFavorite.value = ids.contains(productData.value.id);
    }
  }

  ProductDetail? getProductById(int id) {
    return favoritesBox.get(id);
  }

  void toggleFavorite() {
    final p = productData.value;
    if (p.id == null) return;

    if (isFavorite.value) {
      favoritesBox.delete(p.id);
    } else {
      favoritesBox.put(p.id, p.id);
    }
    isFavorite.toggle();
  }


  Future<List<ProductDetail>> getAllFavorites() async {
    List<int> ids = favoritesBox.values.cast<int>().toList();
    print(ids);
    List<ProductDetail> products = [];
    ProductDetail storedProducts = ProductDetail();
    for(int id in ids){
      storedProducts = await ProductDetailCache.getProductDetail(id) ?? ProductDetail();
      if(storedProducts.id != null){
        products.add(storedProducts );
      }
    }

    print(products);
    return products;
  }



}
