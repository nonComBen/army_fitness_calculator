import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool premium = true, adLoaded = false;
  StreamSubscription<List<PurchaseDetails>> _streamSubscription;

  BannerAd myBanner;

  bool _loadingAnchoredBanner = false;

  void _createBannerAd(BuildContext context) async {
    bool nonPersonalizedAds = false;
    if (Platform.isIOS) {
      PermissionStatus status = await Permission.appTrackingTransparency.status;
      if (status.isDenied) {
        status = await Permission.appTrackingTransparency.request();
      }
      nonPersonalizedAds = !status.isGranted;
    }
    myBanner = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-2431077176117105/8950325543'
            : 'ca-app-pub-2431077176117105/4488336359',
        size: AdSize(
            height: getSmartBannerHeight(context),
            width: MediaQuery.of(context).size.width.truncate()),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(
              () {
                adLoaded = true;
              },
            );
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
        ),
        request: AdRequest(
            keywords: <String>['army', 'military', 'fitness', 'outdoors'],
            nonPersonalizedAds: nonPersonalizedAds));

    myBanner.load();
  }

  int getSmartBannerHeight(BuildContext context) {
    int height = MediaQuery.of(context).size.height.toInt();

    if (height > 720.0) return 100;
    return 50;
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    myBanner?.dispose();
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
      });
      await InAppPurchase.instance.restorePurchases();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final themeState = ref.watch(themeStateNotifierProvider);
      return MaterialApp(
          title: 'ACFT Calculator',
          theme: themeState,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child,
            );
          },
          home: Builder(builder: (BuildContext context) {
            if (!_loadingAnchoredBanner && !premium) {
              _loadingAnchoredBanner = true;
              _createBannerAd(context);
            }
            return Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).viewPadding.left,
                right: MediaQuery.of(context).viewPadding.right,
                bottom: MediaQuery.of(context).viewPadding.bottom + 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: MyHomePage(premium)),
                  if (!premium && adLoaded)
                    Container(
                      constraints: BoxConstraints(maxHeight: 90),
                      alignment: Alignment.center,
                      child: AdWidget(
                        ad: myBanner,
                      ),
                      width: myBanner != null
                          ? myBanner.size.width.toDouble()
                          : 320,
                      height: myBanner != null
                          ? myBanner.size.height.toDouble()
                          : 100,
                    )
                ],
              ),
            );
          }));
    });
  }
}
