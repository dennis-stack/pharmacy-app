import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/widgets/medicine_item_card_widget.dart';

import 'product_details/product_details_screen.dart';

class ProductListScreen extends StatelessWidget {
  final List<MedicineItem> medicineItems;
  final String category;

  ProductListScreen({required this.medicineItems, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: AppText(
            text: category,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: medicineItems.map((medicineItem) {
            return GestureDetector(
              onTap: () {
                onItemClicked(context, medicineItem);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: MedicineItemCardWidget(
                  item: medicineItem,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void onItemClicked(BuildContext context, MedicineItem medicineItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          medicineItem,
          heroSuffix: "explore_screen",
        ),
      ),
    );
  }
}
