import 'package:flutter/material.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:healthy_food/screens/history_page.dart';
import 'package:healthy_food/screens/scanner_page.dart';
import 'package:healthy_food/screens/settings_page.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final PageController _controller = PageController();
  int currentPageIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: const [
          HistoryPage(),
          ScannerPage(),
          SettingsPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
        },
        unselectedFontSize: 14,
        selectedFontSize: 15,
        useLegacyColorScheme: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: AppLocalization.getText(
              locale,
              "history",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.barcode_reader),
            label: AppLocalization.getText(
              locale,
              "scan",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppLocalization.getText(
              locale,
              "settings",
            ),
          ),
        ],
      ),
    );
  }
}
