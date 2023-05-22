import 'package:dio/dio.dart';

class PaymentMpesa {
  makePayment(String phone) async {
    var dio = Dio();
    var url = "https://mpesadaraja.up.railway.app/stkpush";

    try {
      var response = await dio.post(url, data: {'phone': phone});
    } catch (error) {
      print(error);
    }
  }
}
