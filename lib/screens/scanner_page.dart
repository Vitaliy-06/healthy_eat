import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/controllers/hive_controller.dart';
import 'package:healthy_food/localization/app_localization.dart';
import 'package:healthy_food/providers/locale_provider.dart';
import 'package:healthy_food/util/permission_util.dart';
import 'package:healthy_food/widgets/loading_card.dart';
import 'package:healthy_food/widgets/product_card.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Permission
  bool _hasCameraPermission = false;
  bool _checkingPermission = true;

  // Mobile Scanner
  late final MobileScannerController _controller;

  // Product
  late final ValueNotifier<ProductResultV3?> _product;
  ProductResultV3? get _productValue => _product.value;
  set _productValue(ProductResultV3? newValue) {
    if (_isDisposed) return;
    _product.value = newValue;
  }

  // Last barcode
  String? _lastBarcode;

  // Is fetching product
  late final ValueNotifier<bool> _isFetching;
  set _isFetchingValue(bool newValue) {
    if (_isDisposed) return;
    _isFetching.value = newValue;
  }

  // Is loading
  bool _isLoading = false;

  // Hive
  late final HiveController _hiveController;

  // Flushbar
  Flushbar? _flushbar;

  /// Fetch [ProductResultV3] by [barcode] via OpenFoodFacts API
  void _fetchProductInfo(String barcode) async {
    if (_isLoading || _isDisposed) return;
    debugPrint("ScannerPage fetchProductInfo Started");

    _isLoading = true;
    _isFetchingValue = true;
    try {
      _productValue = await OpenFoodAPIClient.getProductV3(
        ProductQueryConfiguration(
          barcode,
          version: ProductQueryVersion.v3,
          languages: const [
            OpenFoodFactsLanguage.ENGLISH,
            OpenFoodFactsLanguage.UKRAINIAN,
          ],
        ),
      );

      if (!mounted) return;

      if (_productValue?.product == null) {
        _showNotFound();
      }

      _addProductToHive(_productValue?.product);
    } catch (e) {
      debugPrint("ScannerPage fetchProductInfo Error: $e");
    } finally {
      _isLoading = false;
      _isFetchingValue = false;
      debugPrint("ScannerPage fetchProductInfo Ended");
    }
  }

  void _addProductToHive(Product? product) {
    if (product == null || _isDisposed) return;
    _hiveController.createProduct(product: product);
  }

  Future<void> _initPermission() async {
    if (_isDisposed) return;
    final granted = await PermissionUtil.requestCameraPermission();

    setState(() {
      _hasCameraPermission = granted;
      _checkingPermission = false;
    });
  }

  void _showNotFound() {
    _flushbar = Flushbar(
      messageText: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  AppLocalization.getText(_locale, 'not found'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 1200),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDismissible: false,
    )..show(context);
  }

  @override
  void initState() {
    debugPrint("ScannerPage Init State");
    super.initState();
    _isFetching = ValueNotifier(false);
    _product = ValueNotifier(null);
    _controller = MobileScannerController();
    _hiveController = HiveController();
    _initPermission();
  }

  bool _isDisposed = false;
  @override
  void dispose() {
    debugPrint("ScannerPage Dispose");
    _flushbar?.dismiss();
    _isDisposed = true;
    _controller.dispose();
    _product.dispose();
    _isFetching.dispose();
    super.dispose();
  }

  // Locale
  late Locale _locale;

  @override
  Widget build(BuildContext context) {
    _locale = context.watch<LocaleProvider>().locale;

    if (_checkingPermission || _isDisposed) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasCameraPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalization.getText(_locale, "camera permission required"),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final granted = await PermissionUtil.requestCameraPermission();

                setState(() {
                  _hasCameraPermission = granted;
                });
              },
              child: Text(AppLocalization.getText(_locale, 'allow access')),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              if (barcode.rawValue == _lastBarcode) {
                return;
              }

              // Allowed formats EAN-13, EAN-8, UPC-A
              if (barcode.format != BarcodeFormat.ean13 &&
                  barcode.format != BarcodeFormat.ean8 &&
                  barcode.format != BarcodeFormat.upcA) {
                return;
              }

              _lastBarcode = barcode.rawValue;
              _fetchProductInfo(barcode.rawValue!);
            },
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: ValueListenableBuilder<bool>(
              valueListenable: _isFetching,
              builder: (context, state, child) {
                final product = _productValue?.product;

                final size = MediaQuery.of(context).size;

                return SizedBox(
                  width: size.width * 0.70,
                  height: size.width * 0.70,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: state
                        ? LoadingCard(key: const ValueKey("loader"))
                        : ProductCard(
                            key: const ValueKey("card"),
                            product: product,
                          ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment(1, 1),
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) => IconButton(
                key: ValueKey("flashlight"),
                onPressed: () {
                  _controller.toggleTorch();
                },
                icon: Icon(
                  state.torchState == TorchState.unavailable
                      ? null
                      : state.torchState == TorchState.on
                      ? Icons.flashlight_on
                      : Icons.flashlight_off,
                ),
                iconSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
