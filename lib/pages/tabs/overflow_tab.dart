import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../pages/apft_page.dart';
import '../../widgets/header_text.dart';
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
          ListTile(
            title: const Text('Saved ACFT Scores'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context).pushNamed(SavedAcftsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          ListTile(
            title: const Text('Saved APFT Scores'),
            leading: const Icon(Icons.directions_run),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context).pushNamed(SavedApftsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          ListTile(
            title: const Text('Saved Body Comp Scores'),
            leading: const Icon(Icons.accessibility),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context).pushNamed(SavedBodyfatsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          ListTile(
            title: const Text('Saved Promotion Point Scores'),
            leading: const Icon(Icons.attach_money),
            onTap: () {
              if (purchasesService.isPremium) {
                Navigator.of(context).pushNamed(SavedPpwsPage.routeName);
              } else {
                purchasesService.upgradeNeeded(context);
              }
            },
          ),
          const Divider(),
          Center(
            child: HeaderText(text: 'Instructions'),
          ),
          ListTile(
            title: const Text('ACFT Instructions'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.of(context).pushNamed(AcftVerbiagePage.routeName);
            },
          ),
          ListTile(
            title: const Text('MDL Setup'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.of(context).pushNamed(MdlSetupPage.routeName);
            },
          ),
          ListTile(
            title: const Text('APFT Instructions'),
            leading: const Icon(Icons.directions_run),
            onTap: () {
              Navigator.of(context).pushNamed(ApftVerbiagePage.routeName);
            },
          ),
          ListTile(
            title: const Text('Body Comp Instructions'),
            leading: const Icon(Icons.accessibility),
            onTap: () {
              Navigator.of(context).pushNamed(BodyfatVerbiagePage.routeName);
            },
          ),
          const Divider(),
          Center(
            child: HeaderText(
              text: 'Other',
            ),
          ),
          ListTile(
            title: const Text('AFPT Calculator'),
            leading: const Icon(Icons.directions_run),
            onTap: () => Navigator.of(context).pushNamed(ApftPage.routeName),
          ),
          ListTile(
            title: const Text('www.army.mil/acft'),
            leading: const Icon(Icons.web),
            onTap: () {
              launchUrlString('https://www.army.mil/acft');
            },
          ),
          ListTile(
            title: const Text('Upgrade'),
            leading: const Icon(Icons.monetization_on),
            onTap: () {
              if (purchasesService.isPremium) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('You are already upgraded to Premium'),
                ));
              } else {
                purchasesService.upgrade(context);
              }
            },
          ),
          ListTile(
            title: const Text('Rate App'),
            leading: const Icon(Icons.rate_review),
            onTap: () {
              RateMyApp rateMyApp = RateMyApp();
              rateMyApp.launchStore();
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.of(context).pushNamed(PrivacyPolicyPage.routeName);
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            leading: const Icon(Icons.email),
            onTap: () {
              launchUrlString('mailto:armynoncomtools@gmail.com');
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
