import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/util/nutri_score_util.dart';
import 'package:healthy_food/util/nutrient_extension.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductDialog extends StatelessWidget {
  final Product? product;

  const ProductDialog({required this.product, super.key});

  TableRow _nutritionRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Padding(padding: const EdgeInsets.all(12), child: Text(value)),
      ],
    );
  }

  List<TableRow> _buildNutritionTable() {
    final nutriments = product?.nutriments;
    if (nutriments == null) {
      return [_nutritionRow("No data", "-")];
    }

    final List<TableRow> rows = [];

    for (final nutrient in Nutrient.values) {
      final value =
          nutriments.getValue(nutrient, PerSize.oneHundredGrams) ??
          nutriments.getValue(nutrient, PerSize.serving);

      if (value == null) continue;

      rows.add(_nutritionRow(nutrient.displayName, value.toString()));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product?.imageFrontUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: product?.imageFrontUrl ?? "",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 16),

              Text(
                product?.productName ?? "Unknown product",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              Text(
                "Brand: ${product?.brands ?? "Unknown"}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nutrition Facts",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Image.asset(
                    NutriScoreUtil.getNutriScoreByString(
                      product?.nutriscore ?? "",
                    ),
                    height: size.width * 0.15,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: Radius.circular(12),

                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: _buildNutritionTable().length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final row = _buildNutritionTable()[index];

                      return Row(
                        children: [
                          Expanded(child: row.children[0]),
                          Expanded(child: row.children[1]),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Ingredients",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(
                product?.ingredientsText ?? "No ingredients available",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
