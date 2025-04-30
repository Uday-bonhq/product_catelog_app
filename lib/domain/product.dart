import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final double? price;

  @HiveField(5)
  final double? discountPercentage;

  @HiveField(6)
  final double? rating;

  @HiveField(7)
  final int? stock;

  @HiveField(8)
  final List<String>? tags;

  @HiveField(9)
  final String? brand;

  @HiveField(10)
  final String? sku;

  @HiveField(11)
  final double? weight;

  @HiveField(13)
  final String? warrantyInformation;

  @HiveField(14)
  final String? shippingInformation;

  @HiveField(15)
  final String? availabilityStatus;

  @HiveField(16)
  final List<Review>? reviews;

  @HiveField(17)
  final String? returnPolicy;

  @HiveField(18)
  final int? minimumOrderQuantity;

  @HiveField(20)
  final List<String>? images;

  @HiveField(21)
  final String? thumbnail;

  Product({
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
    this.images,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'],
      tags: (json['tags'] as List?)?.cast<String>(),
      brand: json['brand'],
      sku: json['sku'],
      weight: (json['weight'] as num?)?.toDouble(),
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      availabilityStatus: json['availabilityStatus'],
      reviews: (json['reviews'] as List?)?.map((r) => Review.fromJson(r)).toList(),
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      images: (json['images'] as List?)?.cast<String>(),
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews?.map((r) => r.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'images': images,
      'thumbnail': thumbnail,
    };
  }
}


@HiveType(typeId: 2)
class Review {
  @HiveField(0)
  final int rating;

  @HiveField(1)
  final String comment;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String reviewerName;

  @HiveField(4)
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}


