import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../sqlite/db_helper.dart';
import '../sqlite/acft.dart';
import '../calculators/2mr_calculator.dart';
import '../calculators/acft_calculator.dart';
import '../calculators/spt_calculator.dart';
import '../calculators/hrp_calculator.dart';
import '../calculators/mdl_calculator.dart';
import '../calculators/plk_calculator.dart';
import '../calculators/sdc_calculator.dart';
import '../providers/shared_preferences_provider.dart';
import 'saved_pages/saved_acfts_page.dart';
import '../widgets/formatted_drop_down.dart';
import '../widgets/formatted_radio.dart';
import '../widgets/grid_box.dart';
import '../widgets/increment_decrement_button.dart';
import '../constants/pt_age_group_table.dart';
import '../constants/acft_aerobic_event_table.dart';
import '../widgets/value_input_field.dart';

class AcftPage extends ConsumerStatefulWidget {
  AcftPage(this.isPremium, this.upgradeNeeded);
  final bool isPremium;
  final VoidCallback upgradeNeeded;

  @override
  AcftPageState createState() => AcftPageState();
}

class AcftPageState extends ConsumerState<AcftPage> {
  int age,
      mdlRaw,
      hrpRaw,
      plankMins,
      plankSecs,
      sdcMins,
      sdcSecs,
      runMins,
      runSecs,
      mdlScore,
      sptScore,
      hrpScore,
      sdcScore,
      plankScore,
      runScore,
      total;
  bool isAgeValid,
      isMdlValid,
      isSptValid,
      isHrpValid,
      isSdcMinsValid,
      isSdcSecsValid,
      isPlankMinsValid,
      isPlankSecsValid,
      isRunMinsValid,
      isRunSecsValid,
      mdlPass,
      sptPass,
      hrpPass,
      sdcPass,
      plkPass,
      runPass,
      totalPass;
  double sptRaw;
  static String ageGroup, gender;
  String mdlMinimum,
      mdl90,
      mdlMax,
      sptMinimum,
      spt90,
      sptMax,
      hrpMinimum,
      hrp90,
      hrpMax,
      sdcMinimum,
      sdc90,
      sdcMax,
      plkMinimum,
      plk90,
      plkMax,
      runMinimum,
      run90,
      runMax,
      aerobicEvent;
  List<String> mdlBenchmarks,
      sptBenchmarks,
      hrpBenchmarks,
      sdcBenchmarks,
      plkBenchmarks,
      runBenchmarks,
      altBenchmarks;
  SharedPreferences prefs;
  DBHelper dbHelper;
  RegExp regExp;

  final _ageController = new TextEditingController();
  final _mdlController = new TextEditingController();
  final _sptController = new TextEditingController();
  final _hrpController = new TextEditingController();
  final _sdcMinsController = new TextEditingController();
  final _sdcSecsController = new TextEditingController();
  final _plankMinsController = new TextEditingController();
  final _plankSecsController = new TextEditingController();
  final _runMinsController = new TextEditingController();
  final _runSecsController = new TextEditingController();

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

    mdlMinimum = mdlBenchmarks[0];
    mdl90 = mdlBenchmarks[1];
    mdlMax = mdlBenchmarks[2];
    sptMinimum = sptBenchmarks[0];
    spt90 = sptBenchmarks[1];
    sptMax = sptBenchmarks[2];
    hrpMinimum = hrpBenchmarks[0];
    hrp90 = hrpBenchmarks[1];
    hrpMax = hrpBenchmarks[2];
    sdcMinimum = sdcBenchmarks[0];
    sdc90 = sdcBenchmarks[1];
    sdcMax = sdcBenchmarks[2];
    plkMinimum = plkBenchmarks[0];
    plk90 = plkBenchmarks[1];
    plkMax = plkBenchmarks[2];

    switch (aerobicEvent) {
      case "Run":
        runMinimum = runBenchmarks[0];
        run90 = runBenchmarks[1];
        runMax = runBenchmarks[2];
        break;
      case "Walk":
        runMinimum = altBenchmarks[0];
        run90 = '-';
        runMax = '-';
        break;
      case "Bike":
        runMinimum = altBenchmarks[1];
        run90 = '-';
        runMax = '-';
        break;
      case "Swim":
        runMinimum = altBenchmarks[2];
        run90 = '-';
        runMax = '-';
        break;
      case "Row":
        runMinimum = altBenchmarks[2];
        run90 = '-';
        runMax = '-';
        break;
    }
    setState(() {});
  }

  int getTimeAsInt(int mins, int secs) {
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
      total = mdlScore + sptScore + hrpScore + sdcScore + plankScore + runScore;
      mdlPass = mdlScore >= 60;
      sptPass = sptScore >= 60;
      hrpPass = hrpScore >= 60;
      sdcPass = sdcScore >= 60;
      plkPass = plankScore >= 60;
      runPass = runScore >= 60;

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
    showModalBottomSheet(
      context: context,
      builder: ((ctx) => Container(
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
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          regExp.hasMatch(value) ? null : 'Use yyyyMMdd Format',
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(ctx).nextFocus(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _rankController,
                      decoration: const InputDecoration(labelText: 'Rank'),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => FocusScope.of(ctx).nextFocus(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(ctx).unfocus(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Text('Save'),
                      onPressed: (() {
                        acft.date = _dateController.text;
                        acft.rank = _rankController.text;
                        acft.name = _nameController.text;
                        dbHelper.saveAcft(acft);
                        Navigator.of(ctx).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SavedAcftsPage()));
                      }),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

    mdlRaw = 300;
    sptRaw = 11.0;
    hrpRaw = 50;
    sdcMins = 1;
    sdcSecs = 50;
    plankMins = 3;
    plankSecs = 48;
    runMins = 15;
    runSecs = 0;

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

    isAgeValid = true;
    isMdlValid = true;
    isSptValid = true;
    isHrpValid = true;
    isSdcMinsValid = true;
    isSdcSecsValid = true;
    isPlankMinsValid = true;
    isPlankSecsValid = true;
    isRunMinsValid = true;
    isRunSecsValid = true;

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('acft_event') != null) {
      aerobicEvent = prefs.getString('acft_event');
    } else {
      aerobicEvent = 'Run';
    }
    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender');
    } else {
      gender = 'Male';
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age');
    } else {
      age = 22;
    }
    setAgeGroup();

    _ageController.text = age.toString();

    calcAll();

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final failColor = Theme.of(context).colorScheme.error;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FormattedRadio(
                titles: ['M', 'F'],
                values: ['Male', 'Female'],
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    gender = value;
                    calcAll();
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Age',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
                    child: Slider(
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
            FormattedDropDown(
              label: 'Aerobic Event',
              value: aerobicEvent,
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
            Divider(
              color: Colors.yellow,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Max Deadlift',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                ValueInputField(
                  width: 70,
                  controller: _mdlController,
                  focusNode: _mdlFocus,
                  onEditingComplete: () => _sptFocus.requestFocus(),
                  errorText: isMdlValid ? null : '60-400',
                  onChanged: (value) {
                    int raw = int.tryParse(value) ?? 0;
                    if (raw > 400) {
                      isMdlValid = false;
                      mdlRaw = 400;
                    } else if (raw < 60) {
                      isMdlValid = false;
                      mdlRaw = 60;
                    } else {
                      mdlRaw = raw;
                      isMdlValid = true;
                    }
                    mdlScore = getMdlScore(mdlRaw,
                        ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    calcTotal();
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
                      if (mdlRaw > 60) {
                        mdlRaw = mdlRaw - 10;
                        calcTotal();
                      } else {
                        mdlRaw = 60;
                      }
                      _mdlController.text = mdlRaw.toString();
                      isMdlValid = true;
                      mdlScore = getMdlScore(mdlRaw,
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: primaryColor,
                      value: mdlRaw.toDouble(),
                      min: 60,
                      max: 400,
                      divisions: 34,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        mdlRaw = value.floor();
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
                      if (mdlRaw < 400) {
                        mdlRaw = mdlRaw + 10;
                      } else {
                        mdlRaw = 400;
                      }
                      _mdlController.text = mdlRaw.toString();
                      mdlScore = getMdlScore(mdlRaw,
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      isMdlValid = true;
                      calcTotal();
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
                  'Standing Power Throw',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                ValueInputField(
                  width: 70,
                  controller: _sptController,
                  focusNode: _sptFocus,
                  onEditingComplete: () => _hrpFocus.requestFocus(),
                  errorText: isSptValid ? null : '3.3-14.0',
                  onChanged: (value) {
                    double raw = double.tryParse(value) ?? 0;
                    if (raw > 14.0) {
                      isSptValid = false;
                      sptRaw = 14.0;
                    } else if (raw < 3.3) {
                      isSptValid = false;
                      sptRaw = 3.3;
                    } else {
                      sptRaw = raw;
                      isSptValid = true;
                    }
                    sptScore = getSptScore(sptRaw,
                        ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    calcTotal();
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
                      if (sptRaw > 3.3) {
                        sptRaw = double.tryParse(
                                (sptRaw - 0.1).toStringAsFixed(1)) ??
                            sptRaw - 0.1;
                      } else {
                        sptRaw = 3.3;
                      }
                      _sptController.text = sptRaw.toString();
                      isSptValid = true;
                      sptScore = getSptScore(sptRaw,
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: sptRaw,
                      min: 3.3,
                      max: 14.0,
                      divisions: 108,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        sptRaw = (value * 10).round() / 10;
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
                      if (sptRaw < 14.0) {
                        sptRaw = double.tryParse(
                                (sptRaw + 0.1).toStringAsFixed(1)) ??
                            sptRaw + 0.1;
                      } else {
                        sptRaw = 14.0;
                      }
                      _sptController.text = sptRaw.toString();
                      isSptValid = true;
                      sptScore = getSptScore(sptRaw,
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
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
                  'Hand Release Push Ups',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                ValueInputField(
                  controller: _hrpController,
                  focusNode: _hrpFocus,
                  onEditingComplete: () => _sdcMinsFocus.requestFocus(),
                  errorText: isHrpValid ? null : '0-80',
                  onChanged: (value) {
                    int raw = int.tryParse(value) ?? -1;
                    if (raw > 80) {
                      isHrpValid = false;
                      hrpRaw = 80;
                    } else if (raw < 0) {
                      isHrpValid = false;
                      hrpRaw = 0;
                    } else {
                      hrpRaw = raw;
                      isHrpValid = true;
                    }
                    hrpScore = getHrpScore(hrpRaw,
                        ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    calcTotal();
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
                      if (hrpRaw > 0) {
                        hrpRaw--;
                      } else {
                        hrpRaw = 0;
                      }
                      _hrpController.text = hrpRaw.toString();
                      isHrpValid = true;
                      hrpScore = getHrpScore(hrpRaw,
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: hrpRaw.toDouble(),
                      min: 0,
                      max: 80,
                      divisions: 81,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        hrpRaw = value.floor();
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
                      if (hrpRaw < 80) {
                        hrpRaw++;
                      } else {
                        hrpRaw = 80;
                      }
                      _hrpController.text = hrpRaw.toString();
                      isHrpValid = true;
                      hrpScore = getHrpScore(hrpRaw,
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
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
                  'Sprint-Drag-Carry',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    ValueInputField(
                      controller: _sdcMinsController,
                      focusNode: _sdcMinsFocus,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      errorText: isSdcMinsValid ? null : '0-5',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? -1;
                        if (raw < 0) {
                          isSdcMinsValid = false;
                          sdcMins = 0;
                        } else if (raw > 5) {
                          isSdcMinsValid = false;
                          sdcMins = 5;
                        } else {
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
                          isSdcSecsValid = false;
                          sdcSecs = 59;
                        } else if (raw < 0) {
                          isSdcSecsValid = false;
                          sdcSecs = 0;
                        } else {
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
                      sdcScore = getSdcScore(getTimeAsInt(sdcMins, sdcSecs),
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: sdcMins.toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 6,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        sdcMins = value.floor();
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
                      if (sdcMins < 5) {
                        sdcMins++;
                      } else {
                        sdcMins = 5;
                      }
                      _sdcMinsController.text = sdcMins.toString();
                      isSdcMinsValid = true;
                      sdcScore = getSdcScore(getTimeAsInt(sdcMins, sdcSecs),
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      sdcScore = getSdcScore(getTimeAsInt(sdcMins, sdcSecs),
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: sdcSecs.toDouble(),
                      min: 0,
                      max: 59,
                      divisions: 60,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        sdcSecs = value.floor();
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
                      if (sdcSecs < 59) {
                        sdcSecs++;
                      } else {
                        sdcSecs = 59;
                      }
                      _sdcSecsController.text = sdcSecs.toString();
                      isSdcSecsValid = true;
                      sdcScore = getSdcScore(getTimeAsInt(sdcMins, sdcSecs),
                          ptAgeGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
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
                Text(
                  'Plank',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    ValueInputField(
                      controller: _plankMinsController,
                      focusNode: _plkMinsFocus,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      errorText: isPlankMinsValid ? null : '0-4',
                      onChanged: (value) {
                        int raw = int.tryParse(value) ?? -1;
                        if (raw < 0) {
                          isPlankMinsValid = false;
                          plankMins = 0;
                        } else if (raw > 4) {
                          isPlankMinsValid = false;
                          plankMins = 4;
                        } else {
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
                          isPlankSecsValid = false;
                          plankSecs = 59;
                        } else if (raw < 0) {
                          isPlankSecsValid = false;
                          plankSecs = 0;
                        } else {
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
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: plankMins.toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 5,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        plankMins = value.floor();
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
                      if (plankMins < 4) {
                        plankMins++;
                      } else {
                        plankMins = 4;
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
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: plankSecs.toDouble(),
                      min: 0,
                      max: 59,
                      divisions: 60,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        plankSecs = value.floor();
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
                      if (plankSecs < 59) {
                        plankSecs++;
                      } else {
                        plankSecs = 59;
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
            Divider(
              color: Colors.yellow,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  aerobicEvent,
                  style: const TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.bold),
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
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
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
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
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
            Divider(
              color: Colors.yellow,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 5,
                childAspectRatio: width / 180,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  GridBox(
                    title: 'Event',
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'Min',
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: '90%',
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'Max',
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'Score',
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'MDL',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: mdlMinimum,
                  ),
                  GridBox(
                    title: mdl90,
                  ),
                  GridBox(
                    title: mdlMax,
                  ),
                  GridBox(
                    title: mdlScore.toString(),
                    background: mdlPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'SPT',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: sptMinimum,
                  ),
                  GridBox(
                    title: spt90,
                  ),
                  GridBox(
                    title: sptMax,
                  ),
                  GridBox(
                    title: sptScore.toString(),
                    background: sptPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'HRP',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: hrpMinimum,
                  ),
                  GridBox(
                    title: hrp90,
                  ),
                  GridBox(
                    title: hrpMax,
                  ),
                  GridBox(
                    title: hrpScore.toString(),
                    background: hrpPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'SDC',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: sdcMinimum,
                  ),
                  GridBox(
                    title: sdc90,
                  ),
                  GridBox(
                    title: sdcMax,
                  ),
                  GridBox(
                    title: sdcScore.toString(),
                    background: sdcPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'PLK',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: plkMinimum,
                  ),
                  GridBox(
                    title: plk90,
                  ),
                  GridBox(
                    title: plkMax,
                  ),
                  GridBox(
                    title: plankScore.toString(),
                    background: plkPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: '2MR',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: runMinimum,
                  ),
                  GridBox(
                    title: run90,
                  ),
                  GridBox(
                    title: runMax,
                  ),
                  GridBox(
                    title: runScore.toString(),
                    background: runPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'Total',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(),
                  GridBox(),
                  GridBox(),
                  GridBox(
                    title: total.toString(),
                    background: totalPass ? backgroundColor : failColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary)),
                child: const Text('Save ACFT Score'),
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
                  if (widget.isPremium) {
                    Acft acft = new Acft(
                        id: null,
                        date: null,
                        rank: null,
                        name: null,
                        gender: gender,
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
                        runEvent: aerobicEvent,
                        total: total.toString(),
                        altPass: runPass ? 1 : 0,
                        pass: totalPass ? 1 : 0);
                    _saveAcft(context, acft);
                  } else {
                    widget.upgradeNeeded();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
