import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../pages/apft_page.dart';
import '../../widgets/header_text.dart';
import '../../widgets/platform_widgets/platform_list_tile.dart';
import '../verbiage_pages/apft_verbiage_page.dart';
import '../verbiage_pages/acft_verbiage_page.dart';
import '../verbiage_pages/bodyfat_verbiage_page.dart';
import '../privacy_policy_page.dart';
import '../saved_pages/saved_acfts_page.dart';
import '../saved_pages/saved_apfts_page.dart';
import '../saved_pages/saved_bodyfats_page.dart';
import '../saved_pages/saved_ppw_page.dart';
import '../settings_page.dart';
import '../mdl_setup_page.dart';
import '../../providers/purchases_provider.dart';

class OverflowTab extends ConsumerWidget {
  const OverflowTab({
    Key? key,
  }) : super(key: key);

  static const String title = 'Overflow Menu';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesService = ref.read(purchasesProvider);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Center(
            child: HeaderText(
              text: 'Premium',
            ),
          ),
          PlatformListTile(
            title: const Text('Saved ACFT Scores'),
            leading: Icon(
              Icons.fitness_center,
              color: getTextColor(context),
            ),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(SavedAcftsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          PlatformListTile(
            title: const Text('Saved APFT Scores'),
            leading: Icon(
              Icons.directions_run,
              color: getTextColor(context),
            ),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(SavedApftsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          PlatformListTile(
            title: const Text('Saved Body Comp Scores'),
            leading: Icon(
              Icons.accessibility,
              color: getTextColor(context),
            ),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(SavedBodyfatsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          PlatformListTile(
            title: const Text('Saved Promotion Point Scores'),
            leading: Icon(
              Icons.attach_money,
              color: getTextColor(context),
            ),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(SavedPpwsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          const Divider(),
          Center(
            child: HeaderText(text: 'Instructions'),
          ),
          PlatformListTile(
            title: const Text('ACFT Instructions'),
            leading: Icon(
              Icons.fitness_center,
              color: getTextColor(context),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(AcftVerbiagePage.routeName);
            },
          ),
          PlatformListTile(
            title: const Text('MDL Setup'),
            leading: Icon(
              Icons.fitness_center,
              color: getTextColor(context),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(MdlSetupPage.routeName);
            },
          ),
          PlatformListTile(
            title: const Text('APFT Instructions'),
            leading: Icon(
              Icons.directions_run,
              color: getTextColor(context),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(ApftVerbiagePage.routeName);
            },
          ),
          PlatformListTile(
            title: const Text('Body Comp Instructions'),
            leading: Icon(
              Icons.accessibility,
              color: getTextColor(context),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(BodyfatVerbiagePage.routeName);
            },
          ),
          const Divider(),
          Center(
            child: HeaderText(
              text: 'Other',
            ),
          ),
          PlatformListTile(
            title: const Text('AFPT Calculator'),
            leading: Icon(
              Icons.directions_run,
              color: getTextColor(context),
            ),
            onTap: () => Navigator.of(context, rootNavigator: true)
                .pushNamed(ApftPage.routeName),
          ),
          PlatformListTile(
            title: const Text('www.army.mil/acft'),
            leading: Icon(
              Icons.web,
              color: getTextColor(context),
            ),
            onTap: () {
              launchUrlString('https://www.army.mil/acft');
            },
          ),
          PlatformListTile(
            title: const Text('Upgrade'),
            leading: Icon(
              Icons.monetization_on,
              color: getTextColor(context),
            ),
            onTap: () {
              if (purchasesService.isPremium) {
                FToast toast = FToast();
                toast.context = context;
                toast.showToast(
                  child: MyToast(
                    contents: [
                      Text(
                        'You are already upgraded to Premium',
                        style: TextStyle(
                          color: getOnPrimaryColor(context),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                purchasesService.upgrade(context);
              }
            },
          ),
          PlatformListTile(
            title: const Text('Rate App'),
            leading: Icon(
              Icons.rate_review,
              color: getTextColor(context),
            ),
            onTap: () {
              RateMyApp rateMyApp = RateMyApp();
              rateMyApp.launchStore();
            },
          ),
          PlatformListTile(
            title: const Text('Privacy Policy'),
            leading: Icon(
              Icons.info,
              color: getTextColor(context),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(PrivacyPolicyPage.routeName);
            },
          ),
          PlatformListTile(
            title: const Text('Contact Us'),
            leading: Icon(
              Icons.email,
              color: getTextColor(context),
            ),
            onTap: () {
              launchUrlString('mailto:armynoncomtools@gmail.com');
            },
          ),
          PlatformListTile(
            title: const Text('Settings'),
            leading: Icon(
              Icons.settings,
              color: getTextColor(context),
            ),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(SettingsPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
