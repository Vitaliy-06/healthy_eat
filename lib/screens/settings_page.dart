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
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language),
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
              leading: const Icon(Icons.source),
              title: Text(AppLocalization.getText(locale, "open food facts")),
              subtitle: Text(
                AppLocalization.getText(locale, "data source license"),
              ),
              onTap: () async {
                final url = Uri.parse('https://world.openfoodfacts.org/');

                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  debugPrint("SettingsPage, could not launch $url");
                }
              },
            ),

            const SizedBox(height: 24),

            Text(
              AppLocalization.getText(locale, "legal"),
              style: Theme.of(context).textTheme.titleMedium,
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip),
              title: Text(AppLocalization.getText(locale, "privacy policy")),
              subtitle: Text(
                AppLocalization.getText(locale, "view data usage"),
              ),
              onTap: () async {
                final url = Uri.parse("https://vitaliy-06.github.io/healthy_eat_legal/");

                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  debugPrint("Could not launch $url");
                }
              },
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.description),
              title: Text(AppLocalization.getText(locale, "terms")),
              subtitle: Text(AppLocalization.getText(locale, "app rules")),
              onTap: () async {
                final url = Uri.parse("https://vitaliy-06.github.io/healthy_eat_legal/terms");

                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  debugPrint("Could not launch $url");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
