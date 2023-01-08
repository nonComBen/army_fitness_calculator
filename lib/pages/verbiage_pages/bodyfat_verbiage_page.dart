import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BodyfatVerbiagePage extends StatefulWidget {
  final bool? isPremium;
  final bool? nonPersonalizedAds;
  BodyfatVerbiagePage({this.isPremium, this.nonPersonalizedAds});
  @override
  _BodyfatVerbiagePageState createState() => _BodyfatVerbiagePageState();
}

class Verbiage {
  Verbiage(this.isExpanded, this.header, this.body);
  bool isExpanded;
  final String header;
  final Widget body;
}

class _BodyfatVerbiagePageState extends State<BodyfatVerbiagePage> {
  List<Verbiage> _verbiages = <Verbiage>[
    Verbiage(
        false,
        'Soldier\'s Height',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'The height will be measured with the Soldier in stocking feet (without running shoes) and wearing the '
            'authorized physical fitness uniform (trunks and T-shirt). The Soldier will stand on a flat surface with the head held '
            'horizontal, looking directly forward with the line of vision horizontal and the chin parallel to the floor. The body will '
            'be straight but not rigid, similar to the position of attention. When measuring height to determine body fat percentage, '
            'the Soldier’s height is measured to the nearest half inch. When measuring height to use the '
            'weight for height screening table the Soldier’s height is measured and then rounded to the nearest inch '
            'with the following guidelines: '
            '\n\n(1) If the height fraction is less than half an inch, round down to the nearest whole number in inches. '
            '\n\n(2) If the height fraction is half an inch or greater, round up to the next highest whole number in inches.',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'Soldier\'s Weight',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'The weight will be measured with the Soldier in stocking feet and wearing the authorized physical fitness uniform '
            '(trunks and T-shirt); running shoes and jacket will not be worn. Scales used for weight measurement will be calibrated '
            'annually for accuracy. The measurement will be made on scales available in units and recorded to the nearest pound with '
            'the following guidelines:'
            '\n\n (1) If the weight fraction of the Soldier is less than one-half pound, round down to the nearest pound.'
            '\n\n (2) If the weight fraction of the Soldier is one half-pound or greater, round up to the next whole pound.'
            '\n\n (3) No weight will be deducted to account for clothing.',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'Neck',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Measure the neck circumference at a point just below the larynx (Adam’s apple) and perpendicular to the long axis of the neck. '
            'Do not place the tape measure over the Adam’s apple. Soldier will look straight ahead during measurement, with shoulders '
            'down (not hunched). The tape will be as close to horizontal as anatomically feasible (the tape line in the front of the neck '
            'will be at the same height as the tape line in the back of the neck). Care will be taken to ensure the shoulder/neck muscles '
            '(trapezius) are not involved in the measurement. Round neck measurement up to the nearest half inch and record (for example, '
            'round “16 1/4 inches” to “16 1/2 inches”).',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'Waist (Males)',
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Measure abdominal circumference against the skin at the navel (belly button) level and parallel to the floor. Arms are at the sides. '
            'Record the measurement at the end of Soldier’s normal, relaxed exhalation. Round abdominal measurement down to the nearest half '
            'inch and record (for example, round “34 3/4 inches” to “34 1/2 inches”).',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'Waist (Females)',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Measure the natural waist circumference, against the skin, at the point of minimal abdominal circumference. The waist circumference is '
            'taken at the narrowest point of the abdomen, usually about halfway between the navel and the end of the sternum (breastbone). When '
            'this site is not easily observed, take several measurements at probable sites and record the smallest value. The Soldier’s arms must '
            'be at the sides. Take measurements at the end of Soldier’s normal relaxed exhalation. Tape measurements of the waist will be made '
            'directly against the skin. Round the natural waist measurement down to the nearest half inch and record (for example, round “28 5/8 '
            'inches” to “28 1/2 inches”).',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'Hip',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'The Soldier taking the measurement will view the person being measured from the side. Place the tape around the hips so that it passes '
            'over the greatest protrusion of the gluteal muscles (buttocks), keeping the tape in a horizontal plane (parallel to the floor). '
            'Check front to back and side to side to be sure the tape is level to the floor on all sides before the measurements are recorded. '
            'Because the Soldier will be wearing authorized physical fitness uniform trunks, the tape can be drawn snugly without compressing '
            'the underlying soft tissue to minimize the influence of the shorts on the size of the measurement. Round the hip measurement down '
            'to the nearest half inch and record (for example, round “44 3/8 inches” to “44 inches”).',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
  ];

  BannerAd? myBanner;

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    myBanner = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-2431077176117105/8037540374'
            : 'ca-app-pub-2431077176117105/3410887896',
        size: AdSize.banner,
        listener: BannerAdListener(),
        request: AdRequest(nonPersonalizedAds: widget.nonPersonalizedAds));

    if (!widget.isPremium!) {
      myBanner!.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Comp Instructions'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        for (int i = 0; i < _verbiages.length; i++) {
                          if (i == index) {
                            _verbiages[index].isExpanded =
                                !_verbiages[index].isExpanded;
                          } else
                            _verbiages[i].isExpanded = false;
                        }
                      });
                    },
                    children: _verbiages.map((Verbiage verbiage) {
                      return new ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return new ListTile(
                            title: new Text(
                              verbiage.header,
                              textAlign: TextAlign.start,
                              style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                        isExpanded: verbiage.isExpanded,
                        body: verbiage.body,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (!widget.isPremium!)
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
