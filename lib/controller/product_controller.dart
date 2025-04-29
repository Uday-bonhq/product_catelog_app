import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/core/debounser.dart';
import 'package:product_catelog_app/data/cart_item.dart';
import 'package:product_catelog_app/data/product.dart';
import 'package:product_catelog_app/data/product_cache.dart';
import 'package:product_catelog_app/services/api_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // Import the cache class

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var isError = false.obs;

  final debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    fetchProducts();  // Call fetch method
  }


  // getImage() async {
  //   productImage?.value = await _fetchImageAsBytes();
  // }


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

  // Fetch products from API or local storage
  Future<void> fetchProducts({bool isRefresh = false, search = false}) async {
    print("response.data");
    if(isLoading.value) return;
    isLoading.value = true;

    String url = "/products";
    Map<String,dynamic> params = {
      'limit': limit,
      'skip': currentPage.value,
    };
    if(search){
      url = "/products/search";
      params = {
        'q': query,
      };
    }

    try {

      final response = await ApiService.get(
          url,
          params: params
      );

      print("response.data");
      print(response.data['products']);
      // print(response.data['products']);
      // Parse the response
      if (response.statusCode == 200) {

        final List<dynamic> productData = response.data['products'];
        final List<Product> fetchedProducts = productData.map((json) => Product.fromJson(json)).toList();

        // Save to local storage for offline usage
        ProductCache.storeProducts(fetchedProducts);

        if (isRefresh) {
          products.value = fetchedProducts;
        } else {
          products.addAll(fetchedProducts);
        }

        hasMore.value = fetchedProducts.length == limit;

        if (isRefresh) {
          refreshController.refreshCompleted();
        } else {
          if (hasMore.value) {
            refreshController.loadComplete();
          } else {
            refreshController.loadNoData();
          }
        }

      } else {
        // Handle error
        isError(true);
      }
    } catch (e) {
      print("response.data");
      print(e.toString());
      // If no internet, show data from local storage
      final storedProducts = await ProductCache.getStoredProducts();
      if (storedProducts.isNotEmpty) {
        products.value = storedProducts;
      } else {
        isError(true);
      }

      if (isRefresh) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    } finally {
      isLoading(false);
    }
  }





}
