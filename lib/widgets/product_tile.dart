import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/controllers/hive_controller.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/localization/locale_provider.dart';
import 'package:healthy_food/widgets/product_dialog.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.controller,
  });

  final Product product;
  final HiveController controller;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final lang = AppLocalization.fromLocale(locale);

    return Dismissible(
      key: ValueKey(product.barcode ?? "ProductKey"),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        controller.deleteProduct(barcode: product.barcode ?? "");
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: product.imageFrontSmallUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            title: Text(
              product.productNameInLanguages?[lang] ??
                  product.productName ??
                  AppLocalization.getText(locale, "unknown"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => ProductDialog(product: product),
            ),
          ),
        ),
      ),
    );
  }
}
