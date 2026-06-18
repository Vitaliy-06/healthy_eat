import 'package:flutter/material.dart';
import 'package:healthy_food/layout/layout.dart';
import 'package:healthy_food/theme/healthy_theme.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  OpenFoodAPIConfiguration.userAgent = UserAgent(name: "hEat");

  OpenFoodAPIConfiguration.globalLanguages = [
    OpenFoodFactsLanguage.ENGLISH,
    OpenFoodFactsLanguage.UKRAINIAN,
  ];

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: healthyTheme,
      home: const Layout(),
    );
  }
}
