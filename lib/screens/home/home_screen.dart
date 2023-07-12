import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/connection/connection.dart';
import 'package:pharmacyApp/screens/explore_screen.dart';
import 'package:pharmacyApp/screens/product_details/product_details_screen.dart';
import 'package:pharmacyApp/widgets/medicine_item_card_widget.dart';
import 'home_banner_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final List<MedicineItem> medicineItems;
  HomeScreen({required this.medicineItems});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<MedicineItem>>? _medicineItemsFuture;

  @override
  void initState() {
    super.initState();
    _refreshMedicineItems();
  }

  Future<void> _refreshMedicineItems() async {
    setState(() {
      _medicineItemsFuture = fetchMedicineItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshMedicineItems,
          child: Container(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SvgPicture.asset(
                    "assets/icons/med_icon.svg",
                    height: 40,
                    width: 40,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: locationWidget(context),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  padded(HomeBanner()),
                  SizedBox(
                    height: 25,
                  ),
                  subTitle("Order Now"),
                  SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<List<MedicineItem>>(
                    future: _medicineItemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Text('No data available'),
                        );
                      } else {
                        final medicineItems = snapshot.data!.take(6).toList();
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: medicineItems.map((medicineItem) {
                            return GestureDetector(
                              onTap: () {
                                onItemClicked(context, medicineItem);
                              },
                              child: MedicineItemCardWidget(
                                item: medicineItem,
                                heroSuffix: "home_screen",
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  void onItemClicked(BuildContext context, MedicineItem medicineItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          medicineItem,
          heroSuffix: "home_screen",
        ),
      ),
    );
  }

  Widget subTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget locationWidget(BuildContext context) {
    String locationIconPath = "assets/icons/location_icon.svg";

    return FutureBuilder<Position>(
      future: Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        } else {
          final position = snapshot.data!;
          final latitude = position.latitude;
          final longitude = position.longitude;

          return FutureBuilder<List<Placemark>>(
            future: placemarkFromCoordinates(latitude, longitude),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data available');
              } else {
                final placemarks = snapshot.data!;
                final location = placemarks.first.locality ?? '';

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      locationIconPath,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "$location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }

  Future<List<MedicineItem>> fetchMedicineItems() async {
    final response = await http.get(Uri.parse(API.products));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return List<MedicineItem>.from(
        jsonData.map((data) => MedicineItem.fromJson(data)),
      );
    } else {
      throw Exception('Failed to fetch medicine items');
    }
  }
}
