import 'dart:io';

import 'package:acft_calculator/calculators/whtr_calculator.dart';

import '../../sqlite/w_ht_ratio.dart';
import '../saved_pages/saved_whtr_page.dart';
import '/methods/is_valid_date.dart';
import '/providers/tracking_provider.dart';
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
import '../../widgets/button_text.dart';
import '../../widgets/min_max_table.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../sqlite/db_helper.dart';
import '../../widgets/increment_decrement_button.dart';
import '../../widgets/platform_widgets/platform_slider.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../../widgets/value_input_field.dart';

class BodyfatPage extends ConsumerStatefulWidget {
  BodyfatPage();

  static const String title = 'Body Comp Calculator';

  @override
  _BodyfatPageState createState() => _BodyfatPageState();
}

class _BodyfatPageState extends ConsumerState<BodyfatPage> {
  double heightDouble = 68.5;
  double waist = 34.0, waistMax = 34.0;
  bool wHtRPass = true, isHeightValid = true, isWaistValid = true;
  double wHtR = 0.55;
  late SharedPreferences prefs;
  late PurchasesService purchasesService;
  late BannerAd myBanner;

  final _heightController = TextEditingController();
  final _waistController = TextEditingController();

  final _heightFocus = FocusNode();
  final _waistFocus = FocusNode();

  @override
  void initState() {
    super.initState();
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

    _waistController.text = waist.toString();

    _heightFocus.addListener(() {
      if (_heightFocus.hasFocus) {
        _heightController.selection = TextSelection(
            baseOffset: 0, extentOffset: _heightController.text.length);
      }
    });
    _waistFocus.addListener(() {
      if (_waistFocus.hasFocus) {
        _waistController.selection = TextSelection(
            baseOffset: 0, extentOffset: _waistController.text.length);
      }
    });

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getDouble('heightDouble') != null) {
      heightDouble = prefs.getDouble('heightDouble')!;
    }

    _heightController.text = heightDouble.toString();

    setBenchmarks();
    calcWHtR();
  }

  @override
  void dispose() {
    super.dispose();

    _heightController.dispose();
    _waistController.dispose();

    _heightFocus.dispose();
    _waistFocus.dispose();

    myBanner.dispose();
  }

  void setBenchmarks() {
    setState(() {
      waistMax = setWHtRBenchmarks(heightDouble);
    });
  }

  void calcWHtR() {
    setState(() {
      wHtR = getWHtR(
        height: heightDouble,
        waist: waist,
      );
      if (wHtR < 0.55) {
        wHtRPass = true;
      } else
        wHtRPass = false;
    });
  }

  _saveBf(BuildContext context, WHtR wHtR) {
    DBHelper dbHelper = DBHelper();
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
                  child: ButtonText(text: 'Save Body Composition'),
                  onPressed: () async {
                    wHtR.date = _dateController.text;
                    wHtR.rank = _rankController.text;
                    wHtR.name = _nameController.text;
                    await dbHelper.saveWHtR(wHtR);
                    Navigator.pop(ctx);
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(SavedWHtRsPage.routeName);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Height',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    ValueInputField(
                      width: 70,
                      controller: _heightController,
                      focusNode: _heightFocus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => _waistFocus.requestFocus(),
                      errorText: isHeightValid ? null : '50-90',
                      onChanged: (value) {
                        double raw = double.tryParse(value) ?? 0;
                        setState(() {
                          if (raw < 58) {
                            heightDouble = 58;
                            isHeightValid = false;
                          } else if (raw > 80) {
                            heightDouble = 80;
                            isHeightValid = false;
                          } else {
                            heightDouble = raw;
                            isHeightValid = true;
                          }
                          setBenchmarks();
                          calcWHtR();
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
                          if (heightDouble > 58) {
                            heightDouble = heightDouble - 0.5;
                            _heightController.text = heightDouble.toString();
                            setBenchmarks();
                          }
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: PlatformSlider(
                          activeColor: primaryColor,
                          value: heightDouble,
                          min: 58,
                          max: 80,
                          divisions: 44,
                          onChanged: (value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              heightDouble = value;
                              _heightController.text = heightDouble.toString();
                              setBenchmarks();
                              calcWHtR();
                            });
                          },
                        ),
                      ),
                      IncrementDecrementButton(
                        child: '+',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (heightDouble < 80) {
                            setState(() {
                              heightDouble = heightDouble + 0.5;
                              _heightController.text = heightDouble.toString();
                              setBenchmarks();
                              calcWHtR();
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
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    ValueInputField(
                      width: 70,
                      controller: _waistController,
                      focusNode: _waistFocus,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
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
                          calcWHtR();
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
                            _waistController.text = waist.toString();
                            calcWHtR();
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
                              _waistController.text = waist.toString();
                              calcWHtR();
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
                              _waistController.text = waist.toString();
                              calcWHtR();
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
                    headers: ['Max Waist', 'Pass/Fail'],
                    values: [
                      waistMax.toString(),
                      wHtRPass ? 'Pass' : 'Fail',
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PlatformButton(
              child: ButtonText(text: 'Save Waist Height Ratio'),
              onPressed: () {
                if (isPremium) {
                  WHtR ratio = new WHtR(
                    id: null,
                    date: null,
                    rank: null,
                    name: null,
                    height: heightDouble.toString(),
                    waist: waist.toString(),
                    wHtRatio: wHtR.toString(),
                    whtPass: wHtRPass ? 1 : 0,
                  );
                  _saveBf(context, ratio);
                } else {
                  purchasesService = ref.read(purchasesProvider);
                  purchasesService.upgradeNeeded(context);
                }
              },
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
