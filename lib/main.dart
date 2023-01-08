import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import './methods/verify_purchase.dart';
import './providers/shared_preferences_provider.dart';
import './providers/theme_provider.dart';
import '../pages/home_page.dart';

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

class MyApp extends StatefulWidget {
  @override
  State createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  bool premium = true;
  late StreamSubscription<List<PurchaseDetails>> _streamSubscription;

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    MobileAds.instance.initialize();

    initialize();
  }

  void initialize() async {
    bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      final Stream purchaseUpdates = InAppPurchase.instance.purchaseStream;
      _streamSubscription = purchaseUpdates.listen((purchases) async {
        premium = await listenToPurchaseUpdated(purchases);
        setState(() {});
      }) as StreamSubscription<List<PurchaseDetails>>;
      await InAppPurchase.instance.restorePurchases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final themeState = ref.watch(themeStateNotifierProvider);
      return MaterialApp(
          title: 'ACFT Calculator',
          theme: themeState,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
          home: Builder(builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).viewPadding.left,
                right: MediaQuery.of(context).viewPadding.right,
              ),
              child: MyHomePage(premium),
            );
          }));
    });
  }
}
