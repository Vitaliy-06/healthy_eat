import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class HiveController {
  HiveController();

  final Box hiveBox = Hive.box("ProductsBox");

  /// Fetch all Products from Hive
  Future<List<Product>> fetchData() async {
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

    final items = <Map<String, dynamic>>[];
    for (final value in hiveBox.values) {
      try {
        final map = normalizeJson(value);
        items.add({
          'timestamp': map['timestamp'] ?? 0,
          'product': map['product'],
        });
      } catch (e) {
        debugPrint('Parse error: $e');
      }
    }

    items.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return items.map((e) => Product.fromJson(e['product'])).toList();
  }

  Future<void> createProduct({required Product product}) async {
    try {
      final json = Map<String, dynamic>.from(product.toJson());

      final data = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'product': json,
      };

      await hiveBox.put(product.barcode, data);
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
