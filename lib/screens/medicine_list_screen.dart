import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  late Future<List<MedicineItem>> _medicineItems;

  @override
  void initState() {
    super.initState();
    _medicineItems = MedicineItem.getMedicineItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine List'),
      ),
      body: FutureBuilder<List<MedicineItem>>(
        future: _medicineItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final medicineItems = snapshot.data!;
            return ListView.builder(
              itemCount: medicineItems.length,
              itemBuilder: (context, index) {
                final medicineItem = medicineItems[index];
                return ListTile(
                  leading: Image.network(medicineItem.productImage),
                  title: Text(medicineItem.productName),
                  subtitle: Text(medicineItem.description),
                  trailing: Text('\Kshs${medicineItem.price}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MedicineItem {
  final String productName;
  final String description;
  final String productImage;
  final int price;

  MedicineItem(
      {required this.productName,
      required this.description,
      required this.productImage,
      required this.price});

  factory MedicineItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicineItem(
      productName: data['productName'],
      description: data['Description'],
      productImage: data['productImage'],
      price: data['Price'],
    );
  }

  static Future<List<MedicineItem>> getMedicineItems() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('medicineProducts').get();

    final medicineItems =
        snapshot.docs.map((doc) => MedicineItem.fromDocument(doc)).toList();

    return medicineItems;
  }
}
