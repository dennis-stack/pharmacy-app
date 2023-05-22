import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/screens/explore_screen.dart';
import 'package:pharmacyApp/screens/product_details/product_details_screen.dart';
import 'package:pharmacyApp/widgets/medicine_item_card_widget.dart';
import 'package:pharmacyApp/widgets/search_bar_widget.dart';
import 'home_banner_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';

class HomeScreen extends StatefulWidget {
  final List<MedicineItem> medicineItems;

  HomeScreen({required this.medicineItems});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _searchHistory = [];

  get _searchController => _searchController;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _saveSearchHistory();
    _searchController.dispose();
    super.dispose();
  }

  void _saveSearchHistory() async {
    final String searchQuery = _searchController.text;
    if (searchQuery.isNotEmpty &&
        !_searchHistory.contains(searchQuery) &&
        !searchQuery.contains(RegExp(r'[0-9]'))) {
      _searchHistory.add(searchQuery);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('searchHistory', _searchHistory);
    }
  }

  void _loadSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> searchHistory =
        prefs.getStringList('searchHistory') ?? [];
    setState(() {
      _searchHistory = searchHistory;
    });
  }

  void _performSearch(String query) {
    List<MedicineItem> searchResults = widget.medicineItems
        .where((item) =>
            item.productName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (searchResults.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: "No products found",
            fontWeight: FontWeight.w600,
            color: Color(0xFF7C7C7C),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _saveSearchHistory();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Search Results'),
            ),
            body: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<MedicineItem> medicineItems = snapshot.data!.docs
                      .map((doc) => MedicineItem.fromJson(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return GridView.builder(
                    padding: EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: medicineItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(medicineItems[index]),
                            ),
                          );
                        },
                        child: MedicineItemCardWidget(
                          item: medicineItems[index],
                          heroSuffix: "category_screen",
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
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
                  child: locationWidget(),
                ),
                SizedBox(
                  height: 15,
                ),
                // SearchBarWidget(
                //   medicineItems: widget.medicineItems,
                //   onPerformSearch: _performSearch,
                // ),
                // SizedBox(height: 16),
                // SizedBox(
                //   height: 25,
                // ),
                padded(HomeBanner()),
                SizedBox(
                  height: 25,
                ),
                subTitle("Order Now"),
                SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<MedicineItem>>(
                  future: MedicineItem.getMedicineItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No data available'));
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

  Widget locationWidget() {
    String locationIconPath = "assets/icons/location_icon.svg";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          locationIconPath,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "Njoro, Nakuru",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
