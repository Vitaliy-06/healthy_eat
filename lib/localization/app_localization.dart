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
      'theme': 'Тема',
      'system': 'Системна',
      'light': 'Світла',
      'dark': 'Темна',
      'data sources': 'Джерела даних',
      'open food facts': 'Open Food Facts',
      'data source license': 'Джерело даних (ліцензія ODbL)',
      'legal': 'Юридична інформація',
      'privacy policy': 'Політика конфіденційності',
      'view data usage': 'Як використовуються ваші дані',
      'terms': 'Умови використання',
      'app rules': 'Правила використання додатку',

      'camera permission required': 'Потрібен дозвіл камери',
      'allow access': 'Дозволити доступ',
      'details': 'Деталі',
      'scan a product': 'Проскануйте Продукт',
      'unknown': 'Невідомо',
      'not found': 'Не Знайдено',

      'ingredients': 'Інгредієнти',
      'brand': 'Виробник',
      'nutrition facts': 'Харчова Цінність',
      'allergens': 'Алергени',
      'additives': 'Добавки',
    },
    AppLanguage.english: {
      'settings': 'Settings',
      'history': 'History',
      'scan': 'Scan',

      'no history yet': 'No history yet',
      'error loading data': 'Error loading data',

      'language': 'Language',
      'theme': 'Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'data sources': 'Data sources',
      'open food facts': 'Open Food Facts',
      'data source license': 'Product data source (ODbL license)',
      'legal': 'Legal',
      'privacy policy': 'Privacy Policy',
      'view data usage': 'View how your data is used',
      'terms': 'Terms & Conditions',
      'app rules': 'Rules for using the app',

      'camera permission required': 'Camera permission required',
      'allow access': 'Allow access',
      'details': 'Details',
      'scan a product': 'Scan a Product',
      'unknown': 'Unknown',
      'not found': 'Not Found',

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
