import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/styles/colors.dart';

class ItemCounterWidget extends StatefulWidget {
  final ValueChanged<int> onAmountChanged;
  final int initialValue;
  final int minValue; // new parameter to set the minimum value

  ItemCounterWidget({
    Key? key,
    required this.onAmountChanged,
    this.initialValue = 1,
    this.minValue = 1, // default value set to 1
  }) : super(key: key);

  @override
  _ItemCounterWidgetState createState() => _ItemCounterWidgetState();
}

class _ItemCounterWidgetState extends State<ItemCounterWidget> {
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      widget.onAmountChanged(_counter);
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > widget.minValue) {
        // check if current counter value is greater than minValue
        _counter--;
        widget.onAmountChanged(_counter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: _decrementCounter,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: AppText(
              text: '$_counter',
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _incrementCounter,
          ),
        ],
      ),
    );
  }
}
