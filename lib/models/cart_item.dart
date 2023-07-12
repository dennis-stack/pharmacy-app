import 'medicine_item.dart';

class CartItem {
  final MedicineItem medicineItem;
  int quantity;
  double totalPrice;

  CartItem({
    required this.medicineItem,
    this.quantity = 1,
    this.totalPrice = 0.0,
  }) {
    this.totalPrice = this.quantity * this.medicineItem.price;
  }

  void increaseQuantity() {
    this.quantity++;
    this.totalPrice = this.quantity * this.medicineItem.price;
  }

  void decreaseQuantity() {
    if (this.quantity > 1) {
      this.quantity--;
      this.totalPrice = this.quantity * this.medicineItem.price;
    }
  }

  @override
  String toString() {
    return 'CartItem(medicineItem: $medicineItem, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
