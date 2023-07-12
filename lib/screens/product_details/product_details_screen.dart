import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'favourite_toggle_icon_widget.dart';
import 'package:pharmacyApp/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final MedicineItem medicineItem;
  final String? heroSuffix;

  const ProductDetailsScreen(this.medicineItem, {this.heroSuffix});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int amount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getImageHeaderWidget(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        widget.medicineItem.productName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: AppText(
                        text: widget.medicineItem.description,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7C7C7C),
                      ),
                      trailing: FavoriteToggleIcon(),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "\KShs ${getTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Product Type"),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Dosage",
                        customWidget: nutritionWidget()),
                    Divider(thickness: 1),
                    Spacer(),
                    AppButton(
                      label: "Add To Cart",
                      onPressed: () {
                        CartProvider cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        if (cartProvider.isItemInCart(widget.medicineItem)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Item is already in the cart!"),
                            duration: Duration(seconds: 2),
                          ));
                        } else {
                          cartProvider.addToCart(widget.medicineItem);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Item added to cart successfully!"),
                            duration: Duration(seconds: 1),
                          ));
                          print("Items in Cart: ${cartProvider.items}");
                        }
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageHeaderWidget() {
    return Container(
      height: 450,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        gradient: new LinearGradient(
          colors: [
            const Color(0xFF3366FF).withOpacity(0.1),
            const Color(0xFF3366FF).withOpacity(0.09),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Hero(
        tag: "MedicineItem:" +
            widget.medicineItem.productName +
            "-" +
            (widget.heroSuffix ?? ""),
        child: Image.network(
          widget.medicineItem.productImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget getProductDataRowWidget(String label, {Widget? customWidget}) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          AppText(text: label, fontWeight: FontWeight.w600, fontSize: 16),
          Spacer(),
          if (customWidget != null) ...[
            customWidget,
            SizedBox(
              width: 20,
            )
          ],
          if (label != "Dosage")
            AppText(
              text: widget.medicineItem.productType,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xff7C7C7C),
            ),
        ],
      ),
    );
  }

  Widget nutritionWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text: "As directed by Doctor/Physician",
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xff7C7C7C),
      ),
    );
  }

  double getTotalPrice() {
    return amount * widget.medicineItem.price;
  }
}

class AddToCartButton extends StatelessWidget {
  final MedicineItem medicineItem;

  const AddToCartButton({Key? key, required this.medicineItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final cartProvider = CartProvider.of(context);
        cartProvider.addToCart(medicineItem);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Add to cart'),
          Icon(Icons.shopping_cart_outlined),
        ],
      ),
    );
  }
}
