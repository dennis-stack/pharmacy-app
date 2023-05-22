import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> initiateMpesaPayment(double amount, String phoneNumber) async {
  final String consumerKey = "aPiPSHH9rQwGqFTdxNYjYAievF3jE7Ya";
  final String consumerSecret = "wFqJ8F5VGIHHxoWP";
  final String baseUrl = "https://sandbox.safaricom.co.ke";

  final String url = "$baseUrl/mpesa/stkpush/v1/processrequest";
  final String tokenUrl =
      "$baseUrl/oauth/v1/generate?grant_type=client_credentials";

  final String auth =
      'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

  // Get access token
  final http.Response tokenResponse = await http.get(
    Uri.parse(tokenUrl),
    headers: {'Authorization': auth},
  );

  final token = jsonDecode(tokenResponse.body)['access_token'];

  // Initiate payment request
  final http.Response response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "BusinessShortCode": "123456",
      "Password": "",
      "Timestamp": "",
      "TransactionType": "CustomerPayBillOnline",
      "Amount": 0,
      "PartyA": phoneNumber,
      "PartyB": "123456",
      "PhoneNumber": phoneNumber,
      "CallBackURL": "http://localhost:3000/payments/callback",
      "AccountReference": "Test",
      "TransactionDesc": "Test"
    }),
  );

  return response.body;
}

Future<String> checkMpesaPaymentStatus(String checkoutRequestId) async {
  final String consumerKey = "aPiPSHH9rQwGqFTdxNYjYAievF3jE7Ya";
  final String consumerSecret = "wFqJ8F5VGIHHxoWP";
  final String baseUrl = "https://sandbox.safaricom.co.ke";

  final String url =
      "$baseUrl/mpesa/stkpushquery/v1/query?checkoutRequestID=$checkoutRequestId";

  final String auth =
      'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

  // Get access token
  final http.Response tokenResponse = await http.get(
    Uri.parse("$baseUrl/oauth/v1/generate?grant_type=client_credentials"),
    headers: {'Authorization': auth},
  );

  final String token = jsonDecode(tokenResponse.body)['access_token'];

  // Check payment status
  final http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.body.isEmpty) {
    return 'Error: Empty response';
  }

  final responseBody = jsonDecode(response.body);

  if (responseBody['errorCode'] != null) {
    return 'Error: ${responseBody['errorMessage']}';
  } else {
    return responseBody['ResultCode'] == 0
        ? 'Payment successful'
        : 'Payment failed';
  }
}
