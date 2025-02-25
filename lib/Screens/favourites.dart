import 'package:flutter/material.dart';
import '../methods/favouriteService.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  /// Load Favorite Products
  Future<void> _loadFavorites() async {
    List<Map<String, dynamic>> products = await FavoriteService.getFavorites();
    setState(() {
      favoriteProducts = products;
    });
  }

  /// Remove product from favorites
  Future<void> _removeFavorite(int productId) async {
    await FavoriteService.removeFavorite(productId);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Products")),
      body: favoriteProducts.isEmpty
          ? const Center(child: Text("No favorite products yet"))
          : ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("\Rs ${product['price']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFavorite(product['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
