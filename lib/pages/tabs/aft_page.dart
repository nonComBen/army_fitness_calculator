import 'package:acft_calculator/methods/is_valid_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../calculators/aft_calculator.dart';
import '../../calculators/aft_hrp_calculator.dart';
import '../../calculators/aft_mdl_calculator.dart';
import '../../calculators/aft_plk_calculator.dart';
import '../../calculators/aft_run_calculator.dart';
import '../../calculators/aft_sdc_calculator.dart';
import '../../methods/acft_age_group.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../methods/theme_methods.dart';
import '../../providers/purchases_provider.dart';
import '../../sqlite/aft.dart';
import '../../widgets/button_text.dart';
import '../../widgets/header_text.dart';
import '../../widgets/min_max_table.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../sqlite/db_helper.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_slider.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../../widgets/platform_widgets/platform_item_picker.dart';
import '../../widgets/platform_widgets/platform_selection_widget.dart';
import '../../widgets/grid_box.dart';
import '../../widgets/increment_decrement_button.dart';
import '../../constants/pt_age_group_table.dart';
import '../../constants/acft_aerobic_event_table.dart';
import '../../widgets/value_input_field.dart';
import '../saved_pages/saved_afts_page.dart';

class AftPage extends ConsumerStatefulWidget {
  AftPage();

  static const String title = 'AFT Calculator';

  @override
  AftPageState createState() => AftPageState();
}

class AftPageState extends ConsumerState<AftPage> with WidgetsBindingObserver {
  static int age = 22;
  int mdlRaw = 300,
      hrpRaw = 50,
      sdcMins = 1,
      sdcSecs = 50,
      plankMins = 3,
      plankSecs = 48,
      runMins = 15,
      runSecs = 0;
  int? mdlScore, hrpScore, sdcScore, plankScore, runScore, total;
  bool isAgeValid = true,
      isMdlValid = true,
      isHrpValid = true,
      isSdcMinsValid = true,
      isSdcSecsValid = true,
      isPlankMinsValid = true,
      isPlankSecsValid = true,
      isRunMinsValid = true,
      isRunSecsValid = true,
      hasMdlProfile = false,
      hasSptProfile = false,
      hasHrpProfile = false,
      hasSdcProfile = false,
      hasPlkProfile = false;
  static String gender = 'Male';
  String aerobicEvent = 'Run';
  List<String> tableHeaders = ['Min', '80%', 'Max'];
  late SharedPreferences prefs;
  final headerStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  final _ageController = TextEditingController();
  final _mdlController = TextEditingController();
  final _hrpController = TextEditingController();
  final _sdcMinsController = TextEditingController();
  final _sdcSecsController = TextEditingController();
  final _plankMinsController = TextEditingController();
  final _plankSecsController = TextEditingController();
  final _runMinsController = TextEditingController();
  final _runSecsController = TextEditingController();

  final _ageFocus = FocusNode();
  final _mdlFocus = FocusNode();
  final _hrpFocus = FocusNode();
  final _sdcMinsFocus = FocusNode();
  final _sdcSecsFocus = FocusNode();
  final _plkMinsFocus = FocusNode();
  final _plkSecsFocus = FocusNode();
  final _runMinsFocus = FocusNode();
  final _runSecsFocus = FocusNode();

  late PurchasesService purchasesService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    prefs = ref.read(sharedPreferencesProvider);

    // myBanner = BannerAd(
    //   adUnitId: Platform.isAndroid
    //       ? 'ca-app-pub-2431077176117105/8950325543'
    //       : 'ca-app-pub-2431077176117105/4488336359',
    //   size: AdSize.banner,
    //   listener: BannerAdListener(),
    //   request: AdRequest(nonPersonalizedAds: true),
    // );

    // myBanner.load();

    mdlRaw = prefs.getInt('mdlRaw') ?? 300;
    hrpRaw = prefs.getInt('hrpRaw') ?? 50;
    sdcMins = prefs.getInt('sdcMins') ?? 1;
    sdcSecs = prefs.getInt('sdcSecs') ?? 50;
    plankMins = prefs.getInt('plkMins') ?? 3;
    plankSecs = prefs.getInt('plkSecs') ?? 48;
    runMins = prefs.getInt('runMins') ?? 15;
    runSecs = prefs.getInt('runSecs') ?? 0;

    _mdlController.text = mdlRaw.toString();
    _hrpController.text = hrpRaw.toString();
    _sdcMinsController.text = sdcMins.toString();
    _sdcSecsController.text = sdcSecs.toString();
    _plankMinsController.text = plankMins.toString();
    _plankSecsController.text = plankSecs.toString();
    _runMinsController.text = runMins.toString();
    _runSecsController.text = runSecs.toString();

    _ageFocus.addListener(() {
      if (_ageFocus.hasFocus) {
        _ageController.selection = TextSelection(
            baseOffset: 0, extentOffset: _ageController.text.length);
      }
    });
    _mdlFocus.addListener(() {
      if (_mdlFocus.hasFocus) {
        _mdlController.selection = TextSelection(
            baseOffset: 0, extentOffset: _mdlController.text.length);
      }
    });
    _hrpFocus.addListener(() {
      if (_hrpFocus.hasFocus) {
        _hrpController.selection = TextSelection(
            baseOffset: 0, extentOffset: _hrpController.text.length);
      }
    });
    _sdcMinsFocus.addListener(() {
      if (_sdcMinsFocus.hasFocus) {
        _sdcMinsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _sdcMinsController.text.length);
      }
    });
    _sdcSecsFocus.addListener(() {
      if (_sdcSecsFocus.hasFocus) {
        _sdcSecsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _sdcSecsController.text.length);
      }
    });
    _plkMinsFocus.addListener(() {
      if (_plkMinsFocus.hasFocus) {
        _plankMinsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _plankMinsController.text.length);
      }
    });
    _plkSecsFocus.addListener(() {
      if (_plkSecsFocus.hasFocus) {
        _plankSecsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _plankSecsController.text.length);
      }
    });
    _runMinsFocus.addListener(() {
      if (_runMinsFocus.hasFocus) {
        _runMinsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _runMinsController.text.length);
      }
    });
    _runSecsFocus.addListener(() {
      if (_runSecsFocus.hasFocus) {
        _runSecsController.selection = TextSelection(
            baseOffset: 0, extentOffset: (_runSecsController).text.length);
      }
    });

    if (prefs.getString('acft_event') != null) {
      aerobicEvent = prefs.getString('acft_event')!;
    }
    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender')!;
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age')!;
    }

    _ageController.text = age.toString();

    calcAll();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      prefs.setInt('mdlRaw', mdlRaw);
      prefs.setInt('hrpRaw', hrpRaw);
      prefs.setInt('sdcMins', sdcMins);
      prefs.setInt('sdcSecs', sdcSecs);
      prefs.setInt('plkMins', plankMins);
      prefs.setInt('plkSecs', plankSecs);
      prefs.setInt('runMins', runMins);
      prefs.setInt('runSecs', runSecs);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);

    _ageController.dispose();
    _mdlController.dispose();
    _hrpController.dispose();
    _sdcMinsController.dispose();
    _sdcSecsController.dispose();
    _plankMinsController.dispose();
    _plankSecsController.dispose();
    _runMinsController.dispose();
    _runSecsController.dispose();

    _ageFocus.dispose();
    _mdlFocus.dispose();
    _hrpFocus.dispose();
    _sdcMinsFocus.dispose();
    _sdcSecsFocus.dispose();
    _plkMinsFocus.dispose();
    _plkSecsFocus.dispose();
    _runMinsFocus.dispose();
    _runSecsFocus.dispose();
  }

  void calcAll() {
    mdlScore = getAftMdlScore(
        weight: mdlRaw,
        ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
        male: gender == 'Male');
    hrpScore = getAftHrpScore(
        pushups: hrpRaw,
        ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
        male: gender == 'Male');
    sdcScore = getAftSdcScore(
        time: getTimeAsInt(sdcMins, sdcSecs),
        ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
        male: gender == 'Male');
    plankScore = getAftPlkScore(
        time: getTimeAsInt(plankMins, plankSecs),
        ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
        male: gender == 'Male');
    calcRunScore();
    calcTotal();
  }

  List<String> getAerobicBenchmarks() {
    final altBenchmarks = getAltBenchmarks(
      ptAgeGroups.indexOf(getAgeGroup(age)),
      gender == "Male",
    );
    switch (aerobicEvent) {
      case "Run":
        return getAft2mrBenchmarks(
          ptAgeGroups.indexOf(getAgeGroup(age)),
          gender == "Male",
        );
      case "Walk":
        return [
          altBenchmarks[0],
          '-',
          '-',
        ];
      case "Bike":
        return [
          altBenchmarks[1],
          '-',
          '-',
        ];
      case "Swim":
        return [
          altBenchmarks[2],
          '-',
          '-',
        ];
      case "Row":
        return [
          altBenchmarks[2],
          '-',
          '-',
        ];
      default:
        return getAft2mrBenchmarks(
          ptAgeGroups.indexOf(getAgeGroup(age)),
          gender == "Male",
        );
    }
  }

  int getTimeAsInt(int? mins, int? secs) {
    String secString =
        secs.toString().length == 2 ? secs.toString() : '0' + secs.toString();
    return int.tryParse(mins.toString() + secString) ?? 0;
  }

  void calcRunScore() {
    int time = getTimeAsInt(runMins, runSecs);
    if (aerobicEvent == 'Run') {
      runScore = getAft2mrScore(
        time: time,
        ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
        male: gender == 'Male',
      );
    } else {
      final runMinimum = getAerobicBenchmarks()[0];
      int min = int.tryParse(runMinimum.replaceRange(2, 3, "")) ?? 0;
      if (time <= min) {
        runScore = 60;
      } else {
        runScore = 0;
      }
    }
  }

  void calcTotal() {
    setState(() {
      total = mdlScore! + hrpScore! + sdcScore! + plankScore! + runScore!;
    });
  }

  bool didPassMdl() {
    return mdlScore! >= 60 || hasMdlProfile;
  }

  bool didPassHrp() {
    return hrpScore! >= 60 || hasHrpProfile;
  }

  bool didPassSdc() {
    return sdcScore! >= 60 || hasSdcProfile;
  }

  bool didPassPlk() {
    return plankScore! >= 60 || hasPlkProfile;
  }

  bool didPassAerobic() {
    return runScore! >= 60;
  }

  bool didPassAcft() {
    return didPassMdl() &&
        didPassHrp() &&
        didPassSdc() &&
        didPassPlk() &&
        didPassAerobic();
  }

  _saveAft(BuildContext context, Aft aft) {
    DBHelper dbHelper = DBHelper();
    final f = DateFormat('yyyyMMdd');
    final date = f.format(DateTime.now());
    final _dateController = TextEditingController(text: date);
    final _rankController = TextEditingController();
    final _nameController = TextEditingController();
    showPlatformModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        color: getBackgroundColor(context),
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom == 0
                ? MediaQuery.of(ctx).padding.bottom
                : MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformTextField(
                  controller: _dateController,
                  label: 'Date',
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      isValidDate(value!) ? null : 'Use yyyyMMdd Format',
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(ctx).nextFocus(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformTextField(
                  controller: _rankController,
                  label: 'Rank',
                  decoration: const InputDecoration(labelText: 'Rank'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(ctx).nextFocus(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformTextField(
                  controller: _nameController,
                  label: 'Name',
                  decoration: const InputDecoration(labelText: 'Name'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => FocusScope.of(ctx).unfocus(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: PlatformButton(
                  child: ButtonText(text: 'Save'),
                  onPressed: (() {
                    aft.date = _dateController.text;
                    aft.rank = _rankController.text;
                    aft.name = _nameController.text;
                    dbHelper.saveAft(aft);
                    Navigator.of(ctx).pop();
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(SavedAftsPage.routeName);
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      print(
          'AFT Page Build - Is New Login: ${prefs.getBool('isNewLogin') ?? true}');
      if (prefs.getBool('isNewLogin') ?? true) {
        print('New Login Detected');
        prefs.setBool('isNewLogin', false);
        showPlatformModalBottomSheet(
          context: context,
          builder: (context) => Container(
            constraints: BoxConstraints(maxHeight: 300),
            color: getBackgroundColor(context),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: HeaderText(
                          text: 'Army Fitness Calculator is Now Free!')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'All features are now available to all users and ads have been removed. If you '
                    'recently purchased the Premium Upgrade, you can request a refund through your '
                    'app store. If you have any questions, please email me at armynoncomtools@gmail.com',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    final backgroundColor = getBackgroundColor(context);
    final primaryColor = getPrimaryColor(context);
    final failColor = Theme.of(context).colorScheme.error;
    final onPrimary = getOnPrimaryColor(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformSelectionWidget(
                      titles: [Text('M'), Text('F')],
                      values: ['Male', 'Female'],
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          gender = value!.toString();
                          calcAll();
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Age',
                      style: headerStyle,
                    ),
                    ValueInputField(
                      controller: _ageController,
                      focusNode: _ageFocus,
                      onEditingComplete: () => _mdlFocus.requestFocus(),
                      errorText: isAgeValid ? null : '17-80',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? 0;
                        if (raw > 80) {
                          isAgeValid = false;
                          age = 80;
                        } else if (raw < 17) {
                          isAgeValid = false;
                          age = 17;
                        } else {
                          age = raw;
                          isAgeValid = true;
                        }
                        calcAll();
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (age > 17) {
                            age--;
                          } else {
                            age = 17;
                          }
                          isAgeValid = true;
                          _ageController.text = age.toString();
                          calcAll();
                        },
                      ),
                      Expanded(
                        child: PlatformSlider(
                          activeColor: primaryColor,
                          value: age.toDouble(),
                          min: 17,
                          max: 80,
                          divisions: 64,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            isAgeValid = true;
                            age = value.floor();
                            _ageController.text = age.toString();
                            calcAll();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (age < 80) {
                            age++;
                          } else {
                            age = 80;
                          }
                          isAgeValid = true;
                          _ageController.text = age.toString();
                          calcAll();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'MDL',
                      style: headerStyle,
                    ),
                    ValueInputField(
                      width: 60,
                      controller: _mdlController,
                      focusNode: _mdlFocus,
                      onEditingComplete: () => _hrpFocus.requestFocus(),
                      errorText: isMdlValid ? null : '0-400',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? 0;
                        if (raw > 400) {
                          hasMdlProfile = false;
                          isMdlValid = false;
                          mdlRaw = 400;
                        } else if (raw < 0) {
                          isMdlValid = false;
                          mdlRaw = 0;
                        } else {
                          hasMdlProfile = false;
                          mdlRaw = raw;
                          isMdlValid = true;
                        }
                        mdlScore = getAftMdlScore(
                            weight: mdlRaw,
                            ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                            male: gender == 'Male');
                        calcTotal();
                      },
                    ),
                    GridBox(
                      title: mdlScore.toString(),
                      background: didPassMdl() ? backgroundColor : failColor,
                      textColor:
                          didPassMdl() ? getTextColor(context) : Colors.white,
                      width: 60,
                      height: 40,
                      borderBottomLeft: 8,
                      borderBottomRight: 8,
                      borderTopLeft: 8,
                      borderTopRight: 8,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (mdlRaw > 0) {
                            mdlRaw = mdlRaw - 10;
                            calcTotal();
                          } else {
                            mdlRaw = 0;
                          }
                          _mdlController.text = mdlRaw.toString();
                          isMdlValid = true;
                          mdlScore = getAftMdlScore(
                              weight: mdlRaw,
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: primaryColor,
                          value: mdlRaw.toDouble(),
                          min: 0,
                          max: 400,
                          divisions: 40,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasMdlProfile) {
                              mdlRaw = 0;
                            } else {
                              mdlRaw = (value / 10).round() * 10;
                            }
                            _mdlController.text = mdlRaw.toString();
                            isMdlValid = true;
                            mdlScore = getAftMdlScore(
                                weight: mdlRaw,
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasMdlProfile) {
                            mdlRaw = 0;
                          } else {
                            if (mdlRaw < 400) {
                              mdlRaw = mdlRaw + 10;
                            } else {
                              mdlRaw = 400;
                            }
                          }
                          _mdlController.text = mdlRaw.toString();
                          mdlScore = getAftMdlScore(
                              weight: mdlRaw,
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          isMdlValid = true;
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformCheckboxListTile(
                    title: const Text('Profile'),
                    value: hasMdlProfile,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: onPrimary,
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasMdlProfile = value!;
                        if (value) {
                          mdlRaw = 0;
                          _mdlController.text = mdlRaw.toString();
                        }
                        mdlScore = 0;
                        isMdlValid = true;
                        calcTotal();
                      });
                    },
                    onIosTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasMdlProfile = !hasMdlProfile;
                        if (hasMdlProfile) {
                          mdlRaw = 0;
                          _mdlController.text = mdlRaw.toString();
                        }
                        mdlScore = 0;
                        isMdlValid = true;
                        calcTotal();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: tableHeaders,
                    values: getAftMdlBenchmarks(
                      ptAgeGroups.indexOf(getAgeGroup(age)),
                      gender == "Male",
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'HRP',
                      style: headerStyle,
                    ),
                    ValueInputField(
                      controller: _hrpController,
                      focusNode: _hrpFocus,
                      onEditingComplete: () => _sdcMinsFocus.requestFocus(),
                      errorText: isHrpValid ? null : '0-80',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? -1;
                        if (raw > 80) {
                          hasHrpProfile = false;
                          isHrpValid = false;
                          hrpRaw = 80;
                        } else if (raw < 0) {
                          isHrpValid = false;
                          hrpRaw = 0;
                        } else {
                          hasHrpProfile = false;
                          hrpRaw = raw;
                          isHrpValid = true;
                        }
                        hrpScore = getAftHrpScore(
                            pushups: hrpRaw,
                            ageGroup: ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                            male: gender == 'Male');
                        calcTotal();
                      },
                    ),
                    GridBox(
                      title: hrpScore.toString(),
                      background: didPassHrp() ? backgroundColor : failColor,
                      textColor:
                          didPassHrp() ? getTextColor(context) : Colors.white,
                      width: 60,
                      height: 40,
                      borderBottomLeft: 8,
                      borderBottomRight: 8,
                      borderTopLeft: 8,
                      borderTopRight: 8,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hrpRaw > 0) {
                            hrpRaw--;
                          } else {
                            hrpRaw = 0;
                          }
                          _hrpController.text = hrpRaw.toString();
                          isHrpValid = true;
                          hrpScore = getAftHrpScore(
                              pushups: hrpRaw,
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: hrpRaw.toDouble(),
                          min: 0,
                          max: 80,
                          divisions: 81,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasHrpProfile) {
                              hrpRaw = 0;
                            } else {
                              hrpRaw = value.floor();
                            }
                            _hrpController.text = hrpRaw.toString();
                            isHrpValid = true;
                            hrpScore = getAftHrpScore(
                                pushups: hrpRaw,
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasHrpProfile) {
                            hrpRaw = 0;
                          } else {
                            if (hrpRaw < 80) {
                              hrpRaw++;
                            } else {
                              hrpRaw = 80;
                            }
                          }
                          _hrpController.text = hrpRaw.toString();
                          isHrpValid = true;
                          hrpScore = getAftHrpScore(
                              pushups: hrpRaw,
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformCheckboxListTile(
                    title: const Text('Profile'),
                    value: hasHrpProfile,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: onPrimary,
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasHrpProfile = value!;
                        if (value) {
                          hrpRaw = 0;
                          _hrpController.text = hrpRaw.toString();
                        }
                        hrpScore = 0;
                        isHrpValid = true;
                        calcTotal();
                      });
                    },
                    onIosTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasHrpProfile = !hasHrpProfile;
                        if (hasHrpProfile) {
                          hrpRaw = 0;
                          _hrpController.text = hrpRaw.toString();
                        }
                        hrpScore = 0;
                        isHrpValid = true;
                        calcTotal();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: tableHeaders,
                    values: getAftHrpBenchmarks(
                      ptAgeGroups.indexOf(getAgeGroup(age)),
                      gender == "Male",
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'SDC',
                      style: headerStyle,
                    ),
                    Row(
                      children: <Widget>[
                        ValueInputField(
                          controller: _sdcMinsController,
                          focusNode: _sdcMinsFocus,
                          width: 40,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          errorText: isSdcMinsValid ? null : '0-5',
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? -1;
                            if (raw < 0) {
                              isSdcMinsValid = false;
                              sdcMins = 0;
                            } else if (raw > 5) {
                              hasSdcProfile = false;
                              isSdcMinsValid = false;
                              sdcMins = 5;
                            } else {
                              hasSdcProfile = false;
                              isSdcMinsValid = true;
                              sdcMins = raw;
                            }
                            sdcScore = getAftSdcScore(
                                time: getTimeAsInt(sdcMins, sdcSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                          child: Text(
                            ':',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ValueInputField(
                          controller: _sdcSecsController,
                          focusNode: _sdcSecsFocus,
                          onEditingComplete: () => _plkMinsFocus.requestFocus(),
                          errorText: isSdcSecsValid ? null : '0-59',
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? -1;
                            if (raw > 59) {
                              hasSdcProfile = false;
                              isSdcSecsValid = false;
                              sdcSecs = 59;
                            } else if (raw < 0) {
                              isSdcSecsValid = false;
                              sdcSecs = 0;
                            } else {
                              hasSdcProfile = false;
                              isSdcSecsValid = true;
                              sdcSecs = raw;
                            }
                            sdcScore = getAftSdcScore(
                                time: getTimeAsInt(sdcMins, sdcSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ],
                    ),
                    GridBox(
                      title: sdcScore.toString(),
                      background: didPassSdc() ? backgroundColor : failColor,
                      textColor:
                          didPassSdc() ? getTextColor(context) : Colors.white,
                      width: 60,
                      height: 40,
                      borderBottomLeft: 8,
                      borderBottomRight: 8,
                      borderTopLeft: 8,
                      borderTopRight: 8,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (sdcMins > 0) {
                            sdcMins--;
                          } else {
                            sdcMins = 0;
                          }
                          _sdcMinsController.text = sdcMins.toString();
                          isSdcMinsValid = true;
                          sdcScore = getAftSdcScore(
                              time: getTimeAsInt(sdcMins, sdcSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: sdcMins.toDouble(),
                          min: 0,
                          max: 5,
                          divisions: 6,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasSdcProfile) {
                              sdcMins = 0;
                            } else {
                              sdcMins = value.floor();
                            }
                            _sdcMinsController.text = sdcMins.toString();
                            isSdcMinsValid = true;
                            sdcScore = getAftSdcScore(
                                time: getTimeAsInt(sdcMins, sdcSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasSdcProfile) {
                            sdcMins = 0;
                          } else {
                            if (sdcMins < 5) {
                              sdcMins++;
                            } else {
                              sdcMins = 5;
                            }
                          }
                          _sdcMinsController.text = sdcMins.toString();
                          isSdcMinsValid = true;
                          sdcScore = getAftSdcScore(
                              time: getTimeAsInt(sdcMins, sdcSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (sdcSecs > 0) {
                            sdcSecs--;
                          } else {
                            sdcSecs = 0;
                          }
                          _sdcSecsController.text = sdcSecs.toString();
                          isSdcSecsValid = true;
                          sdcScore = getAftSdcScore(
                              time: getTimeAsInt(sdcMins, sdcSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: sdcSecs.toDouble(),
                          min: 0,
                          max: 59,
                          divisions: 60,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasSdcProfile) {
                              sdcSecs = 0;
                            } else {
                              sdcSecs = value.floor();
                            }
                            _sdcSecsController.text = sdcSecs.toString();
                            isSdcSecsValid = true;
                            sdcScore = getAftSdcScore(
                                time: getTimeAsInt(sdcMins, sdcSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasSdcProfile) {
                            sdcSecs = 0;
                          } else {
                            if (sdcSecs < 59) {
                              sdcSecs++;
                            } else {
                              sdcSecs = 59;
                            }
                          }
                          _sdcSecsController.text = sdcSecs.toString();
                          isSdcSecsValid = true;
                          sdcScore = getAftSdcScore(
                              time: getTimeAsInt(sdcMins, sdcSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformCheckboxListTile(
                    title: const Text('Profile'),
                    value: hasSdcProfile,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: onPrimary,
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasSdcProfile = value!;
                        if (value) {
                          sdcMins = 0;
                          sdcSecs = 0;
                          _sdcMinsController.text = sdcMins.toString();
                          _sdcSecsController.text = sdcSecs.toString();
                        }
                        sdcScore = 0;
                        isSdcMinsValid = true;
                        isSdcSecsValid = true;
                        calcTotal();
                      });
                    },
                    onIosTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasSdcProfile = !hasSdcProfile;
                        if (hasSdcProfile) {
                          sdcMins = 0;
                          sdcSecs = 0;
                          _sdcMinsController.text = sdcMins.toString();
                          _sdcSecsController.text = sdcSecs.toString();
                        }
                        sdcScore = 0;
                        isSdcMinsValid = true;
                        isSdcSecsValid = true;
                        calcTotal();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: tableHeaders,
                    values: getAftSdcBenchmarks(
                      ptAgeGroups.indexOf(getAgeGroup(age)),
                      gender == "Male",
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'PLK',
                      style: headerStyle,
                    ),
                    Row(
                      children: <Widget>[
                        ValueInputField(
                          controller: _plankMinsController,
                          focusNode: _plkMinsFocus,
                          width: 40,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          errorText: isPlankMinsValid ? null : '0-4',
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? -1;
                            if (raw < 0) {
                              isPlankMinsValid = false;
                              plankMins = 0;
                            } else if (raw > 4) {
                              hasPlkProfile = false;
                              isPlankMinsValid = false;
                              plankMins = 4;
                            } else {
                              hasPlkProfile = false;
                              isPlankMinsValid = true;
                              plankMins = raw;
                            }
                            plankScore = getAftPlkScore(
                                time: getTimeAsInt(plankMins, plankSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                          child: Text(
                            ':',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ValueInputField(
                          controller: _plankSecsController,
                          focusNode: _plkSecsFocus,
                          onEditingComplete: () => _runMinsFocus.requestFocus(),
                          errorText: isPlankSecsValid ? null : '0-59',
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? -1;
                            if (raw > 59) {
                              hasPlkProfile = false;
                              isPlankSecsValid = false;
                              plankSecs = 59;
                            } else if (raw < 0) {
                              isPlankSecsValid = false;
                              plankSecs = 0;
                            } else {
                              hasPlkProfile = false;
                              isPlankSecsValid = true;
                              plankSecs = raw;
                            }
                            plankScore = getAftPlkScore(
                                time: getTimeAsInt(plankMins, plankSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ],
                    ),
                    GridBox(
                      title: plankScore.toString(),
                      background: didPassPlk() ? backgroundColor : failColor,
                      textColor:
                          didPassPlk() ? getTextColor(context) : Colors.white,
                      width: 60,
                      height: 40,
                      borderBottomLeft: 8,
                      borderBottomRight: 8,
                      borderTopLeft: 8,
                      borderTopRight: 8,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (plankMins > 0) {
                            plankMins--;
                          } else {
                            plankMins = 0;
                          }
                          _plankMinsController.text = plankMins.toString();
                          isPlankMinsValid = true;
                          plankScore = getAftPlkScore(
                              time: getTimeAsInt(plankMins, plankSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: plankMins.toDouble(),
                          min: 0,
                          max: 4,
                          divisions: 5,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasPlkProfile) {
                              plankMins = 0;
                            } else {
                              plankMins = value.floor();
                            }
                            _plankMinsController.text = plankMins.toString();
                            isPlankMinsValid = true;
                            plankScore = getAftPlkScore(
                                time: getTimeAsInt(plankMins, plankSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasPlkProfile) {
                            plankMins = 0;
                          } else {
                            if (plankMins < 4) {
                              plankMins++;
                            } else {
                              plankMins = 4;
                            }
                          }
                          _plankMinsController.text = plankMins.toString();
                          isPlankMinsValid = true;
                          plankScore = getAftPlkScore(
                              time: getTimeAsInt(plankMins, plankSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (plankSecs > 0) {
                            plankSecs--;
                          } else {
                            plankSecs = 0;
                          }
                          _plankSecsController.text = plankSecs.toString();
                          isPlankSecsValid = true;
                          plankScore = getAftPlkScore(
                              time: getTimeAsInt(plankMins, plankSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: plankSecs.toDouble(),
                          min: 0,
                          max: 59,
                          divisions: 60,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasPlkProfile) {
                              plankSecs = 0;
                            } else {
                              plankSecs = value.floor();
                            }
                            _plankSecsController.text = plankSecs.toString();
                            isPlankSecsValid = true;
                            plankScore = getAftPlkScore(
                                time: getTimeAsInt(plankMins, plankSecs),
                                ageGroup:
                                    ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                                male: gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasPlkProfile) {
                            plankSecs = 0;
                          } else {
                            if (plankSecs < 59) {
                              plankSecs++;
                            } else {
                              plankSecs = 59;
                            }
                          }
                          _plankSecsController.text = plankSecs.toString();
                          isPlankSecsValid = true;
                          plankScore = getAftPlkScore(
                              time: getTimeAsInt(plankMins, plankSecs),
                              ageGroup:
                                  ptAgeGroups.indexOf(getAgeGroup(age)) + 1,
                              male: gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformCheckboxListTile(
                    title: const Text('Profile'),
                    value: hasPlkProfile,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: onPrimary,
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasPlkProfile = value!;
                        if (value) {
                          plankMins = 0;
                          plankSecs = 0;
                          _plankMinsController.text = plankMins.toString();
                          _plankSecsController.text = plankSecs.toString();
                        }
                        plankScore = 0;
                        isPlankMinsValid = true;
                        isPlankSecsValid = true;
                        calcTotal();
                      });
                    },
                    onIosTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasPlkProfile = !hasPlkProfile;
                        if (hasPlkProfile) {
                          plankMins = 0;
                          plankSecs = 0;
                          _plankMinsController.text = plankMins.toString();
                          _plankSecsController.text = plankSecs.toString();
                        }
                        plankScore = 0;
                        isPlankMinsValid = true;
                        isPlankSecsValid = true;
                        calcTotal();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: tableHeaders,
                    values: getAftPlkBenchmarks(
                      ptAgeGroups.indexOf(getAgeGroup(age)),
                      gender == "Male",
                    ),
                  ),
                ),
                Divider(
                  color: Colors.yellow,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: PlatformItemPicker(
                    label: Text(
                      'Aerobic Event',
                      style: headerStyle,
                    ),
                    value: aerobicEvent,
                    items: acftAerobicEvents,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        aerobicEvent = value;
                      });
                      calcRunScore();
                      calcTotal();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      aerobicEvent,
                      style: headerStyle,
                    ),
                    Row(
                      children: <Widget>[
                        ValueInputField(
                          controller: _runMinsController,
                          focusNode: _runMinsFocus,
                          onEditingComplete: () => _runSecsFocus.requestFocus(),
                          errorText: isRunMinsValid ? null : '10-40',
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? -1;
                            if (raw < 10) {
                              isRunMinsValid = false;
                              runMins = 10;
                            } else if (raw > 40) {
                              isRunMinsValid = false;
                              runMins = 40;
                            } else {
                              isRunMinsValid = true;
                              runMins = raw;
                            }
                            calcRunScore();
                            calcTotal();
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                          child: Text(
                            ':',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ValueInputField(
                          controller: _runSecsController,
                          focusNode: _runSecsFocus,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => _runSecsFocus.unfocus(),
                          errorText: isRunSecsValid ? null : '0-59',
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? -1;
                            if (raw > 59) {
                              isRunSecsValid = false;
                              runSecs = 59;
                            } else if (raw < 0) {
                              isRunSecsValid = false;
                              runSecs = 0;
                            } else {
                              isRunSecsValid = true;
                              runSecs = raw;
                            }
                            calcRunScore();
                            calcTotal();
                          },
                        ),
                      ],
                    ),
                    GridBox(
                      title: runScore.toString(),
                      background:
                          didPassAerobic() ? backgroundColor : failColor,
                      textColor: didPassAerobic()
                          ? getTextColor(context)
                          : Colors.white,
                      width: 60,
                      height: 40,
                      borderBottomLeft: 8,
                      borderBottomRight: 8,
                      borderTopLeft: 8,
                      borderTopRight: 8,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (runMins > 10) {
                            runMins--;
                          } else {
                            runMins = 10;
                          }
                          _runMinsController.text = runMins.toString();
                          isRunMinsValid = true;
                          calcRunScore();
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: runMins.toDouble(),
                          min: 10,
                          max: 40,
                          divisions: 31,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            runMins = value.floor();
                            _runMinsController.text = runMins.toString();
                            isRunMinsValid = true;
                            calcRunScore();
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (runMins < 40) {
                            runMins++;
                          } else {
                            runMins = 40;
                          }
                          _runMinsController.text = runMins.toString();
                          isRunMinsValid = true;
                          calcRunScore();
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      IncrementDecrementButton(
                        child: '-',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (runSecs > 0) {
                            runSecs--;
                          } else {
                            runSecs = 0;
                          }
                          _runSecsController.text = runSecs.toString();
                          isRunSecsValid = true;
                          calcRunScore();
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: runSecs.toDouble(),
                          min: 0,
                          max: 59,
                          divisions: 60,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            runSecs = value.floor();
                            _runSecsController.text = runSecs.toString();
                            isRunSecsValid = true;
                            calcRunScore();
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (runSecs < 59) {
                            runSecs++;
                          } else {
                            runSecs = 59;
                          }
                          _runSecsController.text = runSecs.toString();
                          isRunSecsValid = true;
                          calcRunScore();
                          calcTotal();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: tableHeaders,
                    values: getAerobicBenchmarks(),
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 48.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GridBox(
                        title: 'Total Score',
                        background: primaryColor,
                        textColor: onPrimary,
                        isTotal: true,
                        borderTopLeft: 12.0,
                        borderTopRight: 12.0,
                      ),
                      GridBox(
                        title: total.toString(),
                        background: didPassAcft() ? backgroundColor : failColor,
                        textColor: didPassAcft()
                            ? getTextColor(context)
                            : Colors.white,
                        isTotal: true,
                        borderBottomLeft: 12.0,
                        borderBottomRight: 12.0,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: ButtonText(
                      text: 'Save AFT Score',
                    ),
                    onPressed: () {
                      String sdcSeconds = sdcSecs.toString().length == 1
                          ? '0$sdcSecs'
                          : sdcSecs.toString();
                      String plankSeconds = plankSecs.toString().length == 1
                          ? '0$plankSecs'
                          : plankSecs.toString();
                      String runSeconds = runSecs.toString().length == 1
                          ? '0$runSecs'
                          : runSecs.toString();
                      Aft aft = new Aft(
                          id: null,
                          date: null,
                          rank: null,
                          name: null,
                          gender: gender.toString(),
                          age: age.toString(),
                          mdlRaw: mdlRaw.toString(),
                          mdlScore: mdlScore.toString(),
                          hrpRaw: hrpRaw.toString(),
                          hrpScore: hrpScore.toString(),
                          sdcRaw: '${sdcMins.toString()}:$sdcSeconds',
                          sdcScore: sdcScore.toString(),
                          plkRaw: '${plankMins.toString()}:$plankSeconds',
                          plkScore: plankScore.toString(),
                          runRaw: '${runMins.toString()}:$runSeconds',
                          runScore: runScore.toString(),
                          runEvent: aerobicEvent,
                          total: total.toString(),
                          altPass: didPassAerobic() ? 1 : 0,
                          pass: didPassAcft() ? 1 : 0);
                      _saveAft(context, aft);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
