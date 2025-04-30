import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/core/theme/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catelog_app/controller/theme_controller.dart';
import 'package:product_catelog_app/domain/cart_item.dart';
import 'package:product_catelog_app/domain/product.dart';
import 'package:product_catelog_app/domain/product_detail.dart';
import 'package:product_catelog_app/domain/theme_data.dart';
import 'package:product_catelog_app/screens/product_list/product_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(ProductDetailAdapter());
  Hive.registerAdapter(ThemeModelAdapter());
  await Hive.openBox('favorites');

  Get.put(ThemeController()..loadTheme());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.find();
  // final ThemeController themeController = Get.put(ThemeController());



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        return AnimatedTheme(
          data: themeController.themeMode == ThemeMode.dark
              ? darkTheme
              : lightTheme,
          duration: const Duration(milliseconds: 100), // Smooth fade
          curve: Curves.easeInOut,
          child: GetMaterialApp(
            title: 'Product Catalog',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeController.themeMode,
            home: const ProductListScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}


