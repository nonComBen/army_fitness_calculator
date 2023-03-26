import 'dart:io';

import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/providers/premium_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../methods/platform_show_modal_bottom_sheet.dart';
import '../providers/shared_preferences_provider.dart';
import '../sqlite/db_helper.dart';
import '../widgets/min_max_table.dart';
import '../widgets/platform_widgets/platform_item_picker.dart';
import '../widgets/platform_widgets/platform_selection_widget.dart';
import '../widgets/grid_box.dart';
import '../widgets/increment_decrement_button.dart';
import '../calculators/pu_calculator.dart';
import '../calculators/su_calculator.dart';
import '../calculators/run_calculator.dart';
import '../sqlite/apft.dart';
import '../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../widgets/platform_widgets/platform_slider.dart';
import '../widgets/platform_widgets/platform_text_field.dart';
import 'saved_pages/saved_apfts_page.dart';
import '../widgets/value_input_field.dart';
import '../../providers/purchases_provider.dart';
import '../../services/purchases_service.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';

class ApftPage extends ConsumerStatefulWidget {
  ApftPage();

  static const String routeName = 'apftPageRoute';

  @override
  _ApftPageState createState() => _ApftPageState();
}

class _ApftPageState extends ConsumerState<ApftPage> {
  String ageGroup = '17-21',
      event = 'Run',
      puMin = '',
      pu90 = '',
      puMax = '',
      suMin = '',
      su90 = '',
      suMax = '',
      runMin = '',
      run90 = '',
      runMax = '';
  Object gender = 'Male';
  int age = 22,
      pu = 50,
      su = 50,
      runMins = 15,
      runSecs = 30,
      puScore = 0,
      suScore = 0,
      runScore = 0,
      totalScore = 0;
  bool isJrSoldier = false,
      puPass = true,
      suPass = true,
      runPass = true,
      totalPass = true,
      hasPuProfile = false,
      hasSuProfile = false,
      isAgeValid = true,
      isMinsValid = true,
      isSecValid = true;
  List<String> tableHeaders = ['Min', '90%', 'Max'];
  late SharedPreferences prefs;
  RegExp regExp = RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
  DBHelper dbHelper = DBHelper();
  TextStyle headerStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  late PurchasesService purchasesService;
  late BannerAd myBanner;

  final _ageController = new TextEditingController();
  final _ageFocus = new FocusNode();
  final _puController = new TextEditingController();
  final _puFocus = new FocusNode();
  final _suController = new TextEditingController();
  final _suFocus = new FocusNode();
  final _minsController = new TextEditingController();
  final _minsFocus = new FocusNode();
  final _secsController = new TextEditingController();
  final _secsFocus = new FocusNode();

  List<String?> ageGroups = [
    '17-21',
    '22-26',
    '27-31',
    '32-36',
    '37-41',
    '42-46',
    '47-51',
    '52-56',
    '57-61',
    '62+'
  ];

  List<String> events = [
    'Run',
    'Walk',
    'Bike',
    'Swim',
  ];

  @override
  void initState() {
    super.initState();
    dbHelper = new DBHelper();
    purchasesService = ref.read(purchasesProvider);
    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/9048806118'
          : 'ca-app-pub-2431077176117105/4321694244',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest(nonPersonalizedAds: true),
    );

    myBanner.load();

    _puController.text = pu.toString();
    _suController.text = su.toString();
    _minsController.text = runMins.toString();
    _secsController.text = runSecs.toString();

    _ageFocus.addListener(() {
      if (_ageFocus.hasFocus) {
        _ageController.selection = TextSelection(
            baseOffset: 0, extentOffset: _ageController.text.length);
      }
    });
    _puFocus.addListener(() {
      if (_puFocus.hasFocus) {
        _puController.selection = TextSelection(
            baseOffset: 0, extentOffset: _puController.text.length);
      }
    });
    _suFocus.addListener(() {
      if (_suFocus.hasFocus) {
        _suController.selection = TextSelection(
            baseOffset: 0, extentOffset: _suController.text.length);
      }
    });
    _minsFocus.addListener(() {
      if (_minsFocus.hasFocus) {
        _minsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _minsController.text.length);
      }
    });
    _secsFocus.addListener(() {
      if (_secsFocus.hasFocus) {
        _secsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _secsController.text.length);
      }
    });

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender')!;
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age')!;
    }
    if (prefs.getString('apft_event') != null) {
      event = prefs.getString('apft_event')!;
    }
    if (prefs.getBool('jr_soldier') != null) {
      isJrSoldier = prefs.getBool('jr_soldier')!;
    }

    _ageController.text = age.toString();
    ageGroup = getAgeGroup(age);

    calcAll();
  }

  @override
  void dispose() {
    super.dispose();
    _ageController.dispose();
    _puController.dispose();
    _suController.dispose();
    _minsController.dispose();
    _secsController.dispose();

    _ageFocus.dispose();
    _puFocus.dispose();
    _suFocus.dispose();
    _minsFocus.dispose();
    _secsFocus.dispose();

    myBanner.dispose();
  }

  void calcAll() {
    setBenchmarks();
    _calcPu();
    _calcSu();
    _calcRun();
    _calcTotal();
  }

  void setBenchmarks() {
    setState(() {
      puMin = getPuBenchmarks(gender == "Male", ageGroups.indexOf(ageGroup))[0]
          .toString();
      pu90 = getPuBenchmarks(gender == "Male", ageGroups.indexOf(ageGroup))[1]
          .toString();
      puMax = getPuBenchmarks(gender == "Male", ageGroups.indexOf(ageGroup))[2]
          .toString();
      suMin = getSuBenchmarks(ageGroups.indexOf(ageGroup))[0].toString();
      su90 = getSuBenchmarks(ageGroups.indexOf(ageGroup))[1].toString();
      suMax = getSuBenchmarks(ageGroups.indexOf(ageGroup))[2].toString();
      runMin = getRunBenchmarks(
          gender == "Male", ageGroups.indexOf(ageGroup), event)[0];
      run90 = getRunBenchmarks(
          gender == "Male", ageGroups.indexOf(ageGroup), event)[1];
      runMax = getRunBenchmarks(
          gender == "Male", ageGroups.indexOf(ageGroup), event)[2];
    });
  }

  void _calcPu() {
    if (hasPuProfile) {
      if (isJrSoldier) {
        puScore = 60;
      } else {
        puScore = 0;
      }
    } else {
      puScore = getPuScore(gender == "Male", ageGroups.indexOf(ageGroup), pu);
    }
    if (puScore < 60 && !hasPuProfile) {
      puPass = false;
    } else
      puPass = true;
  }

  void _calcSu() {
    if (hasSuProfile) {
      if (isJrSoldier) {
        suScore = 60;
      } else {
        suScore = 0;
      }
    } else {
      suScore = getSuScore(ageGroups.indexOf(ageGroup), su);
    }

    if (suScore < 60 && !hasSuProfile) {
      suPass = false;
    } else
      suPass = true;
  }

  void _calcRun() {
    String seconds;
    if (runSecs.toString().length == 1) {
      seconds = '0' + runSecs.toString();
    } else
      seconds = runSecs.toString();

    int? runTime = int.tryParse(runMins.toString() + seconds);
    if (event != 'Run') {
      runPass = passAltEvent(
          gender == "Male", ageGroups.indexOf(ageGroup), runTime, event);
      if (isJrSoldier) {
        if (runPass) {
          runScore = ((puScore + suScore) / 2).floor();
        } else {
          runScore = 0;
        }
      } else {
        runScore = 0;
      }
    } else {
      runScore =
          getRunScore(gender == "Male", ageGroups.indexOf(ageGroup), runTime)!;
      if (runScore < 60) {
        runPass = false;
      } else
        runPass = true;
    }
  }

  void _calcTotal() {
    setState(() {
      totalScore = puScore + suScore + runScore;
      totalPass = puPass && suPass && runPass;
    });
  }

  String getAgeGroup(int age) {
    if (age < 22) return '17-21';
    if (age < 27) return '22-26';
    if (age < 32) return '27-31';
    if (age < 37) return '32-36';
    if (age < 42) return '37-41';
    if (age < 47) return '42-46';
    if (age < 52) return '47-51';
    if (age < 57) return '52-56';
    if (age < 62) return '57-61';
    return '62+';
  }

  _saveApft(BuildContext context, Apft apft) {
    final f = new DateFormat('yyyyMMdd');
    final date = f.format(DateTime.now());
    final _dateController = new TextEditingController(text: date);
    final _rankController = TextEditingController();
    final _nameController = new TextEditingController();
    showPlatformModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        color: getBackgroundColor(context),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 2 / 3,
        ),
        padding: EdgeInsets.only(
            top: 8,
            left: 8,
            right: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom == 0
                ? MediaQuery.of(ctx).padding.bottom
                : MediaQuery.of(ctx).viewInsets.bottom),
        child: ListView(
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
                child: Text('Save APFT'),
                onPressed: () {
                  apft.date = _dateController.text;
                  apft.rank = _rankController.text;
                  apft.name = _nameController.text;
                  dbHelper.saveAPft(apft);
                  Navigator.pop(ctx);
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(SavedApftsPage.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.read(premiumStateProvider);
    final primaryColor = getPrimaryColor(context);
    final onPrimary = getOnPrimaryColor(context);
    final failColor = Theme.of(context).colorScheme.error;
    final backgroundColor = getBackgroundColor(context);
    final onSecondary = getOnPrimaryColor(context);
    return PlatformScaffold(
      title: 'APFT Calculator',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformSelectionWidget(
                        titles: [Text('M'), Text('F')],
                        values: ['Male', 'Female'],
                        groupValue: gender,
                        onChanged: (value) {
                          FocusScope.of(context).unfocus();
                          setState(() {
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
                        width: 60,
                        controller: _ageController,
                        focusNode: _ageFocus,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _puFocus.requestFocus(),
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
                          ageGroup = getAgeGroup(age);
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
                            ageGroup = getAgeGroup(age);
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
                              ageGroup = getAgeGroup(age);
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
                            ageGroup = getAgeGroup(age);
                            _ageController.text = age.toString();
                            calcAll();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformItemPicker(
                      label: Text(
                        'Aerobic Event',
                        style: TextStyle(
                          color: getTextColor(context),
                        ),
                      ),
                      value: event,
                      items: events,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          event = value!;
                        });
                        calcAll();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Push Ups',
                        style: headerStyle,
                      ),
                      Row(
                        children: [
                          ValueInputField(
                            width: 60,
                            controller: _puController,
                            focusNode: _puFocus,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => _suFocus.requestFocus(),
                            onChanged: (value) {
                              int raw = int.tryParse(value) ?? 0;
                              setState(() {
                                pu = raw;
                                _calcPu();
                                if (isJrSoldier) _calcRun();
                                _calcTotal();
                              });
                            },
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          GridBox(
                            title: puScore.toString(),
                            background: puPass ? backgroundColor : failColor,
                            width: 60,
                            height: 40,
                            borderColor: Colors.white,
                            borderBottomLeft: 8,
                            borderBottomRight: 8,
                            borderTopLeft: 8,
                            borderTopRight: 8,
                          ),
                        ],
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
                            if (pu > 0 && !hasPuProfile) {
                              pu--;
                              _puController.text = pu.toString();
                              _calcPu();
                              if (isJrSoldier) _calcRun();
                              _calcTotal();
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: PlatformSlider(
                            activeColor: primaryColor,
                            value: pu.toDouble(),
                            min: 0,
                            max: 99,
                            divisions: 100,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                if (hasPuProfile) {
                                  pu = 0;
                                } else {
                                  pu = value.floor();
                                  _puController.text = pu.toString();
                                  _calcPu();
                                  if (isJrSoldier) _calcRun();
                                  _calcTotal();
                                }
                              });
                            },
                          ),
                        ),
                        IncrementDecrementButton(
                          child: '+',
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (pu < 99 && !hasPuProfile) {
                              setState(() {
                                pu++;
                                _puController.text = pu.toString();
                                _calcPu();
                                if (isJrSoldier) _calcRun();
                                _calcTotal();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformCheckboxListTile(
                      title: const Text('Profile'),
                      value: hasPuProfile,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: onSecondary,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          hasPuProfile = value!;
                          if (value) {
                            pu = 0;
                            _puController.text = pu.toString();
                          }
                          _calcPu();
                          if (isJrSoldier) _calcRun();
                          _calcTotal();
                        });
                      },
                      onIosTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          hasPuProfile = !hasPuProfile;
                          if (hasPuProfile) {
                            pu = 0;
                            _puController.text = pu.toString();
                          }
                          _calcPu();
                          if (isJrSoldier) _calcRun();
                          _calcTotal();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MinMaxTable(
                      headers: tableHeaders,
                      values: [
                        puMin.toString(),
                        pu90.toString(),
                        puMax.toString()
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.yellow,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sit Ups',
                        style: const TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ValueInputField(
                            width: 60,
                            controller: _suController,
                            focusNode: _suFocus,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => _minsFocus.requestFocus(),
                            onChanged: (value) {
                              int raw = int.tryParse(value) ?? 0;
                              setState(() {
                                su = raw;
                                _calcSu();
                                if (isJrSoldier) _calcRun();
                                _calcTotal();
                              });
                            },
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          GridBox(
                            title: suScore.toString(),
                            background: suPass ? backgroundColor : failColor,
                            width: 60,
                            height: 40,
                            borderColor: Colors.white,
                            borderBottomLeft: 8,
                            borderBottomRight: 8,
                            borderTopLeft: 8,
                            borderTopRight: 8,
                          ),
                        ],
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
                            if (su > 0 && !hasSuProfile) {
                              su--;
                              _suController.text = su.toString();
                              _calcSu();
                              if (isJrSoldier) _calcRun();
                              _calcTotal();
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: PlatformSlider(
                            activeColor: primaryColor,
                            value: su.toDouble(),
                            min: 0,
                            max: 99,
                            divisions: 100,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                if (hasSuProfile) {
                                  su = 0;
                                } else {
                                  su = value.floor();
                                  _suController.text = su.toString();
                                  _calcSu();
                                  if (isJrSoldier) _calcRun();
                                  _calcTotal();
                                }
                              });
                            },
                          ),
                        ),
                        IncrementDecrementButton(
                          child: '+',
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (su < 99 && !hasSuProfile) {
                              setState(() {
                                su++;
                                _suController.text = su.toString();
                                _calcSu();
                                if (isJrSoldier) _calcRun();
                                _calcTotal();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformCheckboxListTile(
                      title: const Text('Profile'),
                      value: hasSuProfile,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: onSecondary,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(
                          () {
                            hasSuProfile = value!;
                            if (value) {
                              su = 0;
                              _suController.text = su.toString();
                            }
                            _calcSu();
                            if (isJrSoldier) _calcRun();
                            _calcTotal();
                          },
                        );
                      },
                      onIosTap: () {
                        FocusScope.of(context).unfocus();
                        setState(
                          () {
                            hasSuProfile = !hasSuProfile;
                            if (hasSuProfile) {
                              su = 0;
                              _suController.text = su.toString();
                            }
                            _calcSu();
                            if (isJrSoldier) _calcRun();
                            _calcTotal();
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MinMaxTable(
                      headers: tableHeaders,
                      values: [
                        suMin.toString(),
                        su90.toString(),
                        suMax.toString()
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.yellow,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        event,
                        style: const TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          ValueInputField(
                            width: 60,
                            controller: _minsController,
                            focusNode: _minsFocus,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => _secsFocus.requestFocus(),
                            errorText: isMinsValid ? null : '0-50',
                            onChanged: (value) {
                              int raw = int.tryParse(value) ?? -1;
                              if (raw < 0) {
                                runMins = 0;
                                isMinsValid = false;
                              } else if (raw > 50) {
                                runMins = 50;
                                isMinsValid = false;
                              } else {
                                runMins = raw;
                                isMinsValid = true;
                              }
                              _calcRun();
                              _calcTotal();
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                            child: const Text(
                              ':',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ValueInputField(
                            width: 60,
                            controller: _secsController,
                            focusNode: _secsFocus,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            errorText: isSecValid ? null : '0-59',
                            onChanged: (value) {
                              int raw = int.tryParse(value) ?? -1;
                              if (raw < 0) {
                                runSecs = 0;
                                isSecValid = false;
                              } else if (raw > 59) {
                                runSecs = 59;
                                isSecValid = false;
                              } else {
                                runSecs = raw;
                                isSecValid = true;
                              }
                              _calcRun();
                              _calcTotal();
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GridBox(
                            title: runScore.toString(),
                            background: runPass ? backgroundColor : failColor,
                            width: 60,
                            height: 40,
                            borderColor: Colors.white,
                            borderBottomLeft: 8,
                            borderBottomRight: 8,
                            borderTopLeft: 8,
                            borderTopRight: 8,
                          ),
                        ],
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
                            if (runMins > 0) {
                              runMins--;
                              _minsController.text = runMins.toString();
                              _calcRun();
                              _calcTotal();
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: PlatformSlider(
                            activeColor: primaryColor,
                            value: runMins.toDouble(),
                            min: 0,
                            max: 50,
                            divisions: 51,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                runMins = value.floor();
                                _minsController.text = runMins.toString();
                                _calcRun();
                                _calcTotal();
                              });
                            },
                          ),
                        ),
                        IncrementDecrementButton(
                          child: '+',
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (runMins < 50) {
                              setState(() {
                                runMins++;
                                _minsController.text = runMins.toString();
                                _calcRun();
                                _calcTotal();
                              });
                            }
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
                              _secsController.text = runSecs.toString();
                              _calcRun();
                              _calcTotal();
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: PlatformSlider(
                            activeColor: primaryColor,
                            value: runSecs.toDouble(),
                            min: 0,
                            max: 59,
                            divisions: 60,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                runSecs = value.floor();
                                _secsController.text = runSecs.toString();
                                _calcRun();
                                _calcTotal();
                              });
                            },
                          ),
                        ),
                        IncrementDecrementButton(
                          child: '+',
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (runSecs < 59) {
                              setState(() {
                                runSecs++;
                                _secsController.text = runSecs.toString();
                                _calcRun();
                                _calcTotal();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformCheckboxListTile(
                      title: Text('For Promotion Points'),
                      value: isJrSoldier,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: onSecondary,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        if (value!) {
                          if (hasPuProfile) puScore = 60;
                          if (hasSuProfile) suScore = 60;
                          if (event != 'Run')
                            runScore = ((puScore + suScore) / 2).floor();
                        } else {
                          if (hasPuProfile) puScore = 0;
                          if (hasSuProfile) suScore = 0;
                          if (event != 'Run') runScore = 0;
                        }
                        setState(() {
                          isJrSoldier = value;
                          _calcTotal();
                        });
                      },
                      onIosTap: () {
                        FocusScope.of(context).unfocus();
                        if (isJrSoldier) {
                          if (hasPuProfile) puScore = 60;
                          if (hasSuProfile) suScore = 60;
                          if (event != 'Run')
                            runScore = ((puScore + suScore) / 2).floor();
                        } else {
                          if (hasPuProfile) puScore = 0;
                          if (hasSuProfile) suScore = 0;
                          if (event != 'Run') runScore = 0;
                        }
                        setState(() {
                          isJrSoldier = !isJrSoldier;
                          _calcTotal();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MinMaxTable(
                      headers: tableHeaders,
                      values: [
                        runMin.toString(),
                        run90.toString(),
                        runMax.toString()
                      ],
                    ),
                  ),
                  Divider(
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
                          title: totalScore.toString(),
                          background: totalPass ? backgroundColor : failColor,
                          isTotal: true,
                          borderBottomLeft: 12.0,
                          borderBottomRight: 12.0,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PlatformButton(
                      child: const Text('Save APFT Score'),
                      onPressed: () {
                        String runSeconds = runSecs.toString().length == 1
                            ? '0$runSecs'
                            : runSecs.toString();
                        if (isPremium) {
                          Apft apft = new Apft(
                              id: null,
                              date: null,
                              rank: null,
                              name: null,
                              gender: gender.toString(),
                              age: age.toString(),
                              puRaw: pu.toString(),
                              puScore: puScore.toString(),
                              suRaw: su.toString(),
                              suScore: suScore.toString(),
                              runRaw: runMins.toString() + ':' + runSeconds,
                              runScore: runScore.toString(),
                              runEvent: event,
                              total: totalScore.toString(),
                              altPass: runPass ? 1 : 0,
                              pass: totalPass ? 1 : 0);
                          _saveApft(context, apft);
                        } else {
                          purchasesService.upgradeNeeded(context);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            if (!isPremium)
              Container(
                constraints: BoxConstraints(maxHeight: 90),
                alignment: Alignment.center,
                child: AdWidget(
                  ad: myBanner,
                ),
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
              ),
          ],
        ),
      ),
    );
  }
}
