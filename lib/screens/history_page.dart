import 'package:flutter/material.dart';
import 'package:healthy_food/controllers/hive_controller.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/localization/locale_provider.dart';
import 'package:healthy_food/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    final HiveController controller = HiveController();
    final products = controller.fetchData();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalization.getText(locale, "history"))),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            return ProductTile(
              product: products[index],
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}
