import 'medicine_item.dart';

class CategoryItem {
  final int? id;
  final String name;
  final String imagePath;
  final String category;
  final List<MedicineItem> medicineItems;

  CategoryItem({
    this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.medicineItems,
  });
}

List<CategoryItem> categoryItems = [
  CategoryItem(
    name: "Painkillers",
    imagePath: "assets/images/categories_images/painkillers.jpg",
    category: "Painkiller",
    medicineItems: [],
  ),
  CategoryItem(
    name: "Syrups",
    imagePath: "assets/images/categories_images/syrups.jpg",
    category: "Syrup",
    medicineItems: [],
  ),
  CategoryItem(
    name: "Antibiotics",
    imagePath: "assets/images/categories_images/antibiotics.jpg",
    category: "Antibiotic",
    medicineItems: [],
  ),
];
