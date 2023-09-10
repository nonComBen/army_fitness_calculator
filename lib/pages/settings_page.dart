import 'dart:io';

import 'package:acft_calculator/providers/tracking_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../methods/theme_methods.dart';
import '../../providers/premium_state_provider.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../providers/shared_preferences_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/platform_widgets/platform_item_picker.dart';
import '../widgets/platform_widgets/platform_selection_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class SettingsPage extends ConsumerStatefulWidget {
  SettingsPage();

  static const String routeName = 'settingsRoute';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String apftEvent = 'Run', acftEvent = 'Run', brightness = 'Light';
  Object gender = 'Male', rank = 'SGT';
  bool jrSoldier = true;
  late SharedPreferences prefs;
  late BannerAd myBanner;

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();

  final List<String> events = [
    'Run',
    'Walk',
    'Bike',
    'Swim',
  ];

  final List<String> acftEvents = [
    'Run',
    'Walk',
    'Bike',
    'Row',
    'Swim',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    myBanner.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    prefs = ref.read(sharedPreferencesProvider);
    bool trackingAllowed = ref.read(trackingProvider).trackingAllowed;

    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/4098295367'
          : 'ca-app-pub-2431077176117105/9976296241',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest(nonPersonalizedAds: !trackingAllowed),
    );

    if (prefs.getString('acft_event') != null) {
      acftEvent = prefs.getString('acft_event')!;
    }
    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender')!;
    }
    if (prefs.getInt('age') != null) {
      _ageController.text = prefs.getInt('age').toString();
    } else {
      _ageController.text = '17';
    }
    if (prefs.getString('apft_event') != null) {
      apftEvent = prefs.getString('apft_event')!;
    }
    if (prefs.getBool('jr_soldier') != null) {
      jrSoldier = prefs.getBool('jr_soldier')!;
    }
    if (prefs.getInt('height') != null) {
      _heightController.text = prefs.getInt('height').toString();
    } else {
      _heightController.text = '68';
    }
    if (prefs.getString('brightness') != null) {
      brightness = prefs.getString('brightness')!;
    }
    if (prefs.getString('rank') != null) {
      rank = prefs.getString('rank')!;
    }
  }

  List<Widget> brightnessRadios(bool horizontal, double width,
      ThemeData themeState, ThemeStateNotifier notifier) {
    return [
      SizedBox(
        width: horizontal ? 250 : width - 32,
        child: RadioListTile(
          title: const Text('Light Theme'),
          activeColor: getOnPrimaryColor(context),
          value: Brightness.light,
          groupValue: themeState.brightness,
          onChanged: (Brightness? value) {
            notifier.switchTheme(ThemeState.lightTheme);
          },
        ),
      ),
      SizedBox(
        width: horizontal ? 250 : width - 32,
        child: RadioListTile(
          title: const Text('Dark Theme'),
          activeColor: getOnPrimaryColor(context),
          value: Brightness.dark,
          groupValue: themeState.brightness,
          onChanged: (Brightness? value) {
            notifier.switchTheme(ThemeState.darkTheme);
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isPremium =
        ref.read(premiumStateProvider) || (prefs.getBool('isPremium') ?? false);
    if (!isPremium) {
      myBanner.load();
    }
    double width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'Settings',
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
                  Consumer(
                    builder: ((context, ref, child) {
                      final themeState = ref.read(themeStateNotifierProvider);
                      final notifier =
                          ref.read(themeStateNotifierProvider.notifier);
                      return PlatformSelectionWidget(
                        titles: [Text('Light'), Text('Dark')],
                        values: [Brightness.light, Brightness.dark],
                        groupValue: themeState.brightness,
                        onChanged: (value) {
                          if (value == Brightness.dark) {
                            notifier.switchTheme(ThemeState.darkTheme);
                          } else {
                            notifier.switchTheme(ThemeState.lightTheme);
                          }
                        },
                      );
                    }),
                  ),
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
                      PlatformItemPicker(
                        label: Text(
                          'Default ACFT Aerobic Event',
                          style: TextStyle(
                              color: getTextColor(
                            context,
                          )),
                        ),
                        value: acftEvent,
                        items: acftEvents,
                        onChanged: (value) {
                          setState(() {
                            acftEvent = value!;
                            prefs.setString('acft_event', value);
                          });
                        },
                      ),
                      PlatformSelectionWidget(
                          titles: [Text('M'), Text('F')],
                          values: ['Male', 'Female'],
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                              prefs.setString('gender', value.toString());
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: PlatformTextField(
                          controller: _ageController,
                          label: 'Default Age',
                          keyboardType: TextInputType.numberWithOptions(),
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(labelText: 'Default Age'),
                          onChanged: (value) {
                            prefs.setInt('age', int.tryParse(value) ?? 17);
                          },
                        ),
                      ),
                      PlatformItemPicker(
                        label: Text(
                          'Default APFT Aerobic Event',
                          style: TextStyle(
                            color: getTextColor(context),
                          ),
                        ),
                        value: apftEvent,
                        items: events,
                        onChanged: (value) {
                          setState(() {
                            apftEvent = value!;
                            prefs.setString('apft_event', value);
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: PlatformCheckboxListTile(
                          value: jrSoldier,
                          title: const Text('For Promotion Points'),
                          subtitle: Text(jrSoldier ? 'True' : 'False'),
                          activeColor: getOnPrimaryColor(context),
                          onChanged: (value) {
                            setState(() {
                              jrSoldier = value!;
                              prefs.setBool('jr_soldier', value);
                            });
                          },
                          onIosTap: () {
                            setState(() {
                              jrSoldier = !jrSoldier;
                              prefs.setBool('jr_soldier', jrSoldier);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PlatformTextField(
                          controller: _heightController,
                          label: 'Default Height',
                          keyboardType: TextInputType.numberWithOptions(),
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              labelText: 'Default Height'),
                          onChanged: (value) {
                            prefs.setInt('height', int.tryParse(value) ?? 68);
                          },
                        ),
                      ),
                      PlatformSelectionWidget(
                          titles: [Text('SGT'), Text('SSG')],
                          values: ['SGT', 'SSG'],
                          groupValue: rank,
                          onChanged: (value) {
                            setState(() {
                              rank = value!;
                              prefs.setString('rank', value.toString());
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
            if (!isPremium)
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
