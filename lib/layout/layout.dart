import 'package:flutter/material.dart';
import 'package:healthy_food/screens/scanner_page.dart';

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
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: const [
          Center(child: Text('History page')),
          ScannerPage(),
          Center(child: Text('Settings page')),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
        },
        unselectedFontSize: 14,
        selectedFontSize: 14,
        useLegacyColorScheme: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.barcode_reader), label: "Scan"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
