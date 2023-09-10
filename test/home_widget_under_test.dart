import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/pages/tabs/acft_page.dart';
import 'package:acft_calculator/pages/tabs/bodyfat_page.dart';
import 'package:acft_calculator/pages/tabs/overflow_tab.dart';
import 'package:acft_calculator/pages/tabs/ppw_page.dart';
import 'package:acft_calculator/widgets/platform_widgets/platform_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

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

Widget androidHomeWidgetUnderTest(int index) {
  return Scaffold(
    appBar: AppBar(
      title: Text(titles[index]),
      actions: [
        if (index == 0)
          IconButton(
            onPressed: null,
            icon: Icon(Icons.fitness_center),
          ),
        if (index == 0)
          IconButton(
            onPressed: null,
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
        index = value;
      },
    ),
    body: pages[index],
  );
}

Widget iosHomeWidgetUnderTest(int index) {
  return CupertinoTabScaffold(
    tabBar: CupertinoTabBar(
      items: [
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
      activeColor: Colors.yellow,
    ),
    tabBuilder: (context, index) {
      return CupertinoTabView(
        defaultTitle: titles[index],
        builder: (context) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: getPrimaryColor(context),
            trailing: index == 0
                ? PullDownButton(
                    itemBuilder: (context) => [
                      PullDownMenuItem(
                        onTap: null,
                        title: 'MDL Setup',
                      ),
                      PullDownMenuItem(
                        onTap: null,
                        title: 'ACFT Table',
                      )
                    ],
                    buttonBuilder: (context, showMenu) => IOSIconButton(
                      child: Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: getOnPrimaryColor(context),
                      ),
                      onTap: showMenu,
                    ),
                  )
                : null,
          ),
          child: pages[index],
        ),
      );
    },
  );
}
