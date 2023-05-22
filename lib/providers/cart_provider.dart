import 'package:flutter/material.dart';
import 'package:pharmacyApp/models/cart_item.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'dart:async';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(MedicineItem medicineItem) {
    final existingIndex =
        _items.indexWhere((item) => item.medicineItem == medicineItem);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(medicineItem: medicineItem));
    }

    notifyListeners();
  }

  void removeFromCart(MedicineItem medicineItem) {
    final existingIndex =
        _items.indexWhere((item) => item.medicineItem == medicineItem);

    if (existingIndex >= 0) {
      final currentItem = _items[existingIndex];

      if (currentItem.quantity > 1) {
        currentItem.quantity--;
      } else {
        _items.removeAt(existingIndex);
      }

      notifyListeners();
    }
  }

  void removeItem(MedicineItem medicineItem) {
    _items.removeWhere((cartItem) => cartItem.medicineItem == medicineItem);
    notifyListeners();
  }

  bool isItemInCart(MedicineItem medicineItem) {
    return _items.any((item) =>
        item.medicineItem.productName == medicineItem.productName &&
        item.medicineItem.productImage == medicineItem.productImage &&
        item.medicineItem.price == medicineItem.price &&
        item.medicineItem.description == medicineItem.description);
  }

  void decreaseQuantity(MedicineItem medicineItem) {
    final existingCartItemIndex =
        _items.indexWhere((item) => item.medicineItem.id == medicineItem.id);
    if (_items[existingCartItemIndex].quantity > 1) {
      _items[existingCartItemIndex].quantity--;
      notifyListeners();
    } else {
      removeFromCart(medicineItem);
    }
  }

  StreamController<List<CartItem>> _cartStreamController =
      StreamController<List<CartItem>>.broadcast();

  Stream<List<CartItem>> get cartStream => _cartStreamController.stream;

  @override
  void dispose() {
    _cartStreamController.close();
    super.dispose();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  static CartProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CartProviderWidget>()!
        .provider;
  }
}

class CartProviderWidget extends InheritedWidget {
  final CartProvider provider;

  CartProviderWidget({Key? key, required this.provider, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(CartProviderWidget oldWidget) {
    return provider != oldWidget.provider;
  }

  static CartProviderWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartProviderWidget>();
  }
}
