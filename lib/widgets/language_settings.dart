import 'package:flutter/material.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  static const _supportedLocales = [Locale('en'), Locale('uk')];

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    final safeLocale = _supportedLocales.firstWhere(
      (l) => l.languageCode == localeProvider.locale.languageCode,
      orElse: () => const Locale('en'),
    );

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: safeLocale,
        items: _supportedLocales.map((locale) {
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Text(locale.languageCode == 'uk' ? "Українська" : "English"),
          );
        }).toList(),
        onChanged: (newLocale) {
          if (newLocale == null) return;
          context.read<LocaleProvider>().setLocale(newLocale);
        },
      ),
    );
  }
}
