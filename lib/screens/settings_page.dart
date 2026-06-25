import 'package:flutter/material.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/localization/locale_provider.dart';
import 'package:healthy_food/widgets/language_settings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.getText(locale, "settings")),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text(AppLocalization.getText(locale, 'language')),
              trailing: const LanguageSettings(),
            ),

            const SizedBox(height: 12),

            Text(
              AppLocalization.getText(locale, "data sources"),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Open Food Facts"),
              subtitle: const Text("Product data source (ODbL license)"),
              onTap: () async {
                final url = Uri.parse(r'https://world.openfoodfacts.org/');

                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  debugPrint("SettingsPage, could not launch $url");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
