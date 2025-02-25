import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodsspot/Models/ProductModel.dart';
import 'package:foodsspot/Screens/Cart.dart';
import 'package:foodsspot/Screens/Checkout.dart';
import 'package:foodsspot/Screens/ProductPage.dart';
import 'package:http/http.dart' as http;

import 'favourites.dart';
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sliderImages = [
    'https://img.freepik.com/premium-photo/italian-risotto-with-tomato-sauce_230432-1515.jpg',
    'http://foodsspot.com/wp-content/uploads/2024/04/broastBanner.jpg.webp',
    'https://img.freepik.com/premium-photo/italian-risotto-with-tomato-sauce_230432-1515.jpg',
    'https://t4.ftcdn.net/jpg/04/17/20/73/360_F_417207342_G7LYJqMP12em9M6szV1rEaUEGuVwBEYH.jpg',
  ];

  List<String> tabs = [];
  List<Map<String, dynamic>> categories = [];
  Map<int, List<Map<String, dynamic>>> categoryProducts = {}; // Store products by category ID
  List<CartItem> cartItems = []; // Initialize an empty cart
  int cartCount = 1;
  int selectedTabIndex = 0;
  ScrollController scrollController = ScrollController();
  String searchQuery = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();



  @override
  void initState() {
    super.initState();
    fetchCategoryData();
  }
  void scrollToSection(int index) {
    // Placeholder for scrolling logic
    double offset = 0.0;
    offset = (index * 310.0) + 250.0;  // Adjust height per section
    scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  Future<void> fetchCategoryData() async {
    final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473'; // Replace with your WooCommerce consumer key
    final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f'; // Replace with your WooCommerce consumer secret
    final response = await http.get(Uri.parse('https://foodsspot.com/wp-json/wc/v3/products/categories?consumer_key=$consumerKey&consumer_secret=$consumerSecret'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        categories = data.map((category) {
          return {
            'id': category['id'],
            'name': category['name'],
          };
        }).toList();

        // Populate tabs with category names
        tabs = categories.map((category) => category['name'].toString()).toList();

        // Fetch products for each category
        for (var category in categories) {
          fetchProductsForCategory(category['id']);
        }
      });
    } else {
      throw Exception('Failed to load category data');
    }
  }

  Future<void> fetchProductsForCategory(int categoryId) async {
    final String consumerKey = 'ck_8da4b7d7c3f8d26530c33ade29492fe4fee23473'; // Replace with your WooCommerce consumer key
    final String consumerSecret = 'cs_3797eb1284dcd933d1453215c94a142eb4e9f93f'; // Replace with your WooCommerce consumer secret

    final response = await http.get(Uri.parse(
        'https://foodsspot.com/wp-json/wc/v3/products?category=$categoryId&consumer_key=$consumerKey&consumer_secret=$consumerSecret&per_page=30'));

    if (response.statusCode == 200) {
      final List<dynamic> productData = jsonDecode(response.body);

      setState(() {
        categoryProducts[categoryId] = productData.map((product) {
          return {
            'id': product['id'],
            'name': product['name'],
            'price': product['price'],
            'image': product['images'][0]['src'],
            'description': product['description'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load product data');
    }
  }

  List<Map<String, dynamic>> getFilteredProducts(int categoryId) {
    if (searchQuery.isEmpty) {
      return categoryProducts[categoryId] ?? [];
    } else {
      return (categoryProducts[categoryId] ?? []).where((product) {
        return product['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            product['description'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }


  @override
  Widget build(BuildContext context) {
    // Filter categories to only include those with matching products
    final filteredCategories = categories.where((category) {
      final products = getFilteredProducts(category['id']);
      return products.isNotEmpty;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: buildDrawer(context), // Pass cartItems and loadCartItems

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 112.0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 1.0,
              flexibleSpace: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
                child: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1e1d23), Color(0xFF333345)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 88,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search your favorite dish...',
                              hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                              prefixIcon: Icon(Icons.search, color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    animateToClosest: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 700),
                  ),
                  items: sliderImages.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 55,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: selectedTabIndex == index
                              ? LinearGradient(
                            colors: [Color(0xFF1e552b), Color(0xFF34a853)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          color: selectedTabIndex == index ? Color(0xFFffc222) : Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: selectedTabIndex == index
                                ? Colors.transparent
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 4),
                              blurRadius: 1.5,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTabIndex = index;
                            });
                            scrollToSection(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                            shadowColor: Colors.transparent,
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            style: TextStyle(
                              color: selectedTabIndex == index
                                  ? Colors.white
                                  : Color(0xFF1e552b),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                            child: Text(tabs[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Display filtered category sections
            ...filteredCategories.map((category) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    category['name'],
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                categoryProducts[category['id']] == null
                    ? Center(child:CircularProgressIndicator())
                    : SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: getFilteredProducts(category['id']).length,
                    itemBuilder: (context, index) {
                      var product = getFilteredProducts(category['id'])[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to ProductPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                product: {
                                  'id': product!['id'] ?? '',
                                  'name': product['name'] ?? '',
                                  'images': product['image'] != null
                                      ? [product['image']]
                                      : [],
                                  'price': product['price'],
                                  'description': product['description'] ?? 'No description available',
                                  'rating': 4.5,
                                  'reviews': 100, // You can modify this as needed
                                  'related': [], // Add related products here if available
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                                child: Image.network(
                                  product!['image'],
                                  height: 129,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 14.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                child: Text(
                                  product['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: const Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                child: Text(
                                  product['description'] ?? 'No description available',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF5A5A5A),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rs ${product['price']}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E552B),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 10.0,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                 ],
                                ),
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
            }).toList(),

          ],
        ),
      ),
    );
  }
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Food Spot"),
            accountEmail: Text("info@restaurant.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.restaurant_menu,
                color: Color(0xFF1e552b),
                size: 40.0,
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF1e552b),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text('Checkout'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage(cartItems: [],),));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Wishlist'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Cart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(product: {
                'name': 'Margherita Pizza',
                'description': 'Classic cheese pizza with fresh mozzarella and basil.',
                'price': 12.99,
                'rating': 4.5,
                'reviews': 500,
                'images': [
                  'https://foodsspot.com/wp-content/uploads/2024/09/Deal-12.jpeg.webp',
                  'https://foodsspot.com/wp-content/uploads/2024/09/Deal-12.jpeg.webp',
                ],
                'related': [
                  {
                    'name': 'Garlic Bread',
                    'price': 5.99,
                    'image': 'https://foodsspot.com/wp-content/uploads/2024/09/Deal-12.jpeg.webp',
                  },
                  {
                    'name': 'Coke',
                    'price': 2.99,
                    'image': 'https://foodsspot.com/wp-content/uploads/2024/09/Deal-12.jpeg.webp',
                  },
                ],
              },),));

              // Logout logic
            },
          ),
        ],
      ),
    );

  }
}


