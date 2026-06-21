import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class HiveController {
  HiveController();

  final Box hiveBox = Hive.box("ProductsBox");

  /// Fetch all Products from Hive
  List<Product> fetchData() {

    return hiveBox.values
        .map((json) {
          try {
            final map = Map<dynamic, dynamic>.from(json).cast<String, dynamic>();
            return Product.fromJson(map);
          } catch (e) {
            debugPrint('Failed to parse Product: $e');
            return null;
          }
        })
        .whereType<Product>()
        .toList()
        .reversed
        .toList();
  }

  Future<void> createProduct({required Product product}) async {
    try {
      return; // Temporarily
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
