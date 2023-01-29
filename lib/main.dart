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
import '../../pages/apft_page.dart';
import '../../pages/mdl_setup_page.dart';
import '../../pages/privacy_policy_page.dart';
import '../../pages/saved_pages/saved_acfts_page.dart';
import '../../pages/saved_pages/saved_apfts_page.dart';
import '../../pages/saved_pages/saved_bodyfats_page.dart';
import '../../pages/saved_pages/saved_ppw_page.dart';
import '../../pages/settings_page.dart';
import '../../pages/verbiage_pages/acft_verbiage_page.dart';
import '../../pages/verbiage_pages/apft_verbiage_page.dart';
import '../../pages/verbiage_pages/bodyfat_verbiage_page.dart';
import '../../providers/purchases_provider.dart';

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
        routes: {
          ApftPage.routeName: (ctx) => ApftPage(),
          MdlSetupPage.routeName: (ctx) => MdlSetupPage(),
          PrivacyPolicyPage.routeName: (ctx) => PrivacyPolicyPage(),
          SettingsPage.routeName: (ctx) => SettingsPage(),
          SavedAcftsPage.routeName: (ctx) => SavedAcftsPage(),
          SavedApftsPage.routeName: (ctx) => SavedApftsPage(),
          SavedBodyfatsPage.routeName: (ctx) => SavedBodyfatsPage(),
          SavedPpwsPage.routeName: (ctx) => SavedPpwsPage(),
          AcftVerbiagePage.routeName: (ctx) => AcftVerbiagePage(),
          ApftVerbiagePage.routeName: (ctx) => ApftVerbiagePage(),
          BodyfatVerbiagePage.routeName: (ctx) => BodyfatVerbiagePage(),
        },
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
