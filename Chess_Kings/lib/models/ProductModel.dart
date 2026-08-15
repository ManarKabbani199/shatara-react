import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String categoryId;
  final bool deleted;
  final int quantity;
  final int visible;
  final bool hasVariants;
  final Timestamp createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.categoryId,
    required this.deleted,
    required this.quantity,
    required this.visible,
    required this.hasVariants,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      categoryId: data['categoryId'] ?? '',
      deleted: data['deleted'] ?? false,
      quantity: data['quantity'] ?? 0,
      visible: data['visible'] ?? 1,
      hasVariants: data['hasVariants'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'categoryId': categoryId,
      'deleted': deleted,
      'quantity': quantity,
      'visible': visible,
      'hasVariants': hasVariants,
      'createdAt': createdAt,
    };
  }
}
