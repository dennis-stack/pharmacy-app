import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pharmacyApp/providers/cart_provider.dart';
import 'package:pharmacyApp/screens/cart/checkout_bottom_sheet.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  // Default location is Egerton Njoro
  LatLng _currentLocation = LatLng(-0.312409, 35.749329);
  GoogleMapController? _mapController;

  String _deliveryAddress = "";

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _markers.add(
        Marker(
          markerId: MarkerId('current-location'),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Future<void> _searchAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      LatLng latLng = LatLng(
        location.latitude,
        location.longitude,
      );

      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 14.0,
        ),
      ));

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('search-location'),
            position: latLng,
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        _currentLocation = latLng;
      });

      // Update delivery address using reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLocation.latitude,
        _currentLocation.longitude,
      );
      String address =
          "${placemarks.first.name}, ${placemarks.first.thoroughfare}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.postalCode}, ${placemarks.first.country}";
      setState(() {
        _deliveryAddress = address;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No results found.'),
        ),
      );
    }
  }

  void _onProceedToPaymentButtonPressed() async {
    if (_currentLocation == LatLng(0.0, 0.0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please wait for location to load"),
        ),
      );
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final totalItems = cartProvider.items.length;
    final totalPrice = cartProvider.totalPrice;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CheckoutBottomSheet(
          cartProvider: cartProvider,
          latitude: _currentLocation.latitude,
          longitude: _currentLocation.longitude,
          address: _deliveryAddress,
          totalItems: totalItems,
          totalPrice: totalPrice,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            _searchAddress(value);
            _searchController.clear();
            _searchFocusNode.unfocus();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchAddress(_searchController.text);
              _searchController.clear();
              _searchFocusNode.unfocus();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.0,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _onProceedToPaymentButtonPressed,
              child: Text('Proceed to Payment'),
            ),
          ),
        ],
      ),
    );
  }
}
