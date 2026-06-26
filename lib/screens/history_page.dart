import 'package:flutter/material.dart';
import 'package:healthy_food/controllers/hive_controller.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:healthy_food/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final HiveController controller = HiveController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalization.getText(locale, "history"))),
        body: FutureBuilder(
          future: controller.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              debugPrint("Error during fetching products: ${snapshot.error}");
              return Center(child: Text( AppLocalization.getText(locale, "error loading data") ));
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return Center(child: Text(AppLocalization.getText(locale, "no history yet"), style: Theme.of(context).textTheme.bodyLarge ));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductTile(
                  product: products[index],
                  controller: controller,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
