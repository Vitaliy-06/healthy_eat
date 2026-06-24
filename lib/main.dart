import 'package:flutter/material.dart';
import 'package:healthy_food/layout/layout.dart';
import 'package:healthy_food/localization/locale_provider.dart';
import 'package:healthy_food/theme/healthy_theme.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("ProductsBox");

  OpenFoodAPIConfiguration.userAgent = UserAgent(name: "hEat");

  OpenFoodAPIConfiguration.globalLanguages = [
    OpenFoodFactsLanguage.ENGLISH,
    OpenFoodFactsLanguage.UKRAINIAN,
  ];

  final LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    ChangeNotifierProvider(
      create: (_) => localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp(
          title: 'Healthy Eat',
          locale: localeProvider.locale,
          supportedLocales: const [Locale('uk'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: healthyTheme,
          home: const Layout(),
        );
      },
    );
  }
}
