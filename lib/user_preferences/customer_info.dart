import 'dart:convert';
import 'package:pharmacyApp/models/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerPrefs {
  static Future<void> rememberCustomer(Customer customer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerJsonData = jsonEncode(customer.toJson());
    await preferences.setString("currentUser", customerJsonData);
  }
}
