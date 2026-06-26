import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = WidgetsBinding.instance.platformDispatcher.locale;

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString("language");

    if (lang != null) {
      _locale = Locale(lang);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", locale.languageCode);

    _locale = locale;
    notifyListeners();
  }

  Future<void> useSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("language");

    _locale = WidgetsBinding.instance.platformDispatcher.locale;
    notifyListeners();
  }
}