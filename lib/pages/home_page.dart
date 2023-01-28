import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'tabs/acft_page.dart';
import 'tabs/bodyfat_page.dart';
import 'tabs/ppw_page.dart';
import 'table_pages/acft_table_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(this.isPremium);
  final bool isPremium;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'ACFT Calculator';
  int _selectedIndex = 0;
  late Set<String> productIds;
  late List<ProductDetails> _products;
  bool adLoaded = false;

  late List<Widget> _pages;

  List<String> _titles = <String>[
    'ACFT Calculator',
    'APFT Calculator',
    'Body Composition Calculator',
    'Promotion Point Calculator'
  ];

  RateMyApp _rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 5,
    remindDays: 7,
    remindLaunches: 5,
  );

  BannerAd? myBanner;

  bool _loadingAnchoredBanner = false;

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
  void dispose() {
    super.dispose();
  }

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
        // test ad unit ids
        // adUnitId: Platform.isAndroid
        //     ? 'ca-app-pub-3940256099942544/6300978111'
        //     : 'ca-app-pub-3940256099942544/2934735716',
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

    myBanner!.load();
  }

  int getSmartBannerHeight(BuildContext context) {
    int height = MediaQuery.of(context).size.height.toInt();

    if (height > 720.0) return 100;
    return 50;
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

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner && !widget.isPremium) {
      _loadingAnchoredBanner = true;
      _createBannerAd(context);
    }
    _pages = <Widget>[AcftPage(), BodyfatPage(), PromotionPointPage()];
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            if (_selectedIndex == 0)
              IconButton(
                  onPressed: () => _openTablePage(),
                  icon: Icon(Icons.table_chart))
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _pages.elementAt(_selectedIndex)),
            if (!widget.isPremium && adLoaded)
              Container(
                constraints: BoxConstraints(maxHeight: 90),
                alignment: Alignment.center,
                child: AdWidget(
                  ad: myBanner!,
                ),
                width: myBanner != null ? myBanner!.size.width.toDouble() : 320,
                height:
                    myBanner != null ? myBanner!.size.height.toDouble() : 100,
              )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: 'ACFT'),
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
