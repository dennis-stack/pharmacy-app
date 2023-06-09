import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacyApp/mpesa/payment.dart';
import 'package:pharmacyApp/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutBottomSheet extends StatelessWidget {
  const CheckoutBottomSheet({
    Key? key,
    required this.cartProvider,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.totalItems,
    required this.totalPrice,
  }) : super(key: key);

  final CartProvider cartProvider;
  final double latitude;
  final double longitude;
  final String address;
  final int totalItems;
  final double totalPrice;

  Future<LatLng> coordinatesFromAddress(String address) async {
    final List<Location> locations = await locationFromAddress(address);
    final LatLng coordinates =
        LatLng(locations.first.latitude, locations.first.longitude);
    return coordinates;
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    final apiKey = 'AIzaSyD1vdbDNFe5Xx0fc5Ku0b-gro-F3-L03EA';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final responseBody = json.decode(response.body);
    if (responseBody['status'] == 'OK') {
      final result = responseBody['results'][0];
      final addressComponents = result['address_components'];
      String name = '';
      String locality = '';
      for (final component in addressComponents) {
        final types = List<String>.from(component['types']);
        if (types.contains('establishment')) {
          name = component['short_name'];
        } else if (types.contains('locality')) {
          locality = component['short_name'];
        }
      }
      return '$name, $locality';
    } else {
      throw Exception('Failed to get address');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProvider.of(context);
    final cartItems = cartProvider.items;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Checkout',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          FutureBuilder<List<Placemark>>(
            future: placemarkFromCoordinates(latitude, longitude),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading address...');
              }
              if (snapshot.hasError || snapshot.data == null) {
                return Text('Could not get address');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Address:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<List<Placemark>>(
                    future: placemarkFromCoordinates(latitude, longitude),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      final List<Placemark> placemarks = snapshot.data!;
                      final Placemark placemark = placemarks.first;
                      return Text(
                        '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(item.medicineItem.productName),
                      subtitle: Text(
                          '${item.quantity} x Kshs ${item.medicineItem.price}'),
                      trailing: Text(
                          'Kshs ${item.quantity * item.medicineItem.price}'),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, cartProvider, _) =>
                    Text('${cartProvider.totalItems}'),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Kshs $totalPrice',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              try {
                // Get the current user's phone number from Firebase
                final user = FirebaseAuth.instance.currentUser;
                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .get();
                final String phoneNumber = userDoc['phoneNo'];

                // Call the mpesa payment method
                await PaymentMpesa().makePayment(phoneNumber);

                // Get the CartProvider using the CartProviderWidget
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);

                // Save the order to Firebase
                final ordersCollection =
                    FirebaseFirestore.instance.collection('orders');
                await ordersCollection.add({
                  'userId': user?.uid,
                  'firstName': user?.displayName?.split(' ')[0] ?? '',
                  
                  'lastName': user?.displayName?.split(' ')[1] ?? '',
                  'email': user?.email ?? '',
                  'phoneNumber': phoneNumber,
                  'deliveryCoordinates': GeoPoint(latitude, longitude),
                  'items': cartProvider.items.map((cartItem) {
                    return {
                      'name': cartItem.medicineItem.productName,
                      'quantity': cartItem.quantity,
                      'totalPrice':
                          cartItem.medicineItem.price * cartItem.quantity,
                    };
                  }).toList(),
                  'createdAt': Timestamp.now(),
                });
              } catch (e) {
                print(e.toString());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('An error occurred while processing your payment.'),
                ));
              }

              Navigator.of(context).pop();
            },
            child: Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }
}
