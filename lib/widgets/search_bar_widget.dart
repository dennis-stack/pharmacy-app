import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmacyApp/models/medicine_item.dart';

class SearchBarWidget extends StatefulWidget {
  final List<MedicineItem> medicineItems;
  final Function(String) onPerformSearch;

   SearchBarWidget({required this.medicineItems, required this.onPerformSearch});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final String searchIcon = "assets/icons/search_icon.svg";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(0xFFF2F3F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            searchIcon,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Store",
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C7C7C),
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isEmpty || RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  widget.onPerformSearch(value);
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Search query must not contain numbers'))
                  );
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}
