import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ApftVerbiagePage extends StatefulWidget {
  final bool premium;
  final bool nonPersonalizedAds;
  ApftVerbiagePage({this.premium, this.nonPersonalizedAds});
  @override
  _ApftVerbiagePageState createState() => _ApftVerbiagePageState();
}

class Verbiage {
  Verbiage(this.expanded, this.header, this.body);
  bool expanded;
  final String header;
  final Widget body;
}

class _ApftVerbiagePageState extends State<ApftVerbiagePage> {
  List<Verbiage> _verbiages = <Verbiage>[
    Verbiage(
        false,
        'Intro',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'YOU ARE ABOUT TO TAKE THE ARMY PHYSICAL FITNESS TEST, A TEST THAT WILL MEASURE YOUR UPPER AND LOWER BODY MUSCULAR ENDURANCE. '
            'THE RESULTS OF THIS TEST WILL GIVE YOU AND YOUR COMMANDERS AN INDICATION OF YOUR STATE OF FITNESS AND WILL ACT AS A GUIDE '
            'IN DETERMINING YOUR PHYSICAL TRAINING NEEDS. LISTEN CLOSELY TO THE TEST INSTRUCTIONS, AND DO THE BEST YOU CAN ON EACH OF THE EVENTS.'
            '\n\nIN THE APPROPRIATE SPACES, PRINT IN INK THE PERSONAL INFORMATION REQUIRED ON THE SCORECARD.'
            '\n\nYOU ARE TO CARRY THIS CARD WITH YOU TO EACH EVENT. BEFORE YOU BEGIN, HAND THE CARD TO THE SCORER. AFTER YOU COMPLETE THE '
            'EVENT, THE SCORER WILL RECORD YOUR RAW SCORE, INITIAL THE CARD, AND RETURN IT TO YOU.'
            '\n\nEACH OF YOU WILL BE ASSIGNED TO A GROUP. STAY WITH YOUR TEST GROUP FOR THE ENTIRE TEST. WHAT ARE YOUR QUESTIONS ABOUT THE '
            'TEST AT THIS POINT?',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'PUSH UP',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'THE PUSH-UP EVENT MEASURES THE ENDURANCE OF THE CHEST, SHOULDER, AND TRICEPS MUSCLES. ON THE COMMAND, ‘GET SET’, ASSUME '
            'THE FRONT-LEANING REST POSITION BY PLACING YOUR HANDS WHERE THEY ARE COMFORTABLE FOR YOU. YOUR FEET MAY BE TOGETHER OR '
            'UP TO 12 INCHES APART (MEASURED BETWEEN THE FEET). WHEN VIEWED FROM THE SIDE, YOUR BODY SHOULD FORM A GENERALLY STRAIGHT '
            'LINE FROM YOUR SHOULDERS TO YOUR ANKLES. ON THE COMMAND ‘GO’, BEGIN THE PUSH-UP BY BENDING YOUR ELBOWS AND LOWERING YOUR '
            'ENTIRE BODY AS A SINGLE UNIT UNTIL YOUR UPPER ARMS ARE AT LEAST PARALLEL TO THE GROUND. THEN, RETURN TO THE STARTING '
            'POSITION BY RAISING YOUR ENTIRE BODY UNTIL YOUR ARMS ARE FULLY EXTENDED. YOUR BODY MUST REMAIN RIGID IN A GENERALLY STRAIGHT '
            'LINE AND MOVE AS A UNIT WHILE PERFORMING EACH REPETITION. AT THE END OF EACH REPETITION, THE SCORER WILL STATE THE NUMBER '
            'OF REPETITIONS YOU HAVE COMPLETED CORRECTLY. IF YOU FAIL TO KEEP YOUR BODY GENERALLY STRAIGHT, TO LOWER YOUR WHOLE BODY '
            'UNTIL YOUR UPPER ARMS ARE AT LEAST PARALLEL TO THE GROUND, OR TO EXTEND YOUR ARMS COMPLETELY, THAT REPETITION WILL NOT '
            'COUNT, AND THE SCORER WILL REPEAT THE NUMBER OF THE LAST CORRECTLY PERFORMED REPETITION.'
            '\n\nIF YOU FAIL TO PERFORM THE FIRST 10 PUSH-UPS CORRECTLY, THE SCORER WILL TELL YOU TO GO TO YOUR KNEES AND WILL EXPLAIN '
            'YOUR DEFICIENCIES. YOU WILL THEN BE SENT TO THE END OF THE LINE TO BE RETESTED. AFTER THE FIRST 10 PUSH-UPS HAVE BEEN PERFORMED '
            'AND COUNTED, NO RESTARTS ARE ALLOWED. THE TEST WILL CONTINUE, AND ANY INCORRECTLY PERFORMED PUSH-UPS WILL NOT BE COUNTED. '
            'AN ALTERED, FRONT-LEANING REST POSITION IS THE ONLY AUTHORIZED REST POSITION. THAT IS, YOU MAY SAG IN THE MIDDLE OR FLEX '
            'YOUR BACK. WHEN FLEXING YOUR BACK, YOU MAY BEND YOUR KNEES, BUT NOT TO SUCH AN EXTENT THAT YOU ARE SUPPORTING MOST OF YOUR '
            'BODY WEIGHT WITH YOUR LEGS. IF THIS OCCURS, YOUR PERFORMANCE WILL BE TERMINATED. YOU MUST RETURN TO, AND PAUSE IN, THE CORRECT '
            'STARTING POSITION BEFORE CONTINUING. IF YOU REST ON THE GROUND OR RAISE EITHER HAND OR FOOT FROM THE GROUND, YOUR PERFORMANCE '
            'WILL BE TERMINATED. YOU MAY REPOSITION YOUR HANDS AND/OR FEET DURING THE EVENT AS LONG AS THEY REMAIN IN CONTACT WITH THE '
            'GROUND AT ALL TIMES. CORRECT PERFORMANCE IS IMPORTANT. YOU WILL HAVE TWO MINUTES IN WHICH TO DO AS MANY PUSH-UPS AS YOU CAN. '
            'WATCH THIS DEMONSTRATION.'
            '\n\nWHAT ARE YOUR QUESTIONS ABOUT THIS EVENT?',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        'SIT UP',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'THE SIT-UP EVENT MEASURES THE ENDURANCE OF THE ABDOMINAL AND HIP-FLEXOR MUSCLES. ON THE COMMAND ‘GET SET’, ASSUME THE STARTING '
            'POSITION BY LYING ON YOUR BACK WITH YOUR KNEES BENT AT A 90-DEGREE ANGLE. YOUR FEET MAY BE TOGETHER OR UP TO 12 INCHES APART '
            '(MEASURED BETWEEN THE FEET). ANOTHER PERSON WILL HOLD YOUR ANKLES WITH THE HANDS ONLY. NO OTHER METHOD OF BRACING OR HOLDING '
            'THE FEET IS AUTHORIZED. THE HEEL IS THE ONLY PART OF YOUR FOOT THAT MUST STAY IN CONTACT WITH THE GROUND. YOUR FINGERS MUST BE '
            'INTERLOCKED BEHIND YOUR HEAD AND THE BACKS OF YOUR HANDS MUST TOUCH THE GROUND. YOUR ARMS AND ELBOWS NEED NOT TOUCH THE GROUND. '
            'ON THE COMMAND, \'GO\', BEGIN RAISING YOUR UPPER BODY FORWARD TO, OR BEYOND, THE VERTICAL POSITION. THE VERTICAL POSITION MEANS '
            'THAT THE BASE OF YOUR NECK IS ABOVE THE BASE OF YOUR SPINE. AFTER YOU HAVE REACHED OR SURPASSED THE VERTICAL POSITION, LOWER '
            'YOUR BODY UNTIL THE BOTTOM OF YOUR SHOULDER BLADES TOUCH THE GROUND. YOUR HEAD, HANDS, ARMS OR ELBOWS DO NOT HAVE TO TOUCH THE '
            'GROUND. AT THE END OF EACH REPETITION, THE SCORER WILL STATE THE NUMBER OF SIT-UPS YOU HAVE CORRECTLY PERFORMED. A REPETITION '
            'WILL NOT COUNT IF YOU FAIL TO REACH THE VERTICAL POSITION, FAIL TO KEEP YOUR FINGERS INTERLOCKED BEHIND YOUR HEAD, ARCH OR BOW '
            'YOUR BACK AND RAISE YOUR BUTTOCKS OFF THE GROUND TO RAISE YOUR UPPER BODY, OR LET YOUR KNEES EXCEED A 90-DEGREE ANGLE. IF A '
            'REPETITION DOES NOT COUNT, THE SCORER WILL REPEAT THE NUMBER OF YOUR LAST CORRECTLY PERFORMED SIT-UP. IF YOU FAIL TO PERFORM THE '
            'FIRST 10 SIT-UPS CORRECTLY, THE SCORER WILL TELL YOU TO ‘STOP’ AND WILL EXPLAIN YOUR DEFICIENCIES. YOU WILL THEN BE SENT TO THE '
            'END OF THE LINE TO BE RE-TESTED. AFTER THE FIRST 10 SIT-UPS HAVE BEEN PERFORMED AND COUNTED, NO RESTARTS ARE ALLOWED. THE TEST '
            'WILL CONTINUE, AND ANY INCORRECTLY PERFORMED SIT-UPS WILL NOT BE COUNTED. THE UP POSITION IS THE ONLY AUTHORIZED REST POSITION.'
            '\n\nIF YOU STOP AND REST IN THE DOWN (STARTING) POSITION, THE EVENT WILL BE TERMINATED. AS LONG AS YOU MAKE A CONTINUOUS PHYSICAL EFFORT '
            'TO SIT UP, THE EVENT WILL NOT BE TERMINATED. YOU MAY NOT USE YOUR HANDS OR ANY OTHER MEANS TO PULL OR PUSH YOURSELF UP TO THE UP '
            '(REST) POSITION OR TO HOLD YOURSELF IN THE REST POSITION. IF YOU DO SO, YOUR PERFORMANCE IN THE EVENT WILL BE TERMINATED. CORRECT '
            'PERFORMANCE IS IMPORTANT. YOU WILL HAVE TWO MINUTES TO PERFORM AS MANY SIT-UPS AS YOU CAN. WATCH THIS DEMONSTRATION.'
            '\n\nWHAT ARE YOUR QUESTIONS ABOUT THIS EVENT?',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        '2 MILE RUN',
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'HE 2-MILE RUN MEASURES YOUR AEROBIC FITNESS AND ENDURANCE OF THE LEG MUSCLES. YOU MUST COMPLETE THE RUN WITHOUT ANY PHYSICAL '
            'HELP. AT THE START, ALL SOLDIERS WILL LINE UP BEHIND THE STARTING LINE. ON THE COMMAND ‘GO’, THE CLOCK WILL START. YOU WILL '
            'BEGIN RUNNING AT YOUR OWN PACE. TO RUN THE REQUIRED TWO MILES, YOU MUST COMPLETE THE REQUIRED 2-MILE DISTANCE (DESCRIBE THE '
            'NUMBER OF LAPS, START AND FINISH POINTS, AND COURSE LAYOUT). YOU ARE BEING TESTED ON YOUR ABILITY TO COMPLETE THE TWO-MILE '
            'COURSE IN THE SHORTEST TIME POSSIBLE. ALTHOUGH WALKING IS AUTHORIZED, IT IS STRONGLY DISCOURAGED. IF YOU ARE PHYSICALLY HELPED '
            'IN ANY WAY (FOR EXAMPLE, PULLED, PUSHED, PICKED UP AND/OR CARRIED), OR LEAVE THE DESIGNATED RUNNING COURSE FOR ANY REASON, '
            'THE EVENT WILL BE TERMINATED. IT IS LEGAL TO PACE A SOLDIER DURING THE TWO-MILE RUN AS LONG AS THERE IS NO PHYSICAL CONTACT '
            'WITH THE PACED SOLDIER AND IT DOES NOT PHYSICALLY HINDER OTHER SOLDIERS TAKING THE TEST. THE PRACTICE OF RUNNING AHEAD OF, '
            'ALONG SIDE OF, OR BEHIND THE TESTED SOLDIER WHILE SERVING AS A PACER IS PERMITTED. CHEERING OR CALLING OUT THE ELAPSED TIME '
            'IS ALSO PERMITTED. THE NUMBER ON YOUR CHEST IS FOR IDENTIFICATION. YOU MUST MAKE SURE IT IS VISIBLE AT ALL TIMES. TURN IN '
            'YOUR NUMBER WHEN YOU FINISH THE RUN AND GO TO THE AREA DESIGNATED FOR RECOVERY. DO NOT STAY NEAR THE SCORERS OR THE FINISH LINE '
            'AS THIS MAY INTERFERE WITH TESTING.'
            '\n\nWHAT ARE YOUR QUESTIONS ABOUT THIS EVENT?',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        '2.5 MILE WALK',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'THE 2.5-MILE WALK MEASURES CARDIO RESPIRATORY FITNESS AND LEG-MUSCLE ENDURANCE. ON THE COMMAND, ‘GO,’ THE CLOCK WILL START, AND '
            'YOU WILL BEGIN WALKING AT YOUR OWN PACE. YOU MUST COMPLETE (DESCRIBE THE NUMBER OF LAPS, START AND FINISH POINTS, AND COURSE '
            'LAYOUT). ONE FOOT MUST BE IN CONTACT WITH THE GROUND AT ALL TIMES. IF YOU BREAK INTO A RUNNING STRIDE AT ANY TIME OR HAVE BOTH '
            'FEET OFF THE GROUND AT THE SAME TIME, YOUR PERFORMANCE IN THE EVENT WILL BE TERMINATED. YOU WILL BE SCORED ON YOUR ABILITY TO '
            'COMPLETE THE 2.5-MILE COURSE IN A TIME EQUAL TO OR LESS THAN THAT LISTED FOR YOUR AGE AND GENDER.'
            '\n\nWHAT ARE YOUR QUESTIONS ABOUT THIS EVENT?',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        '6.2 MILE STATIONARY-CYCLE ERGOMETER',
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'THE 6.2-MILE STATIONARY-CYCLE ERGOMETER EVENT MEASURES YOUR CARDIO-RESPIRATORY FITNESS AND LEG MUSCLE ENDURANCE. THE ERGOMETER\'S '
            'RESISTANCE MUST BE SET AT TWO KILOPOUNDS (20 NEWTONS). ON THE COMMAND, \'GO\', THE CLOCK WILL START, AND YOU WILL BEGIN PEDALING '
            'AT YOUR OWN PACE WHILE MAINTAINING THE RESISTANCE INDICATOR AT TWO KILOPOUNDS. YOU WILL BE SCORED ON YOUR ABILITY TO COMPLETE '
            '6.2 MILES (10 KILOMETERS), AS SHOWN ON THE ODOMETER IN A TIME EQUAL TO OR LESS THAN THAT LISTED FOR YOUR AGE AND GENDER.'
            '\n\nWHAT ARE YOUR QUESTIONS ABOUT THIS EVENT?'
            '\n\nTHERE WILL BE FIVE MINUTES OF REST IN BETWEEN THE LTK AND THE 2 MILE RUN',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
    Verbiage(
        false,
        '800-YARD SWIM',
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'THE 800-YARD SWIM MEASURES YOUR LEVEL OF AEROBIC FITNESS. YOU WILL BEGIN IN THE WATER; NO DIVING IS ALLOWED. AT THE START, YOUR '
            'BODY MUST BE IN CONTACT WITH THE WALL OF THE POOL. ON THE COMMAND \‘GO\’, THE CLOCK WILL START. YOU SHOULD THEN BEGIN SWIMMING '
            'AT YOUR OWN PACE, USING ANY STROKE OR COMBINATION OF STROKES YOU WISH. YOU MUST SWIM (STATE THE NUMBER) LAPS TO COMPLETE THIS '
            'DISTANCE. YOU MUST TOUCH THE WALL OF THE POOL AT EACH END OF THE POOL AS YOU TURN. ANY TYPE OF TURN IS AUTHORIZED. YOU WILL BE '
            'SCORED ON YOUR ABILITY TO COMPLETE THE SWIM IN A TIME EQUAL TO, OR LESS THAN, THAT LISTED FOR YOUR AGE AND GENDER. WALKING ON '
            'THE BOTTOM TO RECUPERATE IS AUTHORIZED. SWIMMING GOGGLES ARE PERMITTED, BUT NO OTHER EQUIPMENT IS AUTHORIZED.'
            '\n\nWHAT ARE YOUR QUESTIONS ABOUT THIS EVENT?',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0),
          ),
        )),
  ];

  BannerAd myBanner;

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
            ? 'ca-app-pub-2431077176117105/2976785389'
            : 'ca-app-pub-2431077176117105/8796088273',
        size: AdSize.banner,
        listener: BannerAdListener(),
        request: AdRequest(nonPersonalizedAds: widget.nonPersonalizedAds));

    if (!widget.premium) {
      myBanner.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APFT Instruction'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
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
                            _verbiages[index].expanded =
                                !_verbiages[index].expanded;
                          } else
                            _verbiages[i].expanded = false;
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
                        isExpanded: verbiage.expanded,
                        body: verbiage.body,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (!widget.premium)
              Container(
                constraints: BoxConstraints(maxHeight: 90),
                alignment: Alignment.center,
                child: AdWidget(
                  ad: myBanner,
                ),
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
              )
          ],
        ),
      ),
    );
  }
}
