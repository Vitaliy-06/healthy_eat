import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = WidgetsBinding.instance.platformDispatcher.locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void useSystemLocale() {
    _locale = WidgetsBinding.instance.platformDispatcher.locale;
    notifyListeners();
  }
}