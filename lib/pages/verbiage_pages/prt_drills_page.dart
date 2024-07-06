import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../classes/verbiage.dart';
import '../../methods/theme_methods.dart';
import '../../providers/premium_state_provider.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/bullet_item.dart';
import '../../widgets/platform_widgets/platform_expansion_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../widgets/platform_widgets/platform_text_button.dart';

class PrtDrillsPage extends ConsumerStatefulWidget {
  static const String routeName = 'prtDrillsRoute';
  @override
  _PrtDrillsPageState createState() => _PrtDrillsPageState();
}

List<Verbiage> verbiages = <Verbiage>[
  Verbiage(
    false,
    'Preparation Drills (PD)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8j-dBwX1MiXoj_rwqk-Jm_3'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Bend and Reach (Slow)'),
          const BulletItem(text: 'Rear Lunge (Slow)'),
          const BulletItem(text: 'High Jumper (Moderate)'),
          const BulletItem(text: 'Rower (Slow)'),
          const BulletItem(text: 'Squat Bender (Slow)'),
          const BulletItem(text: 'Windmill (Slow)'),
          const BulletItem(text: 'Forward Lunge (Slow)'),
          const BulletItem(text: 'Prone Row (Slow)'),
          const BulletItem(text: 'Bent-Leg Body Twist (Slow)'),
          const BulletItem(text: 'Push-Up (Moderate)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Conditioning Drill 1 (CD1)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8ghIqLP8h6u7uhaRECVAa-p'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Power Jump (Moderate)'),
          const BulletItem(text: 'V-Up (Moderate)'),
          const BulletItem(text: 'Mountain Climber (Moderate)'),
          const BulletItem(text: 'Leg Tuck and Twist (Moderate)'),
          const BulletItem(text: 'Single-Leg Push-Up (Moderate)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Conditioning Drill 2 (CD2)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8gKWOyESbH0gOByN4YrmYCB'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Turn and Lunge (Slow)'),
          const BulletItem(text: 'Supine Bicycle (Slow)'),
          const BulletItem(text: 'Half Jack (Moderate)'),
          const BulletItem(text: 'Swimmer (Slow)'),
          const BulletItem(text: '8-Count Push-Up (Moderate)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Conditioning Drill 3 (CD3)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8iAf1EyXLwKVcJqzaFk9d8j'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: '\"Y\" Squat (Slow)'),
          const BulletItem(text: 'Single-Leg Deadlift (Slow)'),
          const BulletItem(text: 'Side-to-Side Knee Lifts (Moderate)'),
          const BulletItem(text: 'Front Kick Alt.-Toe Touch (Moderate)'),
          const BulletItem(text: 'Tuck Jump (Slow)'),
          const BulletItem(text: 'Straddle Run (Moderate)'),
          const BulletItem(text: 'Half-Squat Laterals (Moderate)'),
          const BulletItem(text: 'Frog Jumps (Moderate)'),
          const BulletItem(text: 'Alernate-1/4-Turn Jump (Moderate)'),
          const BulletItem(text: 'Alternate-Staggered-Squat Jump (Slow)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Climbing Drill 1 (CL1)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8ipRWIg6jaeMLi1W_u53Jrn'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Straight-Arm Pull (Moderate)'),
          const BulletItem(text: 'Heel Hook (Slow)'),
          const BulletItem(text: 'Pull-Up (Moderate)'),
          const BulletItem(text: 'Leg Tuck (Slow)'),
          const BulletItem(text: 'Alt. Grip Pull-Up (Moderate)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Climbing Drill 2 (CL2)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8iqhV1vT1KYyfvydI5tpIjs'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Flexed Arm Hang (5+ Seconds)'),
          const BulletItem(text: 'Heel Hook (Slow)'),
          const BulletItem(text: 'Pull-Up (Moderate)'),
          const BulletItem(text: 'Leg Tuck (Slow)'),
          const BulletItem(text: 'Alt. Grip Pull-Up (Moderate)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Military Movement Drill 1 (MMD1)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8j-PFwTbjCR6zQVJbnY6K6T'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Verticals (25 yds. x 2 intervals)'),
          const BulletItem(text: 'Laterals (25 yds. x 2 intervals)'),
          const BulletItem(text: 'Shuttle Sprint (25 yds. x 3 intervals)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Military Movement Drill 2 (MMD2)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8g6c2CALt0XrtES9pvA9HlO'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Power Skip (25 yds. x 2 intervals)'),
          const BulletItem(text: 'Crossovers (25 yds. x 2 intervals)'),
          const BulletItem(text: 'Crouch Run (25 yds. x 3 intervals)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Hip Stability Drill (HSD)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8hTuj98GybWZRy-8Oj4Peje'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Lateral Leg Raise (Slow)'),
          const BulletItem(text: 'Medial Leg Raise (Slow)'),
          const BulletItem(text: 'Bent-Leg Lateral Raise (Slow)'),
          const BulletItem(text: 'Single-Leg Tuck (Slow)'),
          const BulletItem(text: 'Single-Leg Over (20-30 Seconds)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Shoulder Stability Drill (SSD)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8h7UwBmsp49mo26D9U10Qca'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'I - Raise (Slow)'),
          const BulletItem(text: 'T - Raise (Slow)'),
          const BulletItem(text: 'Y - Raise (Slow)'),
          const BulletItem(text: 'L - Raise (Slow)'),
          const BulletItem(text: 'W - Raise (Slow)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Strength Traingin Circuit (STC)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8gMBDEwi2DEyPXlwQnd4rYh'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Sumo Squat'),
          const BulletItem(text: 'Straight Leg Deadlift'),
          const BulletItem(text: 'Forward Lunge'),
          const BulletItem(text: 'Step Up'),
          const BulletItem(text: 'Pull Up (Alt. Straight Arm Pull)'),
          const BulletItem(text: 'Supine Chest Press'),
          const BulletItem(text: 'Bent Over Row'),
          const BulletItem(text: 'Overhead Push Press'),
          const BulletItem(text: 'Supine Body Twist'),
          const BulletItem(text: 'Leg Tuck'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Landmine Drill 1 (LD1)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8iU3H_w4f3aYFvd8nYmVVz7'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Straight Leg Deadlift'),
          const BulletItem(text: 'Diagonal Press'),
          const BulletItem(text: 'Rear Lunge'),
          const BulletItem(text: '180 Degree Landmine'),
          const BulletItem(text: 'Lateral Lunge'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Landmine Drill 2 (LD2)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8g4jXBNXrW9n42Pjpz1tL84'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Diagonal Lift Press'),
          const BulletItem(text: 'Single Arm Chest Press'),
          const BulletItem(text: 'Kneeling 180 Landmine'),
          const BulletItem(text: 'Bent Over Row'),
          const BulletItem(text: 'Rear Lunge to Press'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Suspension Training Drill 1 (STD1)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8jxW7MnBbEQDyUC9Vlk2sWD'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Suspension Push Up'),
          const BulletItem(text: 'Incline Calf Raise'),
          const BulletItem(text: 'Decline I T Y Raise'),
          const BulletItem(text: 'Assisted Squat'),
          const BulletItem(text: 'Decline Bicep Curl'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Suspension Training Drill 2 (STD2)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8i5VUJj3ArKrv3Pjkh5aAjY'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Assisted Lateral Lunge'),
          const BulletItem(text: 'Leg Tuck and Pike'),
          const BulletItem(text: 'Decline Pull Up'),
          const BulletItem(text: 'Suspended Hamstring Curl'),
          const BulletItem(text: 'Assisted Single Leg Squat'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Medicine Ball Drill 1 (MBD1)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8iCO6d2olRRLg6LsiQ3FSJY'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Chest Pass Lateral'),
          const BulletItem(text: 'Alternate Side Arm Wall Throw'),
          const BulletItem(text: 'Diagonal Chop'),
          const BulletItem(text: 'Slam'),
          const BulletItem(text: 'Underhand Wall Throw'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Medicine Ball Drill 2 (MBD2)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8inLm_vj7_BWBDJWI7y3_DC'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Diagonal Chop Throw'),
          const BulletItem(text: 'Kneeling Side Arm Throw'),
          const BulletItem(text: 'Sumo Wall Throw'),
          const BulletItem(text: 'Sit Up Throw'),
          const BulletItem(text: 'Rainbow Slam'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Four for the Core (4C)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8jAG6xces1w_wbrJNNQj8c2'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Bent-Leg Raise (1 Minute)'),
          const BulletItem(text: 'Side Bridge (1 Minute Each Side)'),
          const BulletItem(text: 'Back Bridge (1 Minute)'),
          const BulletItem(text: 'Quadraplex (1 Minute Each Side)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Guerilla Drill (GD)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8jub6LJleYSEa3wJqmlby1f'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Shoulder Roll (25 yds)'),
          const BulletItem(text: 'Lunge Walk (25 yds)'),
          const BulletItem(text: 'Soldier Carry (25 yds Each Soldier)'),
        ],
      ),
    ),
  ),
  Verbiage(
    false,
    'Recovery Drill (RD)',
    Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          PlatformTextButton(
            onPressed: () => launchUrlString(
                'https://www.youtube.com/playlist?list=PLr_5M5FiwX8jOY18VazLbrvCMU9jbulM4'),
            child: Text(
              'Demonstration Video',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const BulletItem(text: 'Overhead Arm Pull (20-30 Seconds)'),
          const BulletItem(text: 'Rear Lunge (20-30 Seconds)'),
          const BulletItem(text: 'Extend and Flex (20-30 Seconds)'),
          const BulletItem(text: 'Thigh Stretch (20-30 Seconds)'),
          const BulletItem(text: 'Single-Leg Over (20-30 Seconds)'),
          const BulletItem(text: 'Groin Stretch (20-30 Seconds)'),
          const BulletItem(text: 'Calf Stretch (20-30 Seconds)'),
          const BulletItem(text: 'Hamstring Stretch (20-30 Seconds)'),
        ],
      ),
    ),
  ),
];

class _PrtDrillsPageState extends ConsumerState<PrtDrillsPage> {
  BannerAd? myBanner;

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      bool trackingAllowed = ref.read(trackingProvider);
      myBanner = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-2431077176117105/6684002506'
            : 'ca-app-pub-2431077176117105/8384096980',
        size: AdSize.banner,
        listener: BannerAdListener(),
        request: AdRequest(
          nonPersonalizedAds: !trackingAllowed,
        ),
      );

      myBanner!.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPremium = false;
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      isPremium = true;
    } else {
      final prefs = ref.read(sharedPreferencesProvider);
      isPremium = ref.read(premiumStateProvider) ||
          (prefs.getBool('isPremium') ?? false);
    }
    final expansionTextStyle =
        TextStyle(color: getOnPrimaryColor(context), fontSize: 22);
    return PlatformScaffold(
      title: 'PRT Drills',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: ListView(
                children: <Widget>[
                  ...verbiages.map(
                    (verbiage) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: PlatformExpansionTile(
                          title: Text(
                            verbiage.header,
                            style: expansionTextStyle,
                          ),
                          trailing: Platform.isAndroid
                              ? Icon(
                                  Icons.arrow_drop_down,
                                  color: getOnPrimaryColor(context),
                                )
                              : Icon(
                                  CupertinoIcons.chevron_down,
                                  color: getOnPrimaryColor(context),
                                ),
                          collapsedBackgroundColor: getPrimaryColor(context),
                          collapsedTextColor: getOnPrimaryColor(context),
                          collapsedIconColor: getOnPrimaryColor(context),
                          textColor: getOnPrimaryColor(context),
                          children: [verbiage.body],
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
            if (!isPremium)
              Container(
                constraints: BoxConstraints(maxHeight: 90),
                alignment: Alignment.center,
                child: AdWidget(
                  ad: myBanner!,
                ),
                width: myBanner!.size.width.toDouble(),
                height: myBanner!.size.height.toDouble(),
              )
          ],
        ),
      ),
    );
  }
}
