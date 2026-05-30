import 'package:purchases_flutter/purchases_flutter.dart';

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  static const String _apiKey = 'goog_dbNJobueqzbiEGQSVrJsXrspbuh';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
    _initialized = true;
    print('✅ RevenueCat initialized');
  }


  Future<void> loginUser(String userEmail) async {
    try {
      final result = await Purchases.logIn(userEmail);
      print('✅ RevenueCat logIn success: ${result.customerInfo.originalAppUserId}');
    } catch (e) {
      print('❌ RevenueCat logIn error: $e');
    }
  }


  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
      print('✅ RevenueCat logged out');
    } catch (e) {
      print('❌ RevenueCat logout error: $e');
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print('❌ getOfferings error: $e');
      return null;
    }
  }

  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } catch (e) {
      print('❌ purchasePackage error: $e');
      rethrow;
    }
  }

  Future<CustomerInfo?> purchaseProduct(String productId) async {
    try {
      final products = await Purchases.getProducts(
        [productId],
        productCategory: ProductCategory.nonSubscription,
      );
      if (products.isEmpty) {
        print('❌ Product not found: $productId');
        return null;
      }
      return await Purchases.purchaseStoreProduct(products.first);
    } catch (e) {
      print('❌ purchaseProduct error: $e');
      rethrow;
    }
  }

  Future<String> getProductPrice(String productId) async {
    try {
      final products = await Purchases.getProducts(
        [productId],
        productCategory: ProductCategory.nonSubscription,
      );
      if (products.isNotEmpty) {
        return products.first.priceString;
      }
      return 'N/A';
    } catch (e) {
      print('❌ getProductPrice error: $e');
      return 'N/A';
    }
  }

  Future<CustomerInfo?> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      print('❌ restorePurchases error: $e');
      return null;
    }
  }

  Future<bool> isSubscribed() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.all['pro_access']?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }
}