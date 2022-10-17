import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import './methods/verify_purchase.dart';
import './ppwPage.dart';
import './providers/shared_preferences_provider.dart';
import './providers/theme_provider.dart';
import './acftPage.dart';
import './apftPage.dart';
import './bodyfatPage.dart';
import 'table_pages/acft_table_page.dart';
import 'widgets/bullet_item.dart';
import 'widgets/main_drawer.dart';

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
                  right: MediaQuery.of(context).viewPadding.right),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: MyHomePage(premium)),
                  if (!premium && adLoaded)
                    Container(
                      constraints: BoxConstraints(maxHeight: 90),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewPadding.bottom),
                        child: AdWidget(
                          ad: myBanner,
                        ),
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

class MyHomePage extends StatefulWidget {
  MyHomePage(this.isPremium);
  final bool isPremium;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'ACFT Calculator';
  int _selectedIndex = 0;
  Set<String> productIds;
  List<ProductDetails> _products;

  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  List<Widget> _pages;

  List<String> _titles = <String>[
    'ACFT Calculator',
    'APFT Calculator',
    'Body Composition Calculator',
    'Promotion Point Calculator'
  ];

  RateMyApp _rateMyApp = RateMyApp(
    minDays: 0,
    minLaunches: 2,
    remindDays: 0,
    remindLaunches: 3,
  );

  _upgrade() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
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
                  child: ElevatedButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Upgrade',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_products.isEmpty) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                              'Upgrading is not available at this time'),
                        ));
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openTablePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AcftTablePage(
          ageGroup: AcftPageState.ageGroup,
          gender: AcftPageState.gender,
        ),
      ),
    );
  }

  upgradeNeeded() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          const Text('Saving scores is only available on the Premium version'),
      action: SnackBarAction(
        label: 'Upgrade',
        onPressed: () {
          _upgrade();
        },
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    productIds = ['premium_upgrade'].toSet();

    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showRateDialog(
          context,
          title: 'Rate Army Fitness Calculator',
          message:
              'If you like Army Fitness Calculator, please take a minute to rate '
              ' and review the app.  Or if you are having an issue with the app, '
              'please email me at armynoncomtools@gmail.com.',
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          rateButton: 'Rate',
          laterButton: 'Not Now',
          noButton: 'No Thanks',
        );
      }
    });

    InAppPurchase.instance.isAvailable().then((isStoreAvailable) {
      if (isStoreAvailable) {
        InAppPurchase.instance.queryProductDetails(productIds).then((response) {
          if (response.notFoundIDs.isEmpty) {}
          setState(() {
            _products = response.productDetails;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = <Widget>[
      AcftPage(widget.isPremium, upgradeNeeded),
      ApftPage(widget.isPremium, upgradeNeeded),
      BodyfatPage(widget.isPremium, upgradeNeeded),
      PromotionPointPage(widget.isPremium, upgradeNeeded)
    ];
    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: Text(title),
          actions: [
            if (_selectedIndex == 0)
              IconButton(
                  onPressed: () => _openTablePage(),
                  icon: Icon(Icons.table_chart))
          ],
        ),
        drawer: MainDrawer(
            context: context,
            isPremium: widget.isPremium,
            upgradeNeeded: upgradeNeeded,
            upgrade: _upgrade),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: 'ACFT'),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_run), label: 'APFT'),
            BottomNavigationBarItem(
                icon: Icon(Icons.accessibility), label: 'Ht/Wt'),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: 'PPW')
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          onTap: ((int index) {
            setState(() {
              _selectedIndex = index;
              title = _titles[index];
            });
          }),
        ));
  }
}
