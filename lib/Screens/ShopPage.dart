import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodsspot/Screens/Checkout.dart';
import 'package:foodsspot/Screens/ProductPage.dart';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String name;
  final String? imageUrl;
  final double price;

  Product({required this.id, required this.name, this.imageUrl, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['images'] != null && json['images'].isNotEmpty ? json['images'][0]['src'] : null,
      price: _parsePrice(json['price']),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0; // Handle parsing errors
    } else {
      return 0;
    }
  }

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
}

class ProductListScreen extends StatefulWidget {@override
_ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473'; // Replace with your WooCommerce consumer key
    final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f'; // Replace with your WooCommerce consumer secret
    final url = Uri.parse(
      'https://foodsspot.com/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&per_page=50',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      setState(() {
        products = Product.fromJsonList(data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load products');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(

        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2 / 3,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the ProductPage with the selected product
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    product: {
                      'id': product.id,
                      'name': product.name,
                      'images': product.imageUrl != null
                          ? [product.imageUrl]
                          : [],
                      'price': product.price,
                      'description': 'Description of ${product.name}', // Add a description here if available
                      'rating': 4.5, // Add actual rating if available
                      'reviews': 100, // Add review count if available
                      'related': [], // Add related products if available
                    },
                  ),
                ),
              );
            },
            child: ProductCard(product: product),
          );

        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: product.imageUrl != null
                  ? Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '\Rs ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}