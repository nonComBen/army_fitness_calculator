import 'dart:io';

import 'package:acft_calculator/providers/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/premium_state_provider.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../methods/theme_methods.dart';
import '../../providers/purchases_provider.dart';
import '../../services/purchases_service.dart';
import '../../widgets/grid_box.dart';
import '../../widgets/min_max_table.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/platform_widgets/platform_selection_widget.dart';
import '../../widgets/increment_decrement_button.dart';
import '../../calculators/bf_calculator.dart';
import '../../sqlite/bodyfat.dart';
import '../../widgets/platform_widgets/platform_slider.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_bodyfats_page.dart';
import '../../widgets/value_input_field.dart';

class BodyfatPage extends ConsumerStatefulWidget {
  BodyfatPage();

  static const String title = 'Body Comp Calculator';

  @override
  _BodyfatPageState createState() => _BodyfatPageState();
}

class _BodyfatPageState extends ConsumerState<BodyfatPage> {
  int age = 22, height = 68, weight = 150;
  int? bfPercent, weightMin, weightMax, percentMax, overUnder;
  double? heightDouble;
  double neck = 16.0, waist = 34.0, hip = 34.0;
  String ageGroup = '17-20';
  Object gender = 'Male';
  bool bmiPass = true,
      bfPass = true,
      isUnderWeight = false,
      isAgeValid = true,
      isHeightValid = true,
      isWeightValid = true,
      isNeckValid = true,
      isWaistValid = true,
      isHipValid = true,
      isNewVersion = false,
      is540Exempt = false;
  late SharedPreferences prefs;
  RegExp regExp = RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
  DBHelper dbHelper = DBHelper();
  late PurchasesService purchasesService;
  late BannerAd myBanner;

  final List<String> ageGroups = ['17-20', '21-27', '28-39', '40+'];

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _neckController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  final _ageFocus = FocusNode();
  final _heightFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _neckFocus = FocusNode();
  final _waistFocus = FocusNode();
  final _hipFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    purchasesService = ref.read(purchasesProvider);
    bool trackingAllowed = ref.read(trackingProvider);
    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/8950325543'
          : 'ca-app-pub-2431077176117105/5634775918',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest(nonPersonalizedAds: !trackingAllowed),
    );

    myBanner.load();

    _weightController.text = weight.toString();
    _neckController.text = neck.toString();
    _waistController.text = waist.toString();
    _hipController.text = hip.toString();

    _ageFocus.addListener(() {
      if (_ageFocus.hasFocus) {
        _ageController.selection = TextSelection(
            baseOffset: 0, extentOffset: _ageController.text.length);
      }
    });
    _heightFocus.addListener(() {
      if (_heightFocus.hasFocus) {
        _heightController.selection = TextSelection(
            baseOffset: 0, extentOffset: _heightController.text.length);
      }
    });
    _weightFocus.addListener(() {
      if (_weightFocus.hasFocus) {
        _weightController.selection = TextSelection(
            baseOffset: 0, extentOffset: _weightController.text.length);
      }
    });
    _neckFocus.addListener(() {
      if (_neckFocus.hasFocus) {
        _neckController.selection = TextSelection(
            baseOffset: 0, extentOffset: _neckController.text.length);
      }
    });
    _waistFocus.addListener(() {
      if (_waistFocus.hasFocus) {
        _waistController.selection = TextSelection(
            baseOffset: 0, extentOffset: _waistController.text.length);
      }
    });
    _hipFocus.addListener(() {
      if (_hipFocus.hasFocus) {
        _hipController.selection = TextSelection(
            baseOffset: 0, extentOffset: _hipController.text.length);
      }
    });

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender')!;
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age')!;
    }
    if (prefs.getInt('height') != null) {
      height = prefs.getInt('height')!;
    }

    _ageController.text = age.toString();
    ageGroup = getAgeGroup(age);
    heightDouble = height.toDouble();
    _heightController.text = height.toString();

    setBenchmarks();
    calcBmi();
    calcBf();
  }

  @override
  void dispose() {
    super.dispose();

    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _hipController.dispose();

    _ageFocus.dispose();
    _heightFocus.dispose();
    _weightFocus.dispose();
    _neckFocus.dispose();
    _waistFocus.dispose();
    _hipFocus.dispose();

    myBanner.dispose();
  }

  void setBenchmarks() {
    List<int> benchmarks =
        setBfBenchmarks(gender == 'Male', ageGroups.indexOf(ageGroup), height);
    setState(() {
      weightMin = benchmarks[0];
      weightMax = benchmarks[1];
      percentMax = benchmarks[2];
    });
  }

  void calcBmi() {
    setState(() {
      if (weight <= weightMax!) {
        if (weight >= weightMin!) {
          bmiPass = true;
          bfPass = true;
        } else {
          bmiPass = false;
          isUnderWeight = true;
        }
      } else {
        bmiPass = false;
        isUnderWeight = false;
        calcBf();
      }
    });
  }

  void calcBf() {
    double cirValue;
    if (!isNewVersion) {
      if (gender == 'Male') {
        cirValue = waist - neck;
      } else {
        cirValue = waist + hip - neck;
      }
    } else {
      cirValue = waist;
    }
    setState(() {
      bfPercent = getBfPercent(
        male: gender == 'Male',
        height: heightDouble,
        cirValue: cirValue,
        isNewVersion: isNewVersion,
        weight: weight,
      );
      overUnder = bfPercent! - percentMax!;
      if (overUnder! <= 0) {
        bfPass = true;
      } else
        bfPass = false;
    });
  }

  String getAgeGroup(int age) {
    if (age < 21) return '17-20';
    if (age < 28) return '21-27';
    if (age < 40) return '28-39';
    return '40+';
  }

  _saveBf(BuildContext context, Bodyfat bf) {
    final f = DateFormat('yyyyMMdd');
    final date = f.format(DateTime.now());
    final _dateController = TextEditingController(text: date);
    final _rankController = TextEditingController();
    final _nameController = TextEditingController();
    showPlatformModalBottomSheet(
      context: context,
      // isScrollControlled: true,
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
                  child: Text('Save Body Composition'),
                  onPressed: () {
                    bf.date = _dateController.text;
                    bf.rank = _rankController.text;
                    bf.name = _nameController.text;
                    if (bmiPass)
                      bf.bfPercent = bf.gender == 'Male' ? '18' : '28';
                    dbHelper.saveBodyfat(bf);
                    Navigator.pop(ctx);
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(SavedBodyfatsPage.routeName);
                  },
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
    final isPremium =
        ref.read(premiumStateProvider) || (prefs.getBool('isPremium') ?? false);
    final primaryColor = getPrimaryColor(context);
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
                      FocusScope.of(context).unfocus();
                      setState(() {
                        gender = value!;
                        setBenchmarks();
                        calcBmi();
                        calcBf();
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Age',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    ValueInputField(
                      width: 50,
                      controller: _ageController,
                      focusNode: _ageFocus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => _heightFocus.requestFocus(),
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
                        setBenchmarks();
                        calcBmi();
                        calcBf();
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
                          setBenchmarks();
                          calcBmi();
                          calcBf();
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
                            setBenchmarks();
                            calcBmi();
                            calcBf();
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
                          setBenchmarks();
                          calcBmi();
                          calcBf();
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Height',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    ValueInputField(
                      width: 50,
                      controller: _heightController,
                      focusNode: _heightFocus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => _weightFocus.requestFocus(),
                      errorText: isHeightValid ? null : '50-90',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? 0;
                        setState(() {
                          if (raw < 58) {
                            height = 58;
                            isHeightValid = false;
                          } else if (raw > 80) {
                            height = 80;
                            isHeightValid = false;
                          } else {
                            height = raw;
                            isHeightValid = true;
                          }
                          heightDouble = height.toDouble();
                          setBenchmarks();
                          calcBmi();
                          calcBf();
                        });
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
                          if (height > 58) {
                            height--;
                            _heightController.text = height.toString();
                            heightDouble = height.toDouble();
                            setBenchmarks();
                            calcBmi();
                          }
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: primaryColor,
                          value: height.toDouble(),
                          min: 58,
                          max: 80,
                          divisions: 23,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              height = value.floor();
                              _heightController.text = height.toString();
                              heightDouble = height.toDouble();
                              setBenchmarks();
                              calcBmi();
                              calcBf();
                            });
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (height < 80) {
                            setState(() {
                              height++;
                              _heightController.text = height.toString();
                              heightDouble = height.toDouble();
                              setBenchmarks();
                              calcBmi();
                              calcBf();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.yellow,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Weight',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    ValueInputField(
                      width: 60,
                      controller: _weightController,
                      focusNode: _weightFocus,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      errorText: isWeightValid ? null : '50-350',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? 0;
                        setState(() {
                          if (raw < 50) {
                            weight = 50;
                            isWeightValid = false;
                          } else if (raw > 350) {
                            weight = 350;
                            isWeightValid = false;
                          } else {
                            weight = raw;
                            isWeightValid = true;
                          }
                          calcBmi();
                          if (isNewVersion) {
                            calcBf();
                          }
                        });
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
                          if (weight > 50) {
                            weight--;
                            _weightController.text = weight.toString();
                            calcBmi();
                            if (isNewVersion) {
                              calcBf();
                            }
                          }
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: primaryColor,
                          value: weight.toDouble(),
                          min: 50,
                          max: 350,
                          divisions: 200,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              weight = value.floor();
                              _weightController.text = weight.toString();
                              calcBmi();
                              if (isNewVersion) {
                                calcBf();
                              }
                            });
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (weight < 350) {
                            setState(() {
                              weight++;
                              _weightController.text = weight.toString();
                              calcBmi();
                              if (isNewVersion) {
                                calcBf();
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.yellow,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MinMaxTable(
                    headers: ['Min', 'Max', 'Pass/Fail'],
                    values: [
                      weightMin.toString(),
                      weightMax.toString(),
                      bmiPass ? 'Pass' : 'Fail'
                    ],
                  ),
                ),
                if (isUnderWeight)
                  Center(
                    child: const Text(
                      'Underweight',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (!bmiPass && !isUnderWeight)
                  Column(
                    children: <Widget>[
                      Divider(
                        color: Colors.yellow,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformSelectionWidget(
                          titles: [Text('Not Exempt'), Text('540 ACFT Exempt')],
                          values: [false, true],
                          groupValue: is540Exempt,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              is540Exempt = value! as bool;
                              calcBf();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformSelectionWidget(
                          titles: [Text('Old Version'), Text('New Version')],
                          values: [false, true],
                          groupValue: isNewVersion,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isNewVersion = value! as bool;
                              calcBf();
                            });
                          },
                        ),
                      ),
                      if (!is540Exempt)
                        Column(
                          children: [
                            if (!isNewVersion)
                              const Text(
                                'Height to nearest 1/2 in.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (!isNewVersion)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IncrementDecrementButton(
                                      child: '- 0.5',
                                      width: 72,
                                      fontSize: 16,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (heightDouble! > 58.0) {
                                          if (!(heightDouble ==
                                              (height.toDouble() - 0.5))) {
                                            setState(() {
                                              heightDouble =
                                                  heightDouble! - 0.5;
                                            });
                                            calcBf();
                                          }
                                        }
                                      },
                                    ),
                                    GridBox(
                                      borderBottomLeft: 12.0,
                                      borderBottomRight: 12.0,
                                      borderTopLeft: 12.0,
                                      borderTopRight: 12.0,
                                      title: heightDouble.toString(),
                                      width: 60,
                                      height: 40,
                                    ),
                                    IncrementDecrementButton(
                                      child: '+ 0.5',
                                      width: 72,
                                      fontSize: 16,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (heightDouble! < 80.0) {
                                          if (!(heightDouble ==
                                              (height.toDouble() + 0.5))) {
                                            setState(() {
                                              heightDouble =
                                                  heightDouble! + 0.5;
                                            });
                                            calcBf();
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            if (!isNewVersion)
                              Divider(
                                color: Colors.yellow,
                              ),
                            if (!isNewVersion)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Neck',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ValueInputField(
                                    width: 60,
                                    controller: _neckController,
                                    focusNode: _neckFocus,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        _waistFocus.requestFocus(),
                                    errorText: isNeckValid ? null : '10-30',
                                    onChanged: (value) {
                                      double raw =
                                          double.tryParse(value) ?? 10.0;
                                      setState(() {
                                        if (raw < 10) {
                                          neck = 10;
                                          isNeckValid = false;
                                        } else if (raw > 30) {
                                          neck = 30;
                                          isNeckValid = false;
                                        } else {
                                          neck = (raw * 2).round() / 2;
                                          isNeckValid = true;
                                        }
                                        calcBf();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            if (!isNewVersion)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    IncrementDecrementButton(
                                      child: '-',
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (neck > 10) {
                                          neck = neck - 0.5;
                                          _neckController.text =
                                              neck.toString();
                                          calcBf();
                                        }
                                      },
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: PlatformSlider(
                                        activeColor: primaryColor,
                                        value: neck,
                                        min: 10,
                                        max: 30,
                                        divisions: 40,
                                        onChanged: (value) {
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            neck = value;
                                            _neckController.text =
                                                neck.toString();
                                            calcBf();
                                          });
                                        },
                                      ),
                                    ),
                                    IncrementDecrementButton(
                                      child: '+',
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (neck < 30) {
                                          setState(() {
                                            neck = neck + 0.5;
                                            _neckController.text =
                                                neck.toString();
                                            calcBf();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            Divider(
                              color: Colors.yellow,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Waist',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                ValueInputField(
                                  width: 60,
                                  controller: _waistController,
                                  focusNode: _waistFocus,
                                  textInputAction: gender == 'Female'
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  onEditingComplete: () => gender == 'Female'
                                      ? _hipFocus.requestFocus()
                                      : FocusScope.of(context).unfocus(),
                                  errorText: isWaistValid ? null : '20-50',
                                  onChanged: (value) {
                                    double raw = double.tryParse(value) ?? 0.0;
                                    setState(() {
                                      if (raw < 20) {
                                        waist = 20;
                                        isWaistValid = false;
                                      } else if (raw > 50) {
                                        waist = 50;
                                        isWaistValid = false;
                                      } else {
                                        waist = (raw * 2).round() / 2;
                                        isWaistValid = true;
                                      }
                                      calcBf();
                                    });
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
                                      if (waist > 20) {
                                        waist = waist - 0.5;
                                        _waistController.text =
                                            waist.toString();
                                        calcBf();
                                      }
                                    },
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: PlatformSlider(
                                      activeColor: primaryColor,
                                      value: waist,
                                      min: 20,
                                      max: 50,
                                      divisions: 60,
                                      onChanged: (value) {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          waist = value;
                                          _waistController.text =
                                              waist.toString();
                                          calcBf();
                                        });
                                      },
                                    ),
                                  ),
                                  IncrementDecrementButton(
                                    child: '+',
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (waist < 50) {
                                        setState(() {
                                          waist = waist + 0.5;
                                          _waistController.text =
                                              waist.toString();
                                          calcBf();
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (gender == 'Female' && !isNewVersion)
                              Divider(
                                color: Colors.yellow,
                              ),
                            if (gender == 'Female' && !isNewVersion)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Hip',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ValueInputField(
                                    width: 60,
                                    controller: _hipController,
                                    focusNode: _hipFocus,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).unfocus(),
                                    errorText: isHipValid ? null : '20-50',
                                    onChanged: (value) {
                                      double raw =
                                          double.tryParse(value) ?? 0.0;
                                      setState(() {
                                        if (raw < 20) {
                                          hip = 20;
                                          isHipValid = false;
                                        } else if (raw > 50) {
                                          hip = 50;
                                          isHipValid = false;
                                        } else {
                                          hip = (raw * 2).round() / 2;
                                          isHipValid = true;
                                        }
                                        calcBf();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            if (gender == 'Female' && !isNewVersion)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    IncrementDecrementButton(
                                      child: '-',
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (hip > 20) {
                                          hip = hip - 0.5;
                                          _hipController.text = hip.toString();
                                          calcBf();
                                        }
                                      },
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: PlatformSlider(
                                        activeColor: primaryColor,
                                        value: hip,
                                        min: 20,
                                        max: 50,
                                        divisions: 60,
                                        onChanged: (value) {
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            hip = value;
                                            _hipController.text =
                                                hip.toString();
                                            calcBf();
                                          });
                                        },
                                      ),
                                    ),
                                    IncrementDecrementButton(
                                      child: '+',
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (hip < 50) {
                                          setState(() {
                                            hip = hip + 0.5;
                                            _hipController.text =
                                                hip.toString();
                                            calcBf();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MinMaxTable(
                                headers: ['BF %', 'Max %', 'Pass/Fail'],
                                values: [
                                  bfPercent.toString(),
                                  percentMax.toString(),
                                  bfPass ? 'Pass' : 'Fail',
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: const Text('Save Body Comp Score'),
                    onPressed: () {
                      if (isPremium) {
                        Bodyfat bf = new Bodyfat(
                          id: null,
                          date: null,
                          rank: null,
                          name: null,
                          gender: gender.toString(),
                          age: age.toString(),
                          height: height.toString(),
                          weight: weight.toString(),
                          maxWeight: weightMax.toString(),
                          bmiPass: bmiPass ? 1 : 0,
                          heightDouble: heightDouble.toString(),
                          neck: (bmiPass || is540Exempt || isNewVersion)
                              ? 'N/A'
                              : neck.toString(),
                          waist: (bmiPass || is540Exempt)
                              ? 'N/A'
                              : waist.toString(),
                          hip: (gender == 'Male' ||
                                  bmiPass ||
                                  is540Exempt ||
                                  isNewVersion)
                              ? 'N/A'
                              : hip.toString(),
                          bfPercent: (bmiPass || is540Exempt)
                              ? 'N/A'
                              : bfPercent.toString(),
                          maxPercent: percentMax.toString(),
                          overUnder: (bmiPass || is540Exempt)
                              ? 'N/A'
                              : overUnder.toString(),
                          bfPass: (bfPass || is540Exempt) ? 1 : 0,
                          isNewVersion: isNewVersion ? 1 : 0,
                          is540Exempt: is540Exempt ? 1 : 0,
                        );
                        _saveBf(context, bf);
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
    );
  }
}
