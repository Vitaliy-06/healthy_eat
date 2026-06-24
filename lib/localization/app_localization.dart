import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

enum AppLanguage { ukrainian, english }

abstract class AppLocalization {
  static const Map<AppLanguage, Map<String, String>> appTexts = {
    AppLanguage.ukrainian: {
      'settings': 'Налаштування',
      'history': 'Історія',
      'scan': 'Сканувати',

      'no history yet': 'Історії ще немає',
      'error loading data': 'Помилка завантаження даних',

      'language': 'Мова',
      'data sources': 'Джерела даних',

      'camera permission required': 'Потрібен дозвіл камери',
      'allow access': 'Дозволити доступ',
      'details': 'Деталі',
      'scan a product': 'Проскануйте Продукт',
      'unknown': 'Невідомо',

      'ingredients': 'Інгредієнти',
      'brand': 'Виробник',
      'nutrition facts': 'Харчова Цінність',
      'allergens': 'Алергени',
      'additives': 'Добавки'
    },
    AppLanguage.english: {
      'settings': 'Settings',
      'history': 'History',
      'scan': 'Scan',

      'no history yet': 'No history yet',
      'error loading data': 'Error loading data',

      'language': 'Language',
      'data sources': 'Data sources',
      
      'camera permission required': 'Camera permission required',
      'allow access': 'Allow access',
      'details': 'Details',
      'scan a product': 'Scan a Product',
      'unknown': 'Unknown',

      'ingredients': 'Ingredients',
      'brand': 'Brand',
      'nutrition facts': 'Nutrition Facts',
      'allergens': 'Allergens',
      'additives': 'Additives',
    },
  };

  static String getText(Locale? locale, String key) {
    final lang = locale?.languageCode ?? 'en';

    final appLang = lang == 'uk' ? AppLanguage.ukrainian : AppLanguage.english;

    return appTexts[appLang]?[key] ?? key;
  }

  static OpenFoodFactsLanguage fromLocale(Locale? locale) {
    switch (locale?.languageCode) {
      case 'uk':
        return OpenFoodFactsLanguage.UKRAINIAN;
      case 'en':
      default:
        return OpenFoodFactsLanguage.ENGLISH;
    }
  }
}
