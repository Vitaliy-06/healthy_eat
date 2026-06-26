import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:healthy_food/util/nutri_score_util.dart';
import 'package:healthy_food/widgets/product_dialog.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product? product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = context.watch<LocaleProvider>().locale;
    final lang = AppLocalization.fromLocale(locale);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: product?.imageFrontSmallUrl != null
                    ? CachedNetworkImage(
                        imageUrl: product!.imageFrontSmallUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.image_not_supported_outlined),
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 48,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 6),

            /// TITLE
            Text(
              product?.productNameInLanguages?[lang] ??
                  product?.productName ??
                  AppLocalization.getText(locale, "scan a product"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 6),

            /// BOTTOM ROW
            Row(
              children: [
                /// NUTRISCORE
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Image.asset(
                        NutriScoreUtil.getNutriScoreByString(
                          product?.nutriscore ?? "",
                        ),
                        height: size.width * 0.12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// BUTTON
                Expanded(
                  child: ElevatedButton(
                    onPressed: product == null
                        ? null
                        : () => showDialog(
                            context: context,
                            builder: (context) =>
                                ProductDialog(product: product),
                          ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 5),
                        Text(
                          AppLocalization.getText(locale, "details"),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
