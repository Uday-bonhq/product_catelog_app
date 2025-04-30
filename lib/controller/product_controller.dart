import 'dart:async';
import 'package:get/get.dart';
import 'package:product_catelog_app/core/utils/debounser.dart';
import 'package:product_catelog_app/data/product_cache.dart';
import 'package:product_catelog_app/domain/product.dart';
import 'package:product_catelog_app/services/api_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // Import the cache class

class ProductController extends GetxController {
  var products = <Product>[].obs;

  var hasMore = true.obs;
  var isError = false.obs;

  final debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
   // Call fetch method
  }

  // int skip = 0; // Pagination skip
  final int limit = 15; // Limit per request
  final RxInt currentPage = 0.obs; // Limit per requestt
  final RxString query = "".obs; // Limit per requestt

   RefreshController refreshController = RefreshController(initialRefresh: false);

  void onSearchChanged(String text) {
    query.value = text;
    debouncer.run(() {
      if(query.value.isNotEmpty){
        fetchProducts(isRefresh: true,search: true);
      }else{
        fetchProducts(isRefresh: true,);
      }

    });
  }

  var isLoading = false.obs;
  var isInitLoading = true.obs;

  refreshData(){
    isInitLoading.value = true;
    products.value = List.generate(10, (i)=> Product( thumbnail: "xzdsdsdsdsdasdsdsad",
        title: "sfsfdfsfffdsfsfdsf"));
  }

  Future<void> fetchProducts({bool isRefresh = false, search = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    if(isRefresh) refreshData();
    String url = "/products";
    Map<String, dynamic> params = {
      'limit': limit,
      'skip': currentPage.value,
    };

    if (search) {
      url = "/products/search";
      params = {
        'q': query,
      };
    }

    try {
      final response = await ApiService.get(url, params: params);

      if (response.statusCode == 200) {
        final List<dynamic> productData = response.data['products'];
        final List<Product> fetchedProducts = productData.map((json) => Product.fromJson(json)).toList();

        ProductCache.storeProducts(fetchedProducts);

        if (isRefresh) {
          products.clear();
          products.value = fetchedProducts;
        } else {
          products.addAll(fetchedProducts);
        }

        hasMore.value = fetchedProducts.length == limit;

        if (isRefresh) {
          refreshController.refreshCompleted();
        } else {
          hasMore.value ? refreshController.loadComplete() : refreshController.loadNoData();
        }
      } else {
        isError(true);
      }
    } catch (e) {
      print("Error: $e");

      final storedProducts = await ProductCache.getStoredProducts();
      if (storedProducts.isNotEmpty) {
        if(search){
          products.clear();
          products.value = storedProducts.where(
                (product) => product.title?.toLowerCase().contains(query.toLowerCase()) ?? false,
          ).toList();
        }else{
          products.value = storedProducts;
        }

      } else {
        products.clear();
        isError(true);
        // showToast("Failed to load products. Please check your connection.");
      }

      if (isRefresh) {
        refreshController.refreshCompleted();
      } else {
        refreshController.loadComplete();
      }
    } finally {
      isLoading(false);
      isInitLoading(false);
    }
  }
}
