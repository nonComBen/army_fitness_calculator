import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../classes/verbiage.dart';
import '../../methods/theme_methods.dart';
import '../../providers/premium_state_provider.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/platform_widgets/platform_expansion_list_tile.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class AcftVerbiagePage extends ConsumerStatefulWidget {
  static const String routeName = 'acftVerbiageRoute';
  @override
  _AcftVerbiagePageState createState() => _AcftVerbiagePageState();
}

List<Verbiage> verbiages = <Verbiage>[
  Verbiage(
      false,
      '3 REPETITION MAXIMUM DEADLIFT (MDL)',
      Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Starting Position'
          '\n\nThe Soldier will step inside the hexagon/trap bar, feet generally shoulder width apart, and locate the midpoint of the hexagon/trap bar handles.'
          '\n\nPhase 1 Preparatory Phase'
          '\n\nOn the command of “GET SET,” the Soldier will bend at the knees and hips, reach down and grasp the center of the handles (Hexagon/traps bars are not authorized; as an exception, if a dual-handled hexagon/trap bar is used, the Soldier will grasp the lower handles). Arms should be fully extended, back flat, head in line with the spinal column or slightly extended, head and eyes to the front or slightly upward, and heels in contact with the ground. All repetitions will begin from this position.'
          '\n\nPhase 2 Upward Movement Phase'
          '\n\nOn the command of “GO,” the Soldier will stand up and lift the bar by extending the hips and knees. Hips should never rise before or above the shoulders. The back should remain straight - not flexed or extended. The Soldier will continue to extend the hips and knees until reaching an upright stance. There is a slight pause at the top of this movement.'
          '\n\nPhase 3 Downward Movement Phase'
          '\n\nBy flexing the hips and the knees slowly, the Soldier lowers the bar to the ground under control while maintaining a flat-back position. Do not drop or let go of the bar. The hexagon/trap bar weight plates must touch the ground before beginning the next repetition. Weight plates may not bounce on the ground.'
          '\n\nExecute three continuous repetitions with the same weight. If the Soldier fails to complete three continuous repetitions under control, he or she is permitted one retest at a lower weight. If the Soldier successfully completes three continuous repetitions on the first attempt, he or she may elect an additional attempt at a higher weight. The maximum number of attempts on the MDL is two.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      'STANDING POWER THROW (SPT)',
      Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Starting Position'
          '\n\nThe Soldiers will face away from the start line, grasp the medicine ball (10 pounds) with both hands at hip level and stand with both heels at (but not on or over) the start line. Grasp the ball firmly and as far around the sides of the ball as possible. Towels or rags will be provided to remove excess moisture/debris from the medicine ball.'
          '\n\nRecord Throws'
          '\n\nAs directed by the grader, the Soldier in lane one executes throw one. Soldiers are permitted several preparatory movements flexing at the trunk, knees, and hips while lowering the ball between their legs. When directed by the grader, the Soldier in lane two executes throw one.'
          '\n\nSoldiers will have two record attempts on the Standing Power Throw. Soldiers in lanes one and two will alternately execute record throw one and two. As directed by the grader, the Soldier in lane one executes the first record attempt. Soldiers are permitted several preparatory movements flexing at the trunk, knees, and hips while lowering the ball between their legs. When directed by the grader, the Soldier in lane two executes first record attempt. A record attempt will not count if a Soldier steps on or beyond the start line or falls to the ground.'
          '\n\nIf a Soldier faults on the first record throw, they will receive a raw score of 0.0 meters. If a Soldier faults on the second record throw, they will receive a raw score of 0.0 meters. This Soldier will be allowed one additional attempt to score on the SPT. If the Soldier faults on all three record throws, they will receive a raw score of 0.0 meters for the SPT. If a Soldier has a valid score on either record the first and second throw, they will not be allowed a third attempt.'
          '\n\nOnce the Soldier has attempted two record throws, they will move onto the SPT lane to retrieve the medicine balls for the next Soldiers, and then return to the back of the line.'
          '\n\nAlthough Soldiers are required to execute two record throws and both record throws are recorded, only the longer of the two throws will count as the record score. The start line grader will circle the best score.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      'HAND-RELEASE PUSH-UP (HRP)',
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Starting position'
          '\n\nOn the command of “GET SET,” one Soldier in each lane will assume the prone position facing the start line with hands flat on the ground and index fingers inside the outer edges of the shoulders. The chest and front of the hips and thighs will be on the ground. Toes will touch the ground with feet together or up to a boot\'s width apart. The ankles will be flexed. The head does not have to be on the ground. Feet will remain generally together, no more than a boot\'s width apart, throughout the HRP. Soldiers may adjust their feet during the test event as long as they do not lift a foot off the ground.'
          '\n\nMovement 1'
          '\n\nOn the command “GO,” a Soldier will push their whole body up from the ground as a single unit to the up position by fully extending the elbows (front leaning rest).'
          '\n\nThe Soldier will maintain a generally straight body alignment from the top of the head to the ankles. This generally straight position will be maintained for the duration of the HRP.'
          '\n\nFailing to maintain a generally straight alignment during a repetition will cause that repetition to not count.'
          '\n\nThe front leaning rest is the only authorized rest position. Bending or flexing the knees, hips, trunk, or neck while in the rest position is not authorized.'
          '\n\nMovement 2'
          '\n\nAfter the elbows are fully extended and the Soldier has reached the up position, the Soldier will bend their elbows to lower the body back to the ground. The chest, hips and thighs should touch down at the same time. The head or face do not have to contact the ground.'
          '\n\nMovement 3'
          '\n\nArm Extension HRP - immediately move both arms out to the side straightening the elbows into the T position. After reaching this position, the elbows bend to move the hands back under the shoulder.'
          '\n\nMovement 4'
          '\n\nRegardless of the HRP protocol, Soldiers must ensure their hands are flat on the ground with the index fingers inside the outer edges of the shoulders (returning to the starting position). This completes one repetition.'
          '\n\nThe Soldier will make an immediate movement to place their hands back on the ground to return to the starting position.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      'SPRINT-DRAG-CARRY (SDC)',
      Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Starting position'
          '\n\nOn the command “GET SET,” one Soldier in each lane will assume the prone position with the top of the head behind the start line. The grader is positioned to see both the start line and the 25m line. The grader can position a Soldier/battle buddy on the 25m line to ensure compliance with test event standards.'
          '\n\nSprint'
          '\n\nOn the command “GO,” Soldiers stand and sprint 25m; touch the 25m line with foot and hand; turn and sprint back to the start line. If the Soldier fails to touch the 25m line with hand and foot, the grader watching the 25m turn line will call them back.'
          '\n\nDrag'
          '\n\nSoldiers will grasp each strap handle, which will be positioned and resting on the sled behind the start line; pull the sled backwards until the entire sled crosses the 25m line; turn the sled around and pull back until the entire sled crosses the start line. If the entire sled does not cross the 25m or start line, the grader watching the 25m turn line will call them back.'
          '\n\nLateral'
          '\n\nAfter the entire sled crosses the start line, the Soldier will perform a lateral for 25m, touch the 25m turn line with foot and hand, and perform the lateral back to the start line. The Soldier will face the same direction moving back to the 25m start line and returning to the start line so they lead with each foot. If the Soldier fails to touch the 25m turn line with hand and foot, the grader watching the 25m turn line will call them back. Graders will correct Soldiers if they cross their feet.'
          '\n\nCarry'
          '\n\nSoldiers will grasp the handles of the two 40-pound kettlebells and run to the 25m turn line; step on or over the 25m turn line with one foot; turn and run back to the start line. If the Soldier drops the kettlebells during movement, the carry will resume from the point the kettlebells were dropped. If the Soldier fails to touch the 25m turn line with their foot, the grader watching the 25m turn line will call them back.'
          '\n\nSprint'
          '\n\nAfter stepping on/over the start line, Soldiers will place the kettlebells on the ground; turn and sprint 25m; touch the 25m turn line with foot and hand; turn and sprint back to the start line. If the Soldier fails to touch the 25m turn line with hand and foot, the grader watching the 25m turn line will call them back.'
          '\n\nThe time is stopped when the Soldier crosses the start line after the final sprint (250 meters).',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      'PLANK (PLK)',
      Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Starting position '
          '\n\nOn the command “GET READY” hands must be on the ground, either in fists with pinky side of the hand touching the ground or lying flat with palms down, no more than the grader\'s fist-width apart; elbows will be bent, aligned with the shoulders, forearms flat on the ground forming a triangle; hips should be bent with one or both knees resting on the ground.'
          '\n\nExecution '
          '\n\nOnce all Soldiers are in the ready position, the grader shall issue the command “GRADERS READY, GET SET”, and then “GO.” On “GO” the Soldier lifts both knees off the ground and moves the hips into a straight line with the legs, shoulders, head and eyes focused on the ground, similar to the “front leaning rest” position.'
          '\n\nFeet may be up to the graders\' boot-width apart. Elbows should be aligned with the shoulders with forearms forming a triangle. Ankles should be flexed with the bottom of the toes on the ground. Maintain a straight body alignment from the head to the ankles. After the command “GO”, the grader will call out 15 second time intervals until the completion of the event. Time is tracked with a stopwatch.'
          '\n\nThe head, shoulders, back, hips and legs shall be straight from head to heels and must remain so throughout the test. Feet, forearms, and fists/palms shall remain in contact with the floor throughout the exercise.'
          '\n\nThe plank event is terminated when the Soldier touches the floor with any part of the body except the feet, forearms, or fists, or, raises a foot or hand off the floor, or, fails to maintain the straight-line position from head to heels.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      '2 MILE RUN (2MR)',
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'The two mile run can be completed on an indoor or outdoor track, or an improved surface such as a road or sidewalk. The 2MR cannot be tested on unimproved terrain. The start and finish line will be near the same location as the test site for the other five test events. Out-and-back or lap track courses are authorized.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      '2.5 MILE WALK',
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'The 2.5 Mile Walk measures your level of aerobic fitness. On the command, "GO," the clock will start and you will begin walking at your own pace. '
          'You must complete the 2.5 mile distance. To pass, you must complete 2.5 miles in less than the minimum time for your age group and gender.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      '5000 METER ROW',
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'The 5000 Meter Row measures your level of aerobic fitness. On the command, "GO," the clock will start and you will begin rowing at your own pace. '
          'You must complete the 5000 meter distance. To pass, you must complete 5000m in less than the minimum time for you age group and gender.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      '12000 METER BIKE',
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'The 12000 Meter Bike measures your level of aerobic fitness. On the command, "GO," the clock will start and you will begin pedaling at your own pace. '
          'You must complete the 12000 meter distance in less than the minimum time for your age group and gender.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
  Verbiage(
      false,
      '1000 METER SWIM',
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'The 1000 Meter Swim measures your level of aerobic fitness. You will begin in the water; no diving is allowed. At the start, your body must be in contact '
          'with the wall of the pool. On the command, "GO," the clock will start. You should then begin swimming at your own pace, using any stroke or combination of '
          'strokes you wish. You must swim (state the number of laps) laps to complete this distance. You must touch the wall of the pool at each end of the pool as you '
          'turn. Any type of turn is authorized. You must complete the 1000 meter distance in less than the minimum time for your age group and gender. Walking on the bottom to recuperate '
          'is authorized. Swimming goggles, swim caps and civilian swimming attire are permitted, but no other equipment is authorized.',
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
];

class _AcftVerbiagePageState extends ConsumerState<AcftVerbiagePage> {
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
      bool trackingAllowed = ref.read(trackingProvider).trackingAllowed;
      myBanner = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-2431077176117105/7254941744'
            : 'ca-app-pub-2431077176117105/4532397876',
        size: AdSize.banner,
        listener: BannerAdListener(),
        request: AdRequest(nonPersonalizedAds: !trackingAllowed),
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
      title: 'ACFT Instructions',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: Column(
          children: [
            Expanded(
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
