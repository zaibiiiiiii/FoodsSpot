import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoriteService {
  static const String _favKey = "favorite_products";
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Save favorite products list securely
  static Future<void> saveFavorites(List<Map<String, dynamic>> products) async {
    final String encodedData = jsonEncode(products);
    await _secureStorage.write(key: _favKey, value: encodedData);
  }

  /// Get favorite products list securely
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final String? data = await _secureStorage.read(key: _favKey);

    if (data != null) {
      List<dynamic> decodedData = jsonDecode(data);
      return List<Map<String, dynamic>>.from(decodedData);
    }

    return [];
  }

  /// Add a product to favorites
  static Future<void> addFavorite(Map<String, dynamic> product) async {
    List<Map<String, dynamic>> favorites = await getFavorites();

    // Check if the product is already in favorites
    if (!favorites.any((item) => item['id'] == product['id'])) {
      favorites.add(product);
      await saveFavorites(favorites);
    }
  }

  /// Remove a product from favorites
  static Future<void> removeFavorite(int productId) async {
    List<Map<String, dynamic>> favorites = await getFavorites();

    favorites.removeWhere((item) => item['id'] == productId);
    await saveFavorites(favorites);
  }

  /// Check if a product is in favorites
  static Future<bool> isFavorite(int productId) async {
    List<Map<String, dynamic>> favorites = await getFavorites();
    return favorites.any((item) => item['id'] == productId);
  }
}
