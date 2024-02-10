import 'dart:async';

import 'package:acft_calculator/methods/platform_show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../methods/theme_methods.dart';
import '../methods/verify_purchase.dart';
import '../providers/premium_state_provider.dart';
import '../widgets/platform_widgets/platform_text_button.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../widgets/my_toast.dart';
import '../widgets/bullet_item.dart';

class PurchasesService {
  PurchasesService({required this.premiumState, required this.prefs});
  final PremiumState premiumState;
  final SharedPreferences prefs;
  List<ProductDetails> _products = [];

  initialize() async {
    bool available = await InAppPurchase.instance.isAvailable();
    print('In App Purchases Available: $available');
    if (available) {
      InAppPurchase.instance
          .queryProductDetails({'premium_upgrade'}).then((response) {
        if (response.productDetails.isNotEmpty) {}
        _products = response.productDetails;
      });
      final Stream purchaseUpdates = InAppPurchase.instance.purchaseStream;
      purchaseUpdates.listen((purchases) async {
        print('Purchases: $purchases');
        bool isPremium = await listenToPurchaseUpdated(purchases);
        prefs.setBool('isPremium', isPremium);
        premiumState.setState(isPremium);
      });
      InAppPurchase.instance.restorePurchases();
    }
  }

  upgrade(BuildContext context) {
    showPlatformModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 50,
        ),
        color: getBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: const Text(
                  'Premium Upgrade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const BulletItem(
              text: 'One time cost of \$1.99',
            ),
            const BulletItem(
              text:
                  'Allows you to save scores and chart progress for you and your Soldiers',
            ),
            const BulletItem(
              text: 'Removes ads',
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlatformButton(
                        child: const Text(
                          'Cancel',
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlatformButton(
                        child: const Text(
                          'Upgrade',
                        ),
                        onPressed: () {
                          if (_products.isEmpty) {
                            Navigator.pop(ctx);
                            FToast toast = FToast();
                            toast.context = context;
                            toast.showToast(
                              child: MyToast(
                                contents: [
                                  Text(
                                    'Upgrading is not available at this time',
                                    style: TextStyle(
                                      color: getOnPrimaryColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Navigator.pop(ctx);
                            ProductDetails product = _products.firstWhere(
                                (product) => product.id == 'premium_upgrade');

                            final PurchaseParam purchaseParam =
                                PurchaseParam(productDetails: product);
                            InAppPurchase.instance
                                .buyNonConsumable(purchaseParam: purchaseParam);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlatformButton(
                        child: const Text(
                          'Restore Purchases',
                        ),
                        onPressed: () {
                          InAppPurchase.instance.restorePurchases();
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  upgradeNeeded(BuildContext context) {
    FToast fToast = FToast();
    fToast.context = context;
    fToast.showToast(
      gravity: ToastGravity.BOTTOM,
      child: MyToast(
        contents: [
          Flexible(
            flex: 3,
            child: Text(
              'Saving scores is only available on the Premium version',
              style: TextStyle(color: getOnPrimaryColor(context)),
            ),
          ),
          Flexible(
            flex: 1,
            child: PlatformTextButton(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Upgrade',
                  style: TextStyle(
                    color: getOnPrimaryColor(context),
                  ),
                ),
              ),
              onPressed: () => upgrade(context),
            ),
          ),
        ],
      ),
    );
  }
}
