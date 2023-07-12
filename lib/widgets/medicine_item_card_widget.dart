import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/styles/colors.dart';

class MedicineItemCardWidget extends StatelessWidget {
  const MedicineItemCardWidget({
    Key? key,
    required this.item,
    this.heroSuffix,
  }) : super(key: key);

  final MedicineItem item;
  final String? heroSuffix;

  final double width = 174;
  final double height = 250;
  final Color borderColor = Colors.white;
  final double borderRadius = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: "MedicineItem:" +
                      item.productName +
                      "-" +
                      (heroSuffix ?? ""),
                  child: imageWidget(item),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              text: item.productName,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: item.description,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C7C7C),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                AppText(
                  text: "\KShs ${item.price.toStringAsFixed(2)}",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),
                addWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget(MedicineItem item) {
    return Container(
      width: 50,
      height: 50,
      child: Image.network(
        item.productImage,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Icon(Icons.error);
        },
      ),
    );
  }

  Widget addWidget() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.primaryColor),
      child: Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
