import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/formatted_drop_down.dart';
import '../widgets/formatted_radio.dart';
import 'package:flutter/material.dart';

class SettingsPage extends ConsumerStatefulWidget {
  SettingsPage({this.isPremium});
  final bool isPremium;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String apftEvent = 'Run',
      acftEvent = 'Run',
      gender = 'Male',
      brightness = 'Light',
      rank = 'SGT';
  bool jrSoldier = true;
  SharedPreferences prefs;

  TextEditingController _ageController;
  TextEditingController _heightController;

  List<String> events = [
    'Run',
    'Walk',
    'Bike',
    'Swim',
  ];

  List<String> acftEvents = [
    'Run',
    'Walk',
    'Bike',
    'Row',
    'Swim',
  ];

  List<Widget> brightnessRadios(bool horizontal, double width,
      ThemeData themeState, ThemeStateNotifier notifier) {
    return [
      SizedBox(
        width: horizontal ? 250 : width - 32,
        child: RadioListTile(
          title: const Text('Light Theme'),
          activeColor: Theme.of(context).colorScheme.onSecondary,
          value: Brightness.light,
          groupValue: themeState.brightness,
          onChanged: (Brightness value) {
            notifier.switchTheme(ThemeState.lightTheme);
          },
        ),
      ),
      SizedBox(
        width: horizontal ? 250 : width - 32,
        child: RadioListTile(
          title: const Text('Dark Theme'),
          activeColor: Theme.of(context).colorScheme.onSecondary,
          value: Brightness.dark,
          groupValue: themeState.brightness,
          onChanged: (Brightness value) {
            notifier.switchTheme(ThemeState.darkTheme);
          },
        ),
      ),
    ];
  }

  BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/4098295367'
          : 'ca-app-pub-2431077176117105/9976296241',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest());

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _heightController = TextEditingController();

    if (!widget.isPremium) {
      myBanner.load();
    }

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('acft_event') != null) {
      acftEvent = prefs.getString('acft_event');
    }
    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender');
    }
    if (prefs.getInt('age') != null) {
      _ageController.text = prefs.getInt('age').toString();
    } else {
      _ageController.text = '17';
    }
    if (prefs.getString('apft_event') != null) {
      apftEvent = prefs.getString('apft_event');
    }
    if (prefs.getBool('jr_soldier') != null) {
      jrSoldier = prefs.getBool('jr_soldier');
    }
    if (prefs.getInt('height') != null) {
      _heightController.text = prefs.getInt('height').toString();
    } else {
      _heightController.text = '68';
    }
    if (prefs.getString('brightness') != null) {
      brightness = prefs.getString('brightness');
    }
    if (prefs.getString('rank') != null) {
      rank = prefs.getString('rank');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Display Settings',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer(builder: ((context, ref, child) {
                    final themeState = ref.watch(themeStateNotifierProvider);
                    final notifier =
                        ref.read(themeStateNotifierProvider.notifier);
                    if (width > 500) {
                      return new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            brightnessRadios(true, width, themeState, notifier),
                      );
                    } else {
                      return new Column(
                        children: brightnessRadios(
                            false, width, themeState, notifier),
                      );
                    }
                  })),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Default Settings',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 230 : width / 115,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      FormattedDropDown(
                          label: 'Default ACFT Aerobic Event',
                          value: acftEvent,
                          items: acftEvents,
                          onChanged: (value) {
                            setState(() {
                              acftEvent = value;
                              prefs.setString('acft_event', value);
                            });
                          }),
                      FormattedRadio(
                          titles: ['M', 'F'],
                          values: ['Male', 'Female'],
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                              prefs.setString('gender', value);
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.numberWithOptions(),
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(labelText: 'Default Age'),
                          onChanged: (value) {
                            prefs.setInt('age', int.tryParse(value) ?? 17);
                          },
                        ),
                      ),
                      FormattedDropDown(
                          label: 'Default APFT Aerobic Event',
                          value: apftEvent,
                          items: events,
                          onChanged: (value) {
                            setState(() {
                              apftEvent = value;
                              prefs.setString('apft_event', value);
                            });
                          }),
                      SwitchListTile(
                        value: jrSoldier,
                        title: const Text('For Promotion Points'),
                        subtitle: Text(jrSoldier ? 'True' : 'False'),
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        onChanged: (value) {
                          setState(() {
                            jrSoldier = value;

                            prefs.setBool('jr_soldier', value);
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.numberWithOptions(),
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              labelText: 'Default Height'),
                          onChanged: (value) {
                            prefs.setInt('height', int.tryParse(value) ?? 68);
                          },
                        ),
                      ),
                      FormattedRadio(
                          titles: ['SGT', 'SSG'],
                          values: ['SGT', 'SSG'],
                          groupValue: rank,
                          onChanged: (value) {
                            setState(() {
                              rank = value;
                              prefs.setString('rank', value);
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            if (!widget.isPremium)
              Container(
                constraints: const BoxConstraints(maxHeight: 90),
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
