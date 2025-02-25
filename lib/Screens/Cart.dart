
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodsspot/Screens/Checkout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> _saveCartItems() async {
    final storage = FlutterSecureStorage();
    String cartData = jsonEncode(widget.cartItems.map((item) {
      return {
        'product': item.product,
        'quantity': item.quantity,
      };
    }).toList());
    await storage.write(key: 'cartItems', value: cartData);
  }

  void _incrementQuantity(int index) {
    setState(() {
      widget.cartItems[index].quantity++;
    });
    _saveCartItems();
  }

  void _decrementQuantity(int index) {
    if (widget.cartItems[index].quantity > 1) {
      setState(() {
        widget.cartItems[index].quantity--;
      });
      _saveCartItems();
    }
  }

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
    _saveCartItems();
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var item in widget.cartItems) {
      // Convert price to double, handle potential errors
      double price = double.tryParse(item.product['price'] ?? '0') ?? 0;
      total += price * item.quantity;
    }
    return total;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                var item = widget.cartItems[index];
                return ListTile(
                  leading: item.product['images'] != null && item.product['images'].isNotEmpty
                      ? Image.network(item.product['images'][0])
                      : Container(width: 50, height: 50, color: Colors.grey), // Placeholder if no image
                  title: Text(item.product['name']),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (item.quantity > 1) {
                              item.quantity--;
                            } else {
                              widget.cartItems.removeAt(index);
                            }
                          });
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            item.quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: Rs ${_calculateTotalPrice().toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(cartItems: widget.cartItems),
                      ),
                    );
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }}