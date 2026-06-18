import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthy_food/util/nutri_score_util.dart';
import 'package:healthy_food/util/permission_util.dart';
import 'package:healthy_food/widgets/loading_card.dart';
import 'package:healthy_food/widgets/product_card.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with AutomaticKeepAliveClientMixin {
  // Permission
  bool _hasCameraPermission = false;
  bool _checkingPermission = true;

  // When switching to another screen, this widget will dispose
  @override
  bool get wantKeepAlive => false;

  // Mobile Scanner
  late final MobileScannerController _controller;

  // Product
  late final ValueNotifier<ProductResultV3?> _product;
  ProductResultV3? get _productValue => _product.value;
  set _productValue(ProductResultV3? newValue) {
    _product.value = newValue;
  }

  // Last barcode
  String? _lastBarcode;

  // Is fetching product
  late final ValueNotifier<bool> _isFetching;
  bool get _isFetchingValue => _isFetching.value;
  set _isFetchingValue(bool newValue) {
    _isFetching.value = newValue;
  }

  // Is loading
  bool _isLoading = false;

  /// Fetch [ProductResultV3] by [barcode] via OpenFoodFacts API
  void _fetchProductInfo(String barcode) async {
    if (_isLoading) return;
    debugPrint("ScannerPage fetchProductInfo Started");

    _isLoading = true;
    _isFetchingValue = true;
    try {
      _productValue = await OpenFoodAPIClient.getProductV3(
        ProductQueryConfiguration(barcode, version: ProductQueryVersion.v3),
      );
    } catch (e) {
      debugPrint("ScannerPage fetchProductInfo Error: $e");
    } finally {
      _isLoading = false;
      _isFetchingValue = false;
      debugPrint("ScannerPage fetchProductInfo Ended");
    }
  }

  Future<void> _initPermission() async {
    final granted = await PermissionUtil.requestCameraPermission();

    setState(() {
      _hasCameraPermission = granted;
      _checkingPermission = false;
    });
  }

  @override
  void initState() {
    debugPrint("ScannerPage Init State");
    super.initState();
    _isFetching = ValueNotifier(false);
    _product = ValueNotifier(null);
    _controller = MobileScannerController();
    _initPermission();
  }

  @override
  void dispose() {
    debugPrint("ScannerPage Dispose");
    _controller.dispose();
    _product.dispose();
    _isFetching.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermission) {
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
              "Camera permission required",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final granted = await PermissionUtil.requestCameraPermission();

                setState(() {
                  _hasCameraPermission = granted;
                });
              },
              child: const Text("Allow access"),
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
