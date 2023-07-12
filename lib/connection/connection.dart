class API {
  static const hostConnect = "http://dynamic-ip.ddns.net/pharmacy_app_api";
  static const hostConnectUser = "$hostConnect/customer";
  static const imageBaseUrl = "$hostConnect/images/";

  // User Registration and Login
  static const registration = "$hostConnectUser/registration.php";
  static const login = "$hostConnectUser/login.php";

  //User Details and Logout
  static const details = "$hostConnectUser/details.php";
  static const update = "$hostConnectUser/update.php";
  static const logout = "$hostConnectUser/logout.php";

  //Medicine Products
  static const products = "$hostConnectUser/products.php";
  static const categories = "$hostConnectUser/categories.php";

  //Orders
  static const orders = "$hostConnectUser/orders.php";
}
