import 'package:hive/hive.dart';
import 'package:product_catelog_app/domain/product.dart';

part 'product_detail.g.dart';

@HiveType(typeId: 4)
class ProductDetail extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? category;

  @HiveField(4)
  double? price;

  @HiveField(5)
  double? discountPercentage;

  @HiveField(6)
  double? rating;

  @HiveField(7)
  int? stock;

  @HiveField(8)
  List<String>? tags;

  @HiveField(9)
  String? brand;

  @HiveField(10)
  String? sku;

  @HiveField(11)
  double? weight;

 

  @HiveField(13)
  String? warrantyInformation;

  @HiveField(14)
  String? shippingInformation;

  @HiveField(15)
  String? availabilityStatus;

  @HiveField(16)
  List<Review>? reviews;

  @HiveField(17)
  String? returnPolicy;

  @HiveField(18)
  int? minimumOrderQuantity;


  @HiveField(20)
  String? thumbnail;

  @HiveField(21)
  List<String>? images;

  ProductDetail({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.thumbnail,
    this.images,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'],
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'],
      sku: json['sku'],
      weight: (json['weight'] as num?)?.toDouble(),
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      availabilityStatus: json['availabilityStatus'],
      reviews: (json['reviews'] as List?)?.map((r) => Review.fromJson(r)).toList(),
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
