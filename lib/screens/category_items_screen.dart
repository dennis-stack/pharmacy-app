import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacyApp/models/category_item.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/screens/product_details/product_details_screen.dart';
import 'package:pharmacyApp/widgets/medicine_item_card_widget.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryItem categoryItem;

  const CategoryScreen({required this.categoryItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryItem.name),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medicineProducts')
            .where('productType', isEqualTo: categoryItem.category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<MedicineItem> medicineItems = snapshot.data!.docs
                .map((doc) =>
                    MedicineItem.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            return GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: medicineItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(medicineItems[index]),
                      ),
                    );
                  },
                  child: MedicineItemCardWidget(
                    item: medicineItems[index],
                    heroSuffix: "category_screen",
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
