import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../providers/premium_state_provider.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../methods/theme_methods.dart';
import '../../providers/purchases_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../services/purchases_service.dart';
import '../../widgets/button_text.dart';
import '../../widgets/min_max_table.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../sqlite/db_helper.dart';
import '../../sqlite/acft.dart';
import '../../calculators/2mr_calculator.dart';
import '../../calculators/acft_calculator.dart';
import '../../calculators/spt_calculator.dart';
import '../../calculators/hrp_calculator.dart';
import '../../calculators/mdl_calculator.dart';
import '../../calculators/plk_calculator.dart';
import '../../calculators/sdc_calculator.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_slider.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_acfts_page.dart';
import '../../widgets/platform_widgets/platform_item_picker.dart';
import '../../widgets/platform_widgets/platform_selection_widget.dart';
import '../../widgets/grid_box.dart';
import '../../widgets/increment_decrement_button.dart';
import '../../constants/pt_age_group_table.dart';
import '../../constants/acft_aerobic_event_table.dart';
import '../../widgets/value_input_field.dart';

class AcftPage extends ConsumerStatefulWidget {
  AcftPage();

  static const String title = 'ACFT Calculator';

  @override
  AcftPageState createState() => AcftPageState();
}

class AcftPageState extends ConsumerState<AcftPage>
    with WidgetsBindingObserver {
  int age = 22,
      mdlRaw = 300,
      hrpRaw = 50,
      sdcMins = 1,
      sdcSecs = 50,
      plankMins = 3,
      plankSecs = 48,
      runMins = 15,
      runSecs = 0;
  int? mdlScore, sptScore, hrpScore, sdcScore, plankScore, runScore, total;
  bool isAgeValid = true,
      isMdlValid = true,
      isSptValid = true,
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
      hasPlkProfile = false,
      mdlPass = true,
      sptPass = true,
      hrpPass = true,
      sdcPass = true,
      plkPass = true,
      runPass = true,
      totalPass = true;
  double sptRaw = 11.0;
  static String ageGroup = '17-21';
  static Object gender = 'Male';
  String? mdlMinimum,
      mdl80,
      mdlMax,
      sptMinimum,
      spt80,
      sptMax,
      hrpMinimum,
      hrp80,
      hrpMax,
      sdcMinimum,
      sdc80,
      sdcMax,
      plkMinimum,
      plk80,
      plkMax,
      runMinimum,
      run80,
      runMax,
      aerobicEvent;
  List<String>? mdlBenchmarks,
      sptBenchmarks,
      hrpBenchmarks,
      sdcBenchmarks,
      plkBenchmarks,
      runBenchmarks,
      altBenchmarks;
  List<String> tableHeaders = ['Min', '80%', 'Max'];
  late SharedPreferences prefs;
  DBHelper dbHelper = DBHelper();
  TextStyle headerStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );
  late BannerAd myBanner;
  RegExp regExp = RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');

  final _ageController = TextEditingController();
  final _mdlController = TextEditingController();
  final _sptController = TextEditingController();
  final _hrpController = TextEditingController();
  final _sdcMinsController = TextEditingController();
  final _sdcSecsController = TextEditingController();
  final _plankMinsController = TextEditingController();
  final _plankSecsController = TextEditingController();
  final _runMinsController = TextEditingController();
  final _runSecsController = TextEditingController();

  final _ageFocus = FocusNode();
  final _mdlFocus = FocusNode();
  final _sptFocus = FocusNode();
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
    purchasesService = ref.read(purchasesProvider);

    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/8950325543'
          : 'ca-app-pub-2431077176117105/4488336359',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest(nonPersonalizedAds: true),
    );

    myBanner.load();

    mdlRaw = prefs.getInt('mdlRaw') ?? 300;
    sptRaw = prefs.getDouble('sptRaw') ?? 11.0;
    hrpRaw = prefs.getInt('hrpRaw') ?? 50;
    sdcMins = prefs.getInt('sdcMins') ?? 1;
    sdcSecs = prefs.getInt('sdcSecs') ?? 50;
    plankMins = prefs.getInt('plkMins') ?? 3;
    plankSecs = prefs.getInt('plkSecs') ?? 48;
    runMins = prefs.getInt('runMins') ?? 15;
    runSecs = prefs.getInt('runSecs') ?? 0;

    _mdlController.text = mdlRaw.toString();
    _sptController.text = sptRaw.toString();
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
    _sptFocus.addListener(() {
      if (_sptFocus.hasFocus) {
        _sptController.selection = TextSelection(
            baseOffset: 0, extentOffset: _sptController.text.length);
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
      aerobicEvent = prefs.getString('acft_event');
    } else {
      aerobicEvent = 'Run';
    }
    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender')!;
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age')!;
    }
    setAgeGroup();

    _ageController.text = age.toString();

    calcAll();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      prefs.setInt('mdlRaw', mdlRaw);
      prefs.setDouble('sptRaw', sptRaw);
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
    _sptController.dispose();
    _hrpController.dispose();
    _sdcMinsController.dispose();
    _sdcSecsController.dispose();
    _plankMinsController.dispose();
    _plankSecsController.dispose();
    _runMinsController.dispose();
    _runSecsController.dispose();

    _ageFocus.dispose();
    _mdlFocus.dispose();
    _sptFocus.dispose();
    _hrpFocus.dispose();
    _sdcMinsFocus.dispose();
    _sdcSecsFocus.dispose();
    _plkMinsFocus.dispose();
    _plkSecsFocus.dispose();
    _runMinsFocus.dispose();
    _runSecsFocus.dispose();

    myBanner.dispose();
  }

  void setAgeGroup() {
    if (age < 22) {
      ageGroup = '17-21';
      return;
    }
    if (age < 27) {
      ageGroup = '22-26';
      return;
    }
    if (age < 32) {
      ageGroup = '27-31';
      return;
    }
    if (age < 37) {
      ageGroup = '32-36';
      return;
    }
    if (age < 42) {
      ageGroup = '37-41';
      return;
    }
    if (age < 47) {
      ageGroup = '42-46';
      return;
    }
    if (age < 52) {
      ageGroup = '47-51';
      return;
    }
    if (age < 57) {
      ageGroup = '52-56';
      return;
    }
    if (age < 62) {
      ageGroup = '57-61';
      return;
    }
    ageGroup = '62+';
  }

  void calcAll() {
    setBenchmarks();
    mdlScore = getMdlScore(
        mdlRaw, ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
    sptScore = getSptScore(
        sptRaw, ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
    hrpScore = getHrpScore(
        hrpRaw, ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
    sdcScore = getSdcScore(getTimeAsInt(sdcMins, sdcSecs),
        ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
    plankScore = getPlkScore(getTimeAsInt(plankMins, plankSecs),
        ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
    calcRunScore();
    calcTotal();
  }

  void setBenchmarks() {
    mdlBenchmarks =
        getMdlBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");
    sptBenchmarks =
        getSptBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");
    hrpBenchmarks =
        getHrpBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");
    sdcBenchmarks =
        getSdcBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");
    plkBenchmarks =
        getPlkBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");
    runBenchmarks =
        get2mrBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");
    altBenchmarks =
        getAltBenchmarks(ptAgeGroups.indexOf(ageGroup), gender == "Male");

    mdlMinimum = mdlBenchmarks![0];
    mdl80 = mdlBenchmarks![1];
    mdlMax = mdlBenchmarks![2];
    sptMinimum = sptBenchmarks![0];
    spt80 = sptBenchmarks![1];
    sptMax = sptBenchmarks![2];
    hrpMinimum = hrpBenchmarks![0];
    hrp80 = hrpBenchmarks![1];
    hrpMax = hrpBenchmarks![2];
    sdcMinimum = sdcBenchmarks![0];
    sdc80 = sdcBenchmarks![1];
    sdcMax = sdcBenchmarks![2];
    plkMinimum = plkBenchmarks![0];
    plk80 = plkBenchmarks![1];
    plkMax = plkBenchmarks![2];

    switch (aerobicEvent) {
      case "Run":
        runMinimum = runBenchmarks![0];
        run80 = runBenchmarks![1];
        runMax = runBenchmarks![2];
        break;
      case "Walk":
        runMinimum = altBenchmarks![0];
        run80 = '-';
        runMax = '-';
        break;
      case "Bike":
        runMinimum = altBenchmarks![1];
        run80 = '-';
        runMax = '-';
        break;
      case "Swim":
        runMinimum = altBenchmarks![2];
        run80 = '-';
        runMax = '-';
        break;
      case "Row":
        runMinimum = altBenchmarks![2];
        run80 = '-';
        runMax = '-';
        break;
    }
    setState(() {});
  }

  int getTimeAsInt(int? mins, int? secs) {
    String secString =
        secs.toString().length == 2 ? secs.toString() : '0' + secs.toString();
    return int.tryParse(mins.toString() + secString) ?? 0;
  }

  void calcRunScore() {
    int time = getTimeAsInt(runMins, runSecs);
    if (aerobicEvent == 'Run') {
      runScore = get2mrScore(
          time, ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
    } else {
      int min = int.tryParse(runMinimum!.replaceRange(2, 3, "")) ?? 0;
      if (time <= min) {
        runScore = 60;
      } else {
        runScore = 0;
      }
    }
  }

  void calcTotal() {
    setState(() {
      total = mdlScore! +
          sptScore! +
          hrpScore! +
          sdcScore! +
          plankScore! +
          runScore!;
      mdlPass = mdlScore! >= 60 || hasMdlProfile;
      sptPass = sptScore! >= 60 || hasSptProfile;
      hrpPass = hrpScore! >= 60 || hasHrpProfile;
      sdcPass = sdcScore! >= 60 || hasSdcProfile;
      plkPass = plankScore! >= 60 || hasPlkProfile;
      runPass = runScore! >= 60;

      if (aerobicEvent != 'Run') {
        runPass = runScore == 60;
      }
      totalPass =
          mdlPass && sptPass && hrpPass && sdcPass && plkPass && runPass;
    });
  }

  _saveAcft(BuildContext context, Acft acft) {
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
                      regExp.hasMatch(value!) ? null : 'Use yyyyMMdd Format',
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
                    acft.date = _dateController.text;
                    acft.rank = _rankController.text;
                    acft.name = _nameController.text;
                    dbHelper.saveAcft(acft);
                    Navigator.of(ctx).pop();
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(SavedAcftsPage.routeName);
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
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumStateProvider) ||
        (prefs.getBool('isPremium') ?? false);
    final trackingAllowed = ref.watch(trackingProvider);
    if (!isPremium) {
      ref.read(trackingProvider.notifier).init();
      myBanner = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-2431077176117105/8950325543'
            : 'ca-app-pub-2431077176117105/4488336359',
        size: AdSize.banner,
        listener: BannerAdListener(),
        request: AdRequest(nonPersonalizedAds: !trackingAllowed),
      );

      myBanner.load();
    }

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
                          gender = value!;
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
                        setAgeGroup();
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
                          setAgeGroup();
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
                            setAgeGroup();
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
                          setAgeGroup();
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
                      onEditingComplete: () => _sptFocus.requestFocus(),
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
                        mdlScore = getMdlScore(
                            mdlRaw,
                            ptAgeGroups.indexOf(ageGroup) + 1,
                            gender == 'Male');
                        calcTotal();
                      },
                    ),
                    GridBox(
                      title: mdlScore.toString(),
                      background: mdlPass ? backgroundColor : failColor,
                      textColor: mdlPass ? getTextColor(context) : Colors.white,
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
                          mdlScore = getMdlScore(
                              mdlRaw,
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                            mdlScore = getMdlScore(
                                mdlRaw,
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                          mdlScore = getMdlScore(
                              mdlRaw,
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                    values: [
                      mdlMinimum.toString(),
                      mdl80.toString(),
                      mdlMax.toString()
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
                      'SPT',
                      style: headerStyle,
                    ),
                    ValueInputField(
                      width: 60,
                      controller: _sptController,
                      focusNode: _sptFocus,
                      onEditingComplete: () => _hrpFocus.requestFocus(),
                      errorText: isSptValid ? null : '0-14.0',
                      onChanged: (value) {
                        double raw = double.tryParse(value) ?? 0;
                        if (raw > 14.0) {
                          hasSptProfile = false;
                          isSptValid = false;
                          sptRaw = 14.0;
                        } else if (raw < 0.0) {
                          isSptValid = false;
                          sptRaw = 0.0;
                        } else {
                          hasSptProfile = false;
                          sptRaw = raw;
                          isSptValid = true;
                        }
                        sptScore = getSptScore(
                            sptRaw,
                            ptAgeGroups.indexOf(ageGroup) + 1,
                            gender == 'Male');
                        calcTotal();
                      },
                    ),
                    GridBox(
                      title: sptScore.toString(),
                      background: sptPass ? backgroundColor : failColor,
                      textColor: sptPass ? getTextColor(context) : Colors.white,
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
                          if (sptRaw > 0.0) {
                            sptRaw = double.tryParse(
                                    (sptRaw - 0.1).toStringAsFixed(1)) ??
                                sptRaw - 0.1;
                          } else {
                            sptRaw = 0.0;
                          }
                          _sptController.text = sptRaw.toString();
                          isSptValid = true;
                          sptScore = getSptScore(
                              sptRaw,
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
                          calcTotal();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: getPrimaryColor(context),
                          value: sptRaw,
                          min: 0,
                          max: 14.0,
                          divisions: 141,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            if (hasSptProfile) {
                              sptRaw = 0;
                            } else {
                              sptRaw = (value * 10).round() / 10;
                            }
                            _sptController.text = sptRaw.toString();
                            isSptValid = true;
                            sptScore = getSptScore(
                                sptRaw,
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (hasSptProfile) {
                            sptRaw = 0;
                          } else {
                            if (sptRaw < 14.0) {
                              sptRaw = double.tryParse(
                                      (sptRaw + 0.1).toStringAsFixed(1)) ??
                                  sptRaw + 0.1;
                            } else {
                              sptRaw = 14.0;
                            }
                          }
                          _sptController.text = sptRaw.toString();
                          isSptValid = true;
                          sptScore = getSptScore(
                              sptRaw,
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                    value: hasSptProfile,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: onPrimary,
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasSptProfile = value!;
                        if (value) {
                          sptRaw = 0;
                          _sptController.text = sptRaw.toString();
                        }
                        sptScore = 0;
                        isSptValid = true;
                        calcTotal();
                      });
                    },
                    onIosTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hasSptProfile = !hasSptProfile;
                        if (hasSptProfile) {
                          sptRaw = 0;
                          _sptController.text = sptRaw.toString();
                        }
                        sptScore = 0;
                        isSptValid = true;
                        calcTotal();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: tableHeaders,
                    values: [
                      sptMinimum.toString(),
                      spt80.toString(),
                      sptMax.toString()
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
                        hrpScore = getHrpScore(
                            hrpRaw,
                            ptAgeGroups.indexOf(ageGroup) + 1,
                            gender == 'Male');
                        calcTotal();
                      },
                    ),
                    GridBox(
                      title: hrpScore.toString(),
                      background: hrpPass ? backgroundColor : failColor,
                      textColor: hrpPass ? getTextColor(context) : Colors.white,
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
                          hrpScore = getHrpScore(
                              hrpRaw,
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                            hrpScore = getHrpScore(
                                hrpRaw,
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                          hrpScore = getHrpScore(
                              hrpRaw,
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                    values: [
                      hrpMinimum.toString(),
                      hrp80.toString(),
                      hrpMax.toString()
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
                            sdcScore = getSdcScore(
                                getTimeAsInt(sdcMins, sdcSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                            sdcScore = getSdcScore(
                                getTimeAsInt(sdcMins, sdcSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ],
                    ),
                    GridBox(
                      title: sdcScore.toString(),
                      background: sdcPass ? backgroundColor : failColor,
                      textColor: sdcPass ? getTextColor(context) : Colors.white,
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
                          sdcScore = getSdcScore(
                              getTimeAsInt(sdcMins, sdcSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                            sdcScore = getSdcScore(
                                getTimeAsInt(sdcMins, sdcSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                          sdcScore = getSdcScore(
                              getTimeAsInt(sdcMins, sdcSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                          sdcScore = getSdcScore(
                              getTimeAsInt(sdcMins, sdcSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                            sdcScore = getSdcScore(
                                getTimeAsInt(sdcMins, sdcSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                          sdcScore = getSdcScore(
                              getTimeAsInt(sdcMins, sdcSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                    values: [
                      sdcMinimum.toString(),
                      sdc80.toString(),
                      sdcMax.toString()
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
                            plankScore = getPlkScore(
                                getTimeAsInt(plankMins, plankSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                            plankScore = getPlkScore(
                                getTimeAsInt(plankMins, plankSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
                            calcTotal();
                          },
                        ),
                      ],
                    ),
                    GridBox(
                      title: plankScore.toString(),
                      background: plkPass ? backgroundColor : failColor,
                      textColor: plkPass ? getTextColor(context) : Colors.white,
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
                          plankScore = getPlkScore(
                              getTimeAsInt(plankMins, plankSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                            plankScore = getPlkScore(
                                getTimeAsInt(plankMins, plankSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                          plankScore = getPlkScore(
                              getTimeAsInt(plankMins, plankSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                          plankScore = getPlkScore(
                              getTimeAsInt(plankMins, plankSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                            plankScore = getPlkScore(
                                getTimeAsInt(plankMins, plankSecs),
                                ptAgeGroups.indexOf(ageGroup) + 1,
                                gender == 'Male');
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
                          plankScore = getPlkScore(
                              getTimeAsInt(plankMins, plankSecs),
                              ptAgeGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
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
                    values: [
                      plkMinimum.toString(),
                      plk80.toString(),
                      plkMax.toString()
                    ],
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
                    value: aerobicEvent!,
                    items: acftAerobicEvents,
                    onChanged: (value) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        aerobicEvent = value;
                      });
                      setBenchmarks();
                      calcRunScore();
                      calcTotal();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      aerobicEvent!,
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
                      background: runPass ? backgroundColor : failColor,
                      textColor: runPass ? getTextColor(context) : Colors.white,
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
                    values: [
                      runMinimum.toString(),
                      run80.toString(),
                      runMax.toString()
                    ],
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
                        background: totalPass ? backgroundColor : failColor,
                        textColor:
                            totalPass ? getTextColor(context) : Colors.white,
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
                      text: 'Save ACFT Score',
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
                      if (isPremium) {
                        Acft acft = new Acft(
                            id: null,
                            date: null,
                            rank: null,
                            name: null,
                            gender: gender.toString(),
                            age: age.toString(),
                            mdlRaw: mdlRaw.toString(),
                            mdlScore: mdlScore.toString(),
                            sptRaw: sptRaw.toString(),
                            sptScore: sptScore.toString(),
                            hrpRaw: hrpRaw.toString(),
                            hrpScore: hrpScore.toString(),
                            sdcRaw: '${sdcMins.toString()}:$sdcSeconds',
                            sdcScore: sdcScore.toString(),
                            plkRaw: '${plankMins.toString()}:$plankSeconds',
                            plkScore: plankScore.toString(),
                            runRaw: '${runMins.toString()}:$runSeconds',
                            runScore: runScore.toString(),
                            runEvent: aerobicEvent!,
                            total: total.toString(),
                            altPass: runPass ? 1 : 0,
                            pass: totalPass ? 1 : 0);
                        _saveAcft(context, acft);
                      } else {
                        purchasesService.upgradeNeeded(context);
                      }
                    },
                  ),
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
            ),
        ],
      ),
    );
  }
}
