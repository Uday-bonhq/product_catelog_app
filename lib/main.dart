import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catelog_app/data/cart_item.dart';
import 'package:product_catelog_app/data/product.dart';
import 'package:product_catelog_app/data/product_detail.dart';
import 'package:product_catelog_app/screens/product_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(ProductDetailAdapter());
  await Hive.openBox('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: const GetMaterialApp(
        title: 'Product Catalog',
        home: ProductListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


