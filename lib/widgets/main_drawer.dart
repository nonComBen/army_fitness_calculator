import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../acftVerbiage.dart';
import '../apftVerbiage.dart';
import '../bodyfatVerbiage.dart';
import '../privacyPolicyPage.dart';
import '../savedPages/savedAcftsPage.dart';
import '../savedPages/savedApftsPage.dart';
import '../savedPages/savedBodyfatsPage.dart';
import '../savedPages/savedPpwPage.dart';
import '../settingsPage.dart';

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
                            premium: isPremium,
                          )));
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
                            premium: isPremium,
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
                            premium: isPremium,
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
                      builder: (context) => SettingsPage(premium: isPremium)));
            },
          ),
        ],
      ),
    );
  }
}
