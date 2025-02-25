import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodsspot/Screens/Cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../methods/favouriteService.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  List<CartItem> cartItems = [];
  List<dynamic> variations = [];
  bool isLoading = true;
  int? selectedVariationId; // Track selected variation
  List<dynamic> relatedProducts = [];
  bool isFetchingRelatedProducts = false;
  List<dynamic> customFields = []; // Store fetched custom fields
  Map<String, dynamic> selectedOptions = {}; // Store selected options
  bool isFetchingCustomFields = false; // Add loading state
  bool isFavorite = false;
  Map<String, String> selectedSubOptions = {};
  Map<String, bool> showSubOptions = {};
  @override
  void initState() {
    super.initState();
    _fetchProductVariations();
    _fetchRelatedProducts();
    _fetchCustomFields();
    _buildCustomFields();
    _checkIfFavorite();
  }
  Future<void> _checkIfFavorite() async {
    bool favoriteStatus = await FavoriteService.isFavorite(widget.product['id']);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }
  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await FavoriteService.removeFavorite(widget.product['id']);
    } else {
      await FavoriteService.addFavorite({
        'id': widget.product['id'],
        'name': widget.product['name'],
        'description': widget.product['description'],
        'price': widget.product['price'],
        'image': widget.product['image'], // Ensure API provides an image
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }
  Future<void> _fetchCustomFields() async {
    setState(() {
      isFetchingCustomFields = true;
    });
    final productId = widget.product['id'];
    final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473';
    final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f';
    final url =
        'https://foodsspot.com/wp-json/wc/v3/products/$productId?consumer_key=$consumerKey&consumer_secret=$consumerSecret';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final productData = json.decode(response.body);
        final metaData = productData['meta_data'];
        if (metaData != null && metaData is List) {
          final wapfFieldGroup = metaData.firstWhere(
                (meta) => meta['key'] == '_wapf_fieldgroup',
            orElse: () => {},
          );
          if (wapfFieldGroup != null && wapfFieldGroup['value'] != null &&
              wapfFieldGroup['value']['fields'] != null) {
            final fields = wapfFieldGroup['value']['fields'];
            setState(() {
              customFields = fields;
              for (var field in customFields) {
                if (field['type'] == 'select' &&
                    field['options']['choices'].any((choice) {
                      // Ensure conditionals is a List before calling isNotEmpty
                      if (field['conditionals'] != null && field['conditionals'] is List) {
                        return field['conditionals'].isNotEmpty;
                      }
                      return false; // Return false if conditionals is not a List
                    })) {
                  showSubOptions[field['id']] = false;
                }
              }
              isFetchingCustomFields = false; // Loading complete
            });
          } else {
            print('No _wapf_fieldgroup or fields found in meta_data.');
            setState(() {
              isFetchingCustomFields = false;
            });
          }
        } else {
          print('meta_data is null or not a list.');
          setState(() {
            isFetchingCustomFields = false;
          });
        }
      } else {
        setState(() {
          isFetchingCustomFields = false;
        });
        throw Exception('Failed to load custom fields');
      }
    } catch (e) {
      print('Error fetching custom fields: $e');
      setState(() {
        isFetchingCustomFields = false;
      });
    }
  }
  Widget _buildCustomFields() {
    if (isFetchingCustomFields) {
      return Center(child: CircularProgressIndicator()); // Show loading indicator
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: customFields.map<Widget>((field) {
        if (field['conditionals'] != null && field['conditionals'].isNotEmpty) {
          bool shouldShow = _checkConditionals(field);
          if (!shouldShow) {
            return SizedBox.shrink();
          }
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field['label'], style: TextStyle(fontWeight: FontWeight.bold)),
              _buildFieldWidget(field),
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _checkConditionals(dynamic field) {
    for (var conditionGroup in field['conditionals']) {
      for (var rule in conditionGroup['rules']) {
        String parentFieldId = rule['field'];
        String expectedValue = rule['value'];
        String condition = rule['condition'];

        String? parentSelectedValue = selectedOptions[parentFieldId];

        if (parentSelectedValue == null) {
          return false;
        }

        if (condition == '==') {
          if (parentSelectedValue != expectedValue) {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return true;
  }

  Widget _buildFieldWidget(dynamic field) {
    if (field['type'] == 'select') {
      return DropdownButton<String>(
        value: selectedOptions[field['id']],
        items: field['options']['choices'].map<DropdownMenuItem<String>>((choice) {
          return DropdownMenuItem<String>(
            value: choice['slug'],
            child: Text(choice['label']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedOptions[field['id']] = value!;
          });
        },
      );
    } else if (field['type'] == 'radio') {
      return Column(
        children: field['options']['choices'].map<Widget>((choice) {
          return RadioListTile<String>(
            title: Text(choice['label']),
            value: choice['slug'],
            groupValue: selectedOptions[field['id']],
            onChanged: (value) {
              setState(() {
                selectedOptions[field['id']] = value!;
              });
            },
          );
        }).toList(),
      );
    }
    return Text('Unsupported field type');
  }
  Future<void> _fetchRelatedProducts() async {
    setState(() {
      isFetchingRelatedProducts = true;
    });

    try {
      if (widget.product['categories'] != null && widget.product['categories'] is List && widget.product['categories'].isNotEmpty) {
        final categoryId = widget.product['categories'][0]['id']; // Using first category for now

        final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473';
        final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f';
        final url =
            'https://foodsspot.com/wp-json/wc/v3/products?category=$categoryId&per_page=10&consumer_key=$consumerKey&consumer_secret=$consumerSecret';

        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          setState(() {
            relatedProducts = decodedResponse;
            isFetchingRelatedProducts = false;
          });
          print('Related products fetched successfully: ${relatedProducts.length} items');
        } else {
          print('Failed to load related products. Status code: ${response.statusCode}');
          setState(() {
            isFetchingRelatedProducts = false;
            relatedProducts = []; // Set empty if failed
          });
          throw Exception('Failed to load related products');
        }
      } else {
        print('Categories are null or empty for product: ${widget.product['id']}');
        setState(() {
          isFetchingRelatedProducts = false;
          relatedProducts = []; // Set relatedProducts to an empty list
        });
      }
    } catch (e) {
      print('Error fetching related products: $e');
      setState(() {
        isFetchingRelatedProducts = false;
        relatedProducts = []; // Set empty on error
      });
    }
  }


  Future<void> _fetchProductVariations() async {
    final productId = widget.product['id'];
    final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473'; // Replace with your WooCommerce consumer key
    final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f'; // Replace with your WooCommerce consumer secret
    final url =
        'https://foodsspot.com/wp-json/wc/v3/products/$productId/variations/?per_page=50&consumer_key=$consumerKey&consumer_secret=$consumerSecret';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          variations = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load variations');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching variations: $e');
    }
  }

  void _incrementQuantity() => setState(() => quantity++);
  void _decrementQuantity() => setState(() => quantity = quantity > 1 ? quantity - 1 : 1);

  void _addToCart() {
    if (selectedVariationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a variation first!')),
      );
      return;
    }

    final variation = variations.firstWhere(
          (v) => v['id'] == selectedVariationId,
      orElse: () => null,
    );

    if (variation == null) return;

    final existingIndex = cartItems.indexWhere(
          (item) => item.product['id'] == selectedVariationId,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity += quantity;
    } else {
      cartItems.add(CartItem(
        product: variation,
        quantity: quantity,
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart!'),
          duration: Duration(seconds: 1),
        ));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
        backgroundColor: Color(0xFF1E552B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: widget.product['images'].map<Widget>((image) =>
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(image, fit: BoxFit.cover),
                    ),
                  ),
              ).toList(),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product['name'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E552B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '\Rs ${widget.product['price']}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E552B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Rating & Reviews Row
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '${widget.product['rating']} ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '(${widget.product['reviews']}+ reviews)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical:16,horizontal: 16),child: _buildCustomFields(),),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Variations:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E552B)),
                  ),
                  SizedBox(height: 10),
                  ...variations.map((variation) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Rounded corners for image
                      child: Image.network(
                        variation['image']['src'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 50, color: Colors.grey), // Fallback image
                      ),
                    ),
                    title: Text(
                      variation['name'] ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rs ${variation['price'] ?? '0.00'}',
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    trailing: Radio<int>(
                      value: variation['id'],
                      groupValue: selectedVariationId,
                      onChanged: (value) {
                        setState(() {
                          selectedVariationId = value!;
                        });
                      },
                    ),
                  )
                  ).toList()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Quantity:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E552B)),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.remove, color: Color(0xFF1E552B)),
                    onPressed: _decrementQuantity,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 18)),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Color(0xFF1E552B)),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFffc222),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _addToCart,
                  child: Text(
                    'Add to Cart - \Rs ${(double.parse(
                        (selectedVariationId != null
                            ? variations.firstWhere((v) => v['id'] == selectedVariationId)['price']
                            : widget.product['price']
                        ).toString()) * quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),


            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: cartItems)),
              ),
              child: Text("Go to Cart"),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'You might also like:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E552B),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: isFetchingRelatedProducts
                  ? Center(child: CircularProgressIndicator())
                  : relatedProducts.isEmpty
                  ? Center(child: Text('No related products found.')) // Handle empty state
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                itemBuilder: (context, index) {
                  final relatedProduct = relatedProducts[index];
                  final imageUrl = relatedProduct['images'].isNotEmpty
                      ? relatedProduct['images'][0]['src']
                      : null; // Safe URL access

                  return GestureDetector( // Make it tappable
                    onTap: () {
                      // Navigate to product details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(product: relatedProduct), // Assuming ProductPage is your product details page.
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl != null
                                ? Image.network(
                              imageUrl,
                              height: 100,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                                : Container( // Placeholder if no image
                              height: 100,
                              width: 150,
                              color: Colors.grey[200],
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            relatedProduct['name'] ?? 'Unknown Product', // Safe access
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E552B)),
                          ),
                          Text(
                            '\Rs ${relatedProduct['price'] ?? '0'}', // Safe access
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFffc222)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}