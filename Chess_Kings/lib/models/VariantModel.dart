import 'package:cloud_firestore/cloud_firestore.dart';

class VariantModel {
  final String id;
  final String color;
  final String size;
  final double price;
  final int stock;
  final String image;

  VariantModel({
    required this.id,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory VariantModel.fromMap(Map<String, dynamic> data, String documentId) {
    return VariantModel(
      id: documentId,
      color: data['color'] ?? '',
      size: data['size'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'size': size,
      'price': price,
      'stock': stock,
      'image': image,
    };
  }
}
