import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class GPaymentUtils {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final Function(String message) onMessage;
  final Function(PurchaseDetails purchaseDetails) onPurchaseVerified;
  final Function() onPurchasePending;
  final Function(PurchaseDetails purchaseDetails) onPurchasedError;
  GPaymentUtils({
    required this.onMessage,
    required this.onPurchaseVerified,
    required this.onPurchasePending,
    required this.onPurchasedError,
  });

  void initialize() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        onMessage('In-app purchase error: $error');
      },
    );
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          onPurchasePending();
          break;
        case PurchaseStatus.canceled:
          onMessage('Purchase was canceled by the user.');
          onPurchasedError(purchaseDetails);
          break;
        case PurchaseStatus.error:
          onMessage('Payment failed: ${purchaseDetails.error?.message}');
          onPurchasedError(purchaseDetails);
          if (purchaseDetails.error?.message.contains(
                "You already own this item",
              ) ==
              true) {
            restorePurchases();
          }
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          onPurchaseVerified(purchaseDetails);
          
          _inAppPurchase.completePurchase(purchaseDetails);
          break;
      }
    }
  }

  Future<void> buyConsumableProduct(String productId) async {
    final String formattedProductId = productId.replaceAll('-', '_');
    final Set<String> productIds = <String>{formattedProductId};
    try {
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _inAppPurchase
                .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        onMessage('Product not found: ${response.notFoundIDs.join(', ')}');
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      onMessage('Error during purchase: ${e.toString()}');
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
