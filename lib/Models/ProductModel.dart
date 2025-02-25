import 'dart:convert';
import 'package:flutter/material.dart';
  import 'package:foodsspot/Screens/Checkout.dart';
import 'package:foodsspot/Screens/ProductPage.dart';
import 'package:http/http.dart' as http;


class Product {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final double price;

  Product({required this.id, required this.name, this.imageUrl, required this.price, required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
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

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String searchQuery = '';
  double minPrice = 50;
  double maxPrice = 5000;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473';
    final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f';
    final url = Uri.parse(
      'https://foodsspot.com/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&per_page=50',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      setState(() {
        products = Product.fromJsonList(data);
        filteredProducts = products;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load products');
    }
  }

  void filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final nameMatch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
        final priceMatch = product.price >= minPrice && product.price <= maxPrice;
        return nameMatch && priceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products (${filteredProducts.length})'),
        // Display count of filtered products
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Filter by Price',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            RangeSlider(
                              values: RangeValues(minPrice, maxPrice),
                              min: 50,
                              max: 5000,
                              divisions: 100,
                              labels: RangeLabels(
                                '\Rs ${minPrice.toStringAsFixed(2)}',
                                '\Rs ${maxPrice.toStringAsFixed(2)}',
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  minPrice = values.start;
                                  maxPrice = values.end;
                                });
                                filterProducts();
                              },
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                filterProducts();
                                Navigator.pop(context);
                              },
                              child: Text('Apply Filters'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterProducts(); // Apply filters when search query changes
                });
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(
        color: Color(0xFF1E552B),

      ))
          : GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2 / 3,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductPage(
                        product: {
                          'id': product.id,
                          'name': product.name,
                          'images': product.imageUrl != null
                              ? [product.imageUrl]
                              : [],
                          'price': product.price,
                          'description': 'Description of ${product.name}',
                          'rating': 4.5,
                          'reviews': 100,
                          'related': [],
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
  }}
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5A5A5A),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
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
