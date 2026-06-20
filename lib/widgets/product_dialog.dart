import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/localization/locale_provider.dart';
import 'package:healthy_food/util/nutri_score_util.dart';
import 'package:healthy_food/util/nutrient_extension.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class ProductDialog extends StatefulWidget {
  final Product? product;

  const ProductDialog({required this.product, super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


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

  List<TableRow> _buildNutritionTable([Locale? locale]) {
    final nutriments = widget.product?.nutriments;
    if (nutriments == null) {
      return [_nutritionRow(AppLocalization.getText(locale, 'unknown'), "-")];
    }

    final List<TableRow> rows = [];

    for (final nutrient in Nutrient.values) {
      final value =
          nutriments.getValue(nutrient, PerSize.oneHundredGrams) ??
          nutriments.getValue(nutrient, PerSize.serving);

      if (value == null) continue;

      rows.add(_nutritionRow(nutrient.displayName, "$value ${nutrient.typicalUnit.offTag}"));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final lang = AppLocalization.fromLocale(locale);

    final size = MediaQuery.of(context).size;
    final nutritionTable = _buildNutritionTable(locale);

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalization.getText(locale, 'details'))),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product?.imageFrontUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: widget.product?.imageFrontUrl ?? "",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 16),

              Text(
                widget.product?.productNameInLanguages?[lang] ??
                    widget.product?.productName ??
                    AppLocalization.getText(locale, 'unknown'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              Text(
                "${AppLocalization.getText(locale, 'brand')}: ${widget.product?.brandsTagsInLanguages?[lang]?.join(", ") ?? widget.product?.brands ?? AppLocalization.getText(locale, 'unknown')}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.getText(locale, 'nutrition facts'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Image.asset(
                    NutriScoreUtil.getNutriScoreByString(
                      widget.product?.nutriscore ?? "",
                    ),
                    height: size.width * 0.15,
                  ),
                ],
              ),

              Text(
                "100g/100ml",
                style: Theme.of(context).textTheme.titleMedium,
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
                  controller: _scrollController,
                  thumbVisibility: true,
                  radius: Radius.circular(12),

                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: nutritionTable.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final row = nutritionTable[index];

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
                AppLocalization.getText(locale, 'allergens'),
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(
                "${widget.product?.allergens?.names.join(", ") ?? "No allergens"}.",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),

              Text(
                AppLocalization.getText(locale, 'ingredients'),
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(
                widget.product?.ingredientsTextInLanguages?[lang] ??
                    widget.product?.ingredientsText ??
                    AppLocalization.getText(locale, 'unknown'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
