import 'package:hive/hive.dart';

part 'cart_item.g.dart'; // Generated code for Hive

@HiveType(typeId: 1) // Unique typeId for CartItem
class CartItem {
  @HiveField(0)
  final int id; // Product ID

  @HiveField(1)
  final String title; // Product title

  @HiveField(2)
  final double price; // Product price

  @HiveField(3)
  int quantity; // Quantity added to cart

  @HiveField(4)
  String? thumbnail; // Quantity added to cart

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity = 1,
    this.thumbnail,
  });
}
