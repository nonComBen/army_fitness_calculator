import 'package:acft_calculator/pages/mdl_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../pages/verbiage_pages/apft_verbiage_page.dart';
import '../pages/verbiage_pages/acft_verbiage_page.dart';
import '../pages/verbiage_pages/bodyfat_verbiage_page.dart';
import '../pages/privacy_policy_page.dart';
import '../pages/saved_pages/saved_acfts_page.dart';
import '../pages/saved_pages/saved_apfts_page.dart';
import '../pages/saved_pages/saved_bodyfats_page.dart';
import '../pages/saved_pages/saved_ppw_page.dart';
import '../pages/settings_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
    @required this.context,
    @required this.isPremium,
    @required this.upgradeNeeded,
    @required this.upgrade,
  }) : super(key: key);
  final BuildContext context;
  final bool isPremium;
  final Function upgradeNeeded;
  final Function upgrade;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Saved ACFT Scores'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.pop(context);
              if (isPremium) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedAcftsPage()));
              } else {
                upgradeNeeded();
              }
            },
          ),
          ListTile(
            title: const Text('Saved APFT Scores'),
            leading: const Icon(Icons.directions_run),
            onTap: () {
              Navigator.pop(context);
              if (isPremium) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedApftsPage()));
              } else {
                upgradeNeeded();
              }
            },
          ),
          ListTile(
            title: const Text('Saved Body Comp Scores'),
            leading: const Icon(Icons.accessibility),
            onTap: () {
              Navigator.pop(context);
              if (isPremium) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavedBodyfatsPage()));
              } else {
                upgradeNeeded();
              }
            },
          ),
          ListTile(
            title: const Text('Saved Promotion Point Scores'),
            leading: const Icon(Icons.attach_money),
            onTap: () {
              Navigator.pop(context);
              if (isPremium) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedPpwsPage()));
              } else {
                upgradeNeeded();
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('ACFT Instructions'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AcftVerbiagePage(
                            isPremium: isPremium,
                          )));
            },
          ),
          ListTile(
            title: const Text('MDL Setup'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MdlSetupPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('APFT Instructions'),
            leading: const Icon(Icons.directions_run),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApftVerbiagePage(
                            isPremium: isPremium,
                          )));
            },
          ),
          ListTile(
            title: const Text('Body Comp Instructions'),
            leading: const Icon(Icons.accessibility),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BodyfatVerbiagePage(
                            isPremium: isPremium,
                          )));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('www.army.mil/acft'),
            leading: const Icon(Icons.web),
            onTap: () {
              Navigator.pop(context);
              launchUrlString('https://www.army.mil/acft');
            },
          ),
          ListTile(
            title: const Text('Premium'),
            leading: const Icon(Icons.monetization_on),
            onTap: () {
              Navigator.pop(context);
              if (isPremium) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('You are already upgraded to Premium'),
                ));
              } else {
                upgrade();
              }
            },
          ),
          ListTile(
            title: const Text('Rate App'),
            leading: const Icon(Icons.rate_review),
            onTap: () {
              Navigator.pop(context);
              LaunchReview.launch(
                  androidAppId: 'com.armynoncomtools.acft_calculator',
                  iOSAppId: '1482254260');
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            leading: const Icon(Icons.email),
            onTap: () {
              Navigator.pop(context);
              launchUrlString('mailto:armynoncomtools@gmail.com');
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsPage(isPremium: isPremium)));
            },
          ),
        ],
      ),
    );
  }
}
