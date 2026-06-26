import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_food/layout/layout.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:healthy_food/providers/theme_provider.dart';
import 'package:healthy_food/theme/healthy_theme.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  await Hive.openBox("ProductsBox");

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: "HealthyEat",
    url: r"https://github.com/Vitaliy-06/healthy_eat",
  );

  OpenFoodAPIConfiguration.globalLanguages = [
    OpenFoodFactsLanguage.ENGLISH,
    OpenFoodFactsLanguage.UKRAINIAN,
  ];

  final LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  final ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => localeProvider),
      ChangeNotifierProvider(create: (_) => themeProvider)
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProvider, themeProvider, _) {
        return MaterialApp(
          title: 'Healthy Eat',
          locale: localeProvider.locale,
          supportedLocales: const [Locale('uk'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          darkTheme: healthyDarkTheme,
          theme: healthyTheme,
          themeMode: themeProvider.themeMode,
          home: const Layout(),
        );
      },
    );
  }
}
