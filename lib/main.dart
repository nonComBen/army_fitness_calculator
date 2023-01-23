import 'package:acft_calculator/providers/purchases_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../providers/shared_preferences_provider.dart';
import '../widgets/platform_widgets/platform_app.dart';
import '../widgets/platform_widgets/platform_home_page.dart';
import '../providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(overrides: [
      // override the previous value with the new object
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ], child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(purchasesProvider).initialize();
    MobileAds.instance.initialize();
    InAppPurchase.instance.restorePurchases();
    return Consumer(builder: (context, ref, child) {
      final themeState = ref.watch(themeStateNotifierProvider);
      return PlatformApp(
        title: 'Army Fitness Calculator',
        themeData: themeState,
        home: Builder(builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).viewPadding.left,
              right: MediaQuery.of(context).viewPadding.right,
            ),
            child: PlatformHomePage(),
          );
        }),
      );
    });
  }
}
