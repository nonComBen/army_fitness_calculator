import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/platform_widgets/platform_text_button.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../widgets/toast.dart';
import '../widgets/bullet_item.dart';

class PurchasesService {
  bool _isPremium = true;
  List<ProductDetails>? _products;

  bool get isPremium {
    return _isPremium;
  }

  initialize() async {
    bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      InAppPurchase.instance
          .queryProductDetails({'premium_upgrade'}).then((response) {
        if (response.notFoundIDs.isEmpty) {}
        _products = response.productDetails;
      });
      final Stream purchaseUpdates = InAppPurchase.instance.purchaseStream;
      purchaseUpdates.listen((purchases) async {
        // _isPremium = await listenToPurchaseUpdated(purchases);
      }) as StreamSubscription<List<PurchaseDetails>>;
    }
  }

  upgrade(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Premium Upgrade',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const BulletItem(
              text: 'One time cost of \$1.99',
            ),
            const BulletItem(
              text:
                  'Allows you to save scores, print DA Forms, and chart progress for you and your Soldiers',
            ),
            const BulletItem(
              text: 'Removes ads',
            ),
            Row(
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
                      if (_products!.isEmpty) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                              'Upgrading is not available at this time'),
                        ));
                      } else {
                        Navigator.pop(ctx);
                        ProductDetails product = _products!.firstWhere(
                            (product) => product.id == 'premium_upgrade');

                        final PurchaseParam purchaseParam =
                            PurchaseParam(productDetails: product);
                        InAppPurchase.instance
                            .buyNonConsumable(purchaseParam: purchaseParam);
                      }
                    },
                  ),
                )
              ],
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
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          Flexible(
            flex: 1,
            child: PlatformTextButton(
              child: Text(
                'Upgrade',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
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
