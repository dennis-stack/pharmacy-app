import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) onSearchSubmitted;

  const CustomSearchBar({
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          border: InputBorder.none,
        ),
        onSubmitted: onSearchSubmitted,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            onSearchSubmitted(searchController.text);
            searchController.clear();
            searchFocusNode.unfocus();
          },
        ),
      ],
    );
  }
}
