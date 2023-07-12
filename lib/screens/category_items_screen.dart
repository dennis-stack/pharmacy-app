import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacyApp/connection/connection.dart';
import 'package:pharmacyApp/models/category_item.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/screens/product_details/product_details_screen.dart';
import 'package:pharmacyApp/widgets/medicine_item_card_widget.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryItem categoryItem;

  const CategoryScreen({required this.categoryItem});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<MedicineItem> medicineItems = [];

  @override
  void initState() {
    super.initState();
    fetchMedicineItems();
  }

  Future<void> fetchMedicineItems() async {
    try {
      final response = await http.get(Uri.parse(
          API.categories + "?productType=${widget.categoryItem.category}"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          medicineItems = jsonData.map((data) {
            return MedicineItem.fromJson(data);
          }).toList();
        });
      } else {
        throw Exception('Failed to fetch medicine items');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to fetch medicine items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryItem.name),
      ),
      body: medicineItems.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
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
            ),
    );
  }
}
