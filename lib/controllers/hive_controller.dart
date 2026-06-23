import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class HiveController {
  HiveController();

  final Box hiveBox = Hive.box("ProductsBox");

  /// Fetch all Products from Hive
  List<Product> fetchData() {
    // Converts all keys into String to avoid the error during parsing from json to Product
    dynamic normalizeJson(dynamic input) {
      if (input is Map) {
        return input.map(
          (key, value) => MapEntry(key.toString(), normalizeJson(value)),
        );
      }
      if (input is List) {
        return input.map(normalizeJson).toList();
      }
      return input;
    }

    final products = <Product>[];
    for (final json in hiveBox.values) {
      try {
        
        final map = normalizeJson(json);
        final product = Product.fromJson(map);

        products.add(product);
      } catch (e) {
        debugPrint('Failed to parse Product: $e');
      }
    }

    return products.reversed.toList();
  }

  Future<void> createProduct({required Product product}) async {
    try {
      final json = Map<String, dynamic>.from(product.toJson());
      await hiveBox.put(product.barcode, json);
    } catch (e) {
      debugPrint('Failed to create Product: $e');
    }
  }

  Future<void> deleteProduct({required String barcode}) async {
    try {
      await hiveBox.delete(barcode);
    } catch (e) {
      debugPrint('Failed to delete Product: $barcode');
    }
  }

  Future<void> clearProducts() async {
    try {
      await hiveBox.clear();
    } catch (e) {
      debugPrint('Failed to clear Products: $e');
    }
  }
}
