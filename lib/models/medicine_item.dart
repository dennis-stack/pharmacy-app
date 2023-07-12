import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacyApp/connection/connection.dart';

class MedicineItem {
  final String id;
  final String productName;
  final String productType;
  final int quantity;
  final double price;
  final String description;
  final String productImage;

  MedicineItem({
    required this.id,
    required this.productName,
    required this.productType,
    required this.quantity,
    required this.price,
    required this.description,
    required this.productImage,
  });

  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      id: json['id'],
      productName: json['productName'],
      productType: json['productType'],
      quantity: int.parse(json['quantity']),
      price: double.parse(json['price']),
      description: json['description'],
      productImage: json['productImage'],
    );
  }

  static Future<List<MedicineItem>> getMedicineItems() async {
    final response = await http.get(Uri.parse(API.products));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;

      return jsonData.map((data) {
        return MedicineItem.fromJson(data);
      }).toList();
    } else {
      throw Exception('Failed to fetch medicine items');
    }
  }
}
