import 'package:flutter/material.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:healthy_food/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSettings extends StatelessWidget {
  
  const ThemeSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>().locale;

    return Column(
      children: ThemeMode.values.map((mode) {
        final isSelected = themeProvider.themeMode == mode;
    
        String title;
        IconData icon;
    
        switch (mode) {
          case ThemeMode.system:
            title = AppLocalization.getText(locale, 'system');
            icon = Icons.brightness_auto;
            break;
          case ThemeMode.light:
            title = AppLocalization.getText(locale, 'light');
            icon = Icons.light_mode;
            break;
          case ThemeMode.dark:
            title = AppLocalization.getText(locale, 'dark');
            icon = Icons.dark_mode;
            break;
        }
    
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon),
          title: Text(title),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.green)
              : null,
          onTap: () => themeProvider.setTheme(mode),
        );
      }).toList(),
    );
  }
}