import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_text.dart';
import 'package:pharmacyApp/models/medicine_item.dart';
import 'package:pharmacyApp/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:pharmacyApp/screens/map_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: cartProvider.items.isEmpty
          ? Center(
              child: AppText(
                text: "Your cart is empty!",
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C7C7C),
              ),
            )
          : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (BuildContext context, int index) {
                final cartItem = cartProvider.items[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading:
                          Image.network(cartItem.medicineItem.productImage),
                      title: Text(
                        cartItem.medicineItem.productName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider
                                  .decreaseQuantity(cartItem.medicineItem);
                            },
                          ),
                          Text(cartItem.quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.addToCart(cartItem.medicineItem);
                            },
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Kshs ${cartItem.totalPrice = cartItem.medicineItem.price * cartItem.quantity}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          cartProvider.removeItem(cartItem.medicineItem);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartProvider.items.isEmpty
          ? null
          : BottomAppBar(
              child: Container(
                height: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total Items: ${cartProvider.totalItems}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: cartProvider.clearCart,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                                child: Text('Clear Cart'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: Text('Checkout'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
