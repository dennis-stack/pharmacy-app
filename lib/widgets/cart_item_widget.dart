import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/styles/colors.dart';
import 'item_counter_widget.dart';

class CartItemWidget extends StatefulWidget {
  CartItemWidget({Key? key, required this.item, required this.onRemove})
      : super(key: key);

  final MedicineItem item;
  final VoidCallback onRemove;

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  final double height = 110;
  final double borderRadius = 18;
  int amount = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageWidget(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.item.productName,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    AppText(
                      text: widget.item.description,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                    Spacer(),
                    ItemCounterWidget(
                      initialValue: amount,
                      onAmountChanged: (newAmount) {
                        setState(() {
                          amount = newAmount;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: widget.onRemove,
                  icon: Icon(
                    Icons.close,
                    color: AppColors.darkGrey,
                    size: 28,
                  ),
                ),
                Spacer(
                  flex: 5,
                ),
                Container(
                  width: 70,
                  child: AppText(
                    text: "\Kshs${getPrice().toStringAsFixed(2)}",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.right,
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Container(
      width: 100,
      child: Image.network(
        widget.item.productImage,
        fit: BoxFit.cover,
      ),
    );
  }

  double getPrice() {
    return widget.item.price * amount;
  }
}
