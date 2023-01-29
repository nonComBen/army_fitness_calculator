import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../pages/tabs/acft_page.dart';
import '../../pages/tabs/bodyfat_page.dart';
import '../../pages/tabs/ppw_page.dart';
import '../../providers/ad_provider.dart';
import '../../providers/purchases_provider.dart';
import '../../pages/table_pages/acft_table_page.dart';
import '../../pages/tabs/overflow_tab.dart';

abstract class PlatformHomePage extends StatefulWidget {
  factory PlatformHomePage() {
    if (Platform.isAndroid) {
      return AndroidHomePage();
    } else {
      return const IOSHomePage();
    }
  }
}

class AndroidHomePage extends ConsumerStatefulWidget
    implements PlatformHomePage {
  const AndroidHomePage();

  @override
  ConsumerState<AndroidHomePage> createState() => _AndroidHomePageState();
}

class _AndroidHomePageState extends ConsumerState<AndroidHomePage> {
  int index = 0;
  List<Widget> pages = [
    AcftPage(),
    BodyfatPage(),
    PromotionPointPage(),
    OverflowTab(),
  ];
  List<String> titles = const [
    AcftPage.title,
    BodyfatPage.title,
    PromotionPointPage.title,
    OverflowTab.title,
  ];
  final RateMyApp _rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 5,
    remindDays: 7,
    remindLaunches: 5,
  );

  @override
  void initState() {
    super.initState();

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
    final adService = ref.watch(adProvider);
    adService.initialize(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
    final purchasesService = ref.watch(purchasesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
        actions: [
          if (index == 0)
            IconButton(
              onPressed: () => _openTablePage(),
              icon: Icon(Icons.table_chart),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.fitness_center,
            ),
            label: 'ACFT',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.accessibility,
            ),
            label: 'Body Comp',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.attach_money,
            ),
            label: 'PPW',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
      ),
      body: Column(
        children: [
          Expanded(child: pages[index]),
          if (!purchasesService.isPremium && adService.adLoaded)
            Container(
              constraints: BoxConstraints(maxHeight: 90),
              alignment: Alignment.center,
              child: AdWidget(
                ad: adService.bannerAd!,
              ),
              width: adService.bannerAd != null
                  ? adService.bannerAd!.size.width.toDouble()
                  : 320,
              height: adService.bannerAd != null
                  ? adService.bannerAd!.size.height.toDouble()
                  : 100,
            )
        ],
      ),
    );
  }
}

class IOSHomePage extends ConsumerStatefulWidget implements PlatformHomePage {
  const IOSHomePage();

  @override
  ConsumerState<IOSHomePage> createState() => _IOSHomePageState();
}

class _IOSHomePageState extends ConsumerState<IOSHomePage> {
  final RateMyApp _rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 5,
    remindDays: 7,
    remindLaunches: 5,
  );

  @override
  void initState() {
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    final adService = ref.watch(adProvider);
    adService.initialize(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
    final purchasesService = ref.watch(purchasesProvider);
    final tabs = [
      AcftPage(),
      BodyfatPage(),
      PromotionPointPage(),
      OverflowTab(),
    ];
    final titles = [
      AcftPage.title,
      BodyfatPage.title,
      PromotionPointPage.title,
      OverflowTab.title,
    ];
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'ACFT',
            icon: Icon(CupertinoIcons.stopwatch_fill),
          ),
          BottomNavigationBarItem(
            label: 'Body Comp',
            icon: Icon(CupertinoIcons.lab_flask),
          ),
          BottomNavigationBarItem(
            label: 'PPW',
            icon: Icon(CupertinoIcons.money_dollar),
          ),
          BottomNavigationBarItem(
            label: 'More',
            icon: Icon(CupertinoIcons.ellipsis),
          ),
        ],
        activeColor: Theme.of(context).primaryColor,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          defaultTitle: titles[index],
          builder: (context) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              trailing: index == 0
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => AcftTablePage(
                              ageGroup: AcftPageState.ageGroup,
                              gender: AcftPageState.gender,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.table_chart),
                    )
                  : null,
            ),
            child: Column(
              children: [
                Expanded(child: tabs[index]),
                if (!purchasesService.isPremium && adService.adLoaded)
                  Container(
                    constraints: BoxConstraints(maxHeight: 90),
                    alignment: Alignment.center,
                    child: AdWidget(
                      ad: adService.bannerAd!,
                    ),
                    width: adService.bannerAd != null
                        ? adService.bannerAd!.size.width.toDouble()
                        : 320,
                    height: adService.bannerAd != null
                        ? adService.bannerAd!.size.height.toDouble()
                        : 100,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
