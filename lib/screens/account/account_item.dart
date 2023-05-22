import 'package:flutter/material.dart';
import 'package:pharmacyApp/screens/account/about.dart';
import 'package:pharmacyApp/screens/account/help.dart';
import 'package:pharmacyApp/screens/account/orders.dart';
import 'package:pharmacyApp/screens/account/user_details_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountItem {
  final String label;
  final String iconPath;
  final Widget Function(BuildContext) onTap;

  AccountItem({
    required this.label,
    required this.iconPath,
    required this.onTap,
  });
}

List<AccountItem> accountItems = [
  AccountItem(
    label: "Orders",
    iconPath: "assets/icons/account_icons/orders_icon.svg",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );
      return Container();
    },
  ),
  AccountItem(
    label: "My Details",
    iconPath: "assets/icons/account_icons/details_icon.svg",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserDetailsPage()),
      );
      return Container();
    },
  ),
  AccountItem(
    label: "Help",
    iconPath: "assets/icons/account_icons/help_icon.svg",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HelpScreen()),
      );
      return Container();
    },
  ),
  AccountItem(
    label: "About",
    iconPath: "assets/icons/account_icons/about_icon.svg",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutScreen()),
      );
      return Container();
    },
  ),
];
