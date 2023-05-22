import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineItem {
  final String id;
  final String productName;
  final String productImage;
  final String productType;
  late final double quantity;
  final double price;
  final String description;

  MedicineItem({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.productType,
    required this.quantity,
    required this.price,
    required this.description,
  });

  factory MedicineItem.fromJson(Map<String, dynamic> data) {
    return MedicineItem(
      id: data['id'].toString(),
      productName: data['productName'],
      productImage: data['productImage'],
      productType: data['productType'],
      quantity: data['Quantity'].toDouble(),
      price: data['Price'].toDouble(),
      description: data['Description'],
    );
  }

  toJson() {
    return MedicineItem(
      id: id,
      productName: productName,
      price: price,
      quantity: quantity,
      description: description,
      productImage: productImage,
      productType: productType,
    );
  }

  static Future<List<MedicineItem>> getMedicineItems() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('medicineProducts').get();
    return snapshot.docs
        .map((doc) => MedicineItem.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static MedicineItem? fromMap(Map<String, dynamic>? data) {
    if (data == null) return null;

    final id = data['id'] as String?;
    final name = data['productName'] as String?;
    final price = data['Price'] as double;
    final quantity = data['Quantity'] as double;
    final description = data['Description'] as String?;
    final imageUrl = data['productImage'] as String?;
    final productType = data['productType'] as String?;

    if (id == null ||
        name == null ||
        description == null ||
        imageUrl == null ||
        productType == null) {
      return null;
    }

    return MedicineItem(
      id: id,
      productName: name,
      price: price,
      quantity: quantity,
      description: description,
      productImage: imageUrl,
      productType: productType,
    );
  }
}
