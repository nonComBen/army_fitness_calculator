import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import './sqlite/dbHelper.dart';
import './sqlite/acft.dart';
import './calculators/2mr_calculator.dart';
import './calculators/acftCalculator.dart';
import './calculators/spt_calculator.dart';
import './calculators/hrp_calculator.dart';
import './calculators/mdl_calculator.dart';
import './calculators/plk_calculator.dart';
import './calculators/sdc_calculator.dart';
import './providers/shared_preferences_provider.dart';
import './savedPages/savedAcftsPage.dart';
import './widgets/formatted_drop_down.dart';
import './widgets/formatted_radio.dart';
import './widgets/grid_box.dart';
import './widgets/increment_decrement_button.dart';

class AcftPage extends ConsumerStatefulWidget {
  AcftPage(this.isPremium, this.upgradeNeeded);
  final bool isPremium;
  final VoidCallback upgradeNeeded;

  @override
  _AcftPageState createState() => _AcftPageState();
}

class _AcftPageState extends ConsumerState<AcftPage> {
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
  bool ageValid,
      mdlValid,
      sptValid,
      hrpValid,
      sdcMinValid,
      sdcSecValid,
      plankMinsValid,
      plankSecsValid,
      runMinValid,
      runSecValid,
      mdlPass,
      sptPass,
      hrpPass,
      sdcPass,
      plkPass,
      runPass,
      totalPass,
      altEventWarning;
  double sptRaw;
  String ageGroup,
      mdlMin,
      mdl90,
      mdlMax,
      sptMin,
      spt90,
      sptMax,
      hrpMin,
      hrp90,
      hrpMax,
      sdcMin,
      sdc90,
      sdcMax,
      plkMin,
      plk90,
      plkMax,
      runMin,
      run90,
      runMax,
      event,
      gender;
  List<String> mdlBMs, sptBMs, hrpBMs, sdcBMs, plkBMs, runBMs, altBMs;
  SharedPreferences prefs;
  DBHelper dbHelper;
  RegExp regExp;

  final _ageController = new TextEditingController();
  final _mdlController = new TextEditingController();
  final _sptController = new TextEditingController();
  final _hrpController = new TextEditingController();
  final _sdcMinController = new TextEditingController();
  final _sdcSecController = new TextEditingController();
  final _plankMinController = new TextEditingController();
  final _plankSecController = new TextEditingController();
  final _runMinController = new TextEditingController();
  final _runSecController = new TextEditingController();

  final _ageFocus = FocusNode();
  final _mdlFocus = FocusNode();
  final _sptFocus = FocusNode();
  final _hrpFocus = FocusNode();
  final _sdcFocus = FocusNode();
  final _sdcSecFocus = FocusNode();
  final _plkFocus = FocusNode();
  final _plkSecFocus = FocusNode();
  final _runFocus = FocusNode();
  final _runSecFocus = FocusNode();

  List<String> events = ['Run', 'Walk', 'Bike', 'Swim', 'Row'];
  List<String> ageGroups = [
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

  void setBenchmarks() {
    mdlBMs = getMdlBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");
    sptBMs = getSptBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");
    hrpBMs = getHrpBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");
    sdcBMs = getSdcBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");
    plkBMs = getPlkBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");
    runBMs = get2mrBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");
    altBMs = getAltBenchmarks(ageGroups.indexOf(ageGroup), gender == "Male");

    mdlMin = mdlBMs[0];
    mdl90 = mdlBMs[1];
    mdlMax = mdlBMs[2];
    sptMin = sptBMs[0];
    spt90 = sptBMs[1];
    sptMax = sptBMs[2];
    hrpMin = hrpBMs[0];
    hrp90 = hrpBMs[1];
    hrpMax = hrpBMs[2];
    sdcMin = sdcBMs[0];
    sdc90 = sdcBMs[1];
    sdcMax = sdcBMs[2];
    plkMin = plkBMs[0];
    plk90 = plkBMs[1];
    plkMax = plkBMs[2];

    switch (event) {
      case "Run":
        runMin = runBMs[0];
        run90 = runBMs[1];
        runMax = runBMs[2];
        break;
      case "Walk":
        runMin = altBMs[0];
        run90 = '-';
        runMax = '-';
        break;
      case "Bike":
        runMin = altBMs[1];
        run90 = '-';
        runMax = '-';
        break;
      case "Swim":
        runMin = altBMs[2];
        run90 = '-';
        runMax = '-';
        break;
      case "Row":
        runMin = altBMs[2];
        run90 = '-';
        runMax = '-';
        break;
    }
    setState(() {});
  }

  int getIntTime(int mins, int secs) {
    String secString =
        secs.toString().length == 2 ? secs.toString() : '0' + secs.toString();
    return int.tryParse(mins.toString() + secString) ?? 0;
  }

  void calcRunScore() {
    int time = getIntTime(runMins, runSecs);
    if (event == 'Run') {
      runScore =
          get2mrScore(time, ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
    } else {
      int min = int.tryParse(runMin.replaceRange(2, 3, "")) ?? 0;
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

      if (event != 'Run') {
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
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 8),
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
    _sdcMinController.dispose();
    _sdcSecController.dispose();
    _plankMinController.dispose();
    _plankSecController.dispose();
    _runMinController.dispose();
    _runSecController.dispose();

    _ageFocus.dispose();
    _mdlFocus.dispose();
    _sptFocus.dispose();
    _hrpFocus.dispose();
    _sdcFocus.dispose();
    _sdcSecFocus.dispose();
    _plkFocus.dispose();
    _plkSecFocus.dispose();
    _runFocus.dispose();
    _runSecFocus.dispose();
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
    _sdcMinController.text = sdcMins.toString();
    _sdcSecController.text = sdcSecs.toString();
    _plankMinController.text = plankMins.toString();
    _plankSecController.text = plankSecs.toString();
    _runMinController.text = runMins.toString();
    _runSecController.text = runSecs.toString();

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
    _sdcFocus.addListener(() {
      if (_sdcFocus.hasFocus) {
        _sdcMinController.selection = TextSelection(
            baseOffset: 0, extentOffset: _sdcMinController.text.length);
      }
    });
    _sdcSecFocus.addListener(() {
      if (_sdcSecFocus.hasFocus) {
        _sdcSecController.selection = TextSelection(
            baseOffset: 0, extentOffset: _sdcSecController.text.length);
      }
    });
    _plkFocus.addListener(() {
      if (_plkFocus.hasFocus) {
        _plankMinController.selection = TextSelection(
            baseOffset: 0, extentOffset: _plankMinController.text.length);
      }
    });
    _plkSecFocus.addListener(() {
      if (_plkSecFocus.hasFocus) {
        _plankSecController.selection = TextSelection(
            baseOffset: 0, extentOffset: _plankSecController.text.length);
      }
    });
    _runFocus.addListener(() {
      if (_runFocus.hasFocus) {
        _runMinController.selection = TextSelection(
            baseOffset: 0, extentOffset: _runMinController.text.length);
      }
    });
    _runSecFocus.addListener(() {
      if (_runSecFocus.hasFocus) {
        _runSecController.selection = TextSelection(
            baseOffset: 0, extentOffset: (_runSecController).text.length);
      }
    });

    ageValid = true;
    mdlValid = true;
    sptValid = true;
    hrpValid = true;
    sdcMinValid = true;
    sdcSecValid = true;
    plankMinsValid = true;
    plankSecsValid = true;
    runMinValid = true;
    runSecValid = true;

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('acft_event') != null) {
      event = prefs.getString('acft_event');
    } else {
      event = 'Run';
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

    setBenchmarks();
    mdlScore =
        getMdlScore(mdlRaw, ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
    sptScore =
        getSptScore(sptRaw, ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
    hrpScore =
        getHrpScore(hrpRaw, ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
    sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
    plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
    calcRunScore();
    calcTotal();

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
                    setBenchmarks();
                    mdlScore = getMdlScore(mdlRaw,
                        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    sptScore = getSptScore(sptRaw,
                        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    hrpScore = getHrpScore(hrpRaw,
                        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                        ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                    calcRunScore();
                    calcTotal();
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Age',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _ageController,
                    focusNode: _ageFocus,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: ageValid ? null : '17-80'),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? 0;
                      if (raw > 80) {
                        ageValid = false;
                        age = 80;
                      } else if (raw < 17) {
                        ageValid = false;
                        age = 17;
                      } else {
                        age = raw;
                        ageValid = true;
                      }
                      setAgeGroup();
                      setBenchmarks();
                      mdlScore = getMdlScore(mdlRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      sptScore = getSptScore(sptRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      hrpScore = getHrpScore(hrpRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcRunScore();
                      calcTotal();
                    },
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _mdlFocus.requestFocus(),
                  ),
                )
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
                      ageValid = true;
                      setAgeGroup();
                      _ageController.text = age.toString();
                      setBenchmarks();
                      mdlScore = getMdlScore(mdlRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      sptScore = getSptScore(sptRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      hrpScore = getHrpScore(hrpRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcRunScore();
                      calcTotal();
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
                        ageValid = true;
                        age = value.floor();
                        setAgeGroup();
                        _ageController.text = age.toString();
                        setBenchmarks();
                        mdlScore = getMdlScore(mdlRaw,
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                        sptScore = getSptScore(sptRaw,
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                        hrpScore = getHrpScore(hrpRaw,
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                        sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                        plankScore = getPlkScore(
                            getIntTime(plankMins, plankSecs),
                            ageGroups.indexOf(ageGroup) + 1,
                            gender == 'Male');
                        calcRunScore();
                        calcTotal();
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
                      ageValid = true;
                      setAgeGroup();
                      _ageController.text = age.toString();
                      setBenchmarks();
                      mdlScore = getMdlScore(mdlRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      sptScore = getSptScore(sptRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      hrpScore = getHrpScore(hrpRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcRunScore();
                      calcTotal();
                    },
                  ),
                ],
              ),
            ),
            FormattedDropDown(
              label: 'Aerobic Event',
              value: event,
              items: events,
              onChanged: (value) {
                setState(() {
                  FocusScope.of(context).unfocus();
                  event = value;
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
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _mdlController,
                    focusNode: _mdlFocus,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _sptFocus.requestFocus(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: mdlValid ? null : '60-400'),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? 0;
                      if (raw > 400) {
                        mdlValid = false;
                        mdlRaw = 400;
                      } else if (raw < 60) {
                        mdlValid = false;
                        mdlRaw = 60;
                      } else {
                        mdlRaw = raw;
                        mdlValid = true;
                      }
                      mdlScore = getMdlScore(mdlRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                )
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
                      mdlValid = true;
                      mdlScore = getMdlScore(mdlRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        mdlValid = true;
                        mdlScore = getMdlScore(mdlRaw,
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      mdlValid = true;
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
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _sptController,
                    focusNode: _sptFocus,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _hrpFocus.requestFocus(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: sptValid ? null : '3.3-14.0'),
                    onChanged: (value) {
                      double raw = double.tryParse(value) ?? 0;
                      if (raw > 14.0) {
                        sptValid = false;
                        sptRaw = 14.0;
                      } else if (raw < 3.3) {
                        sptValid = false;
                        sptRaw = 3.3;
                      } else {
                        sptRaw = raw;
                        sptValid = true;
                      }
                      sptScore = getSptScore(sptRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                )
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
                      sptValid = true;
                      sptScore = getSptScore(sptRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        sptValid = true;
                        sptScore = getSptScore(sptRaw,
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      sptValid = true;
                      sptScore = getSptScore(sptRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _hrpController,
                    focusNode: _hrpFocus,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _sdcFocus.requestFocus(),
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: hrpValid ? null : '0-80'),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? -1;
                      if (raw > 80) {
                        hrpValid = false;
                        hrpRaw = 80;
                      } else if (raw < 0) {
                        hrpValid = false;
                        hrpRaw = 0;
                      } else {
                        hrpRaw = raw;
                        hrpValid = true;
                      }
                      hrpScore = getHrpScore(hrpRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
                      calcTotal();
                    },
                  ),
                )
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
                      hrpValid = true;
                      hrpScore = getHrpScore(hrpRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        hrpValid = true;
                        hrpScore = getHrpScore(hrpRaw,
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      hrpValid = true;
                      hrpScore = getHrpScore(hrpRaw,
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _sdcMinController,
                        focusNode: _sdcFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: sdcMinValid ? null : '0-5'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw < 0) {
                            sdcMinValid = false;
                            sdcMins = 0;
                          } else if (raw > 5) {
                            sdcMinValid = false;
                            sdcMins = 5;
                          } else {
                            sdcMinValid = true;
                            sdcMins = raw;
                          }
                          sdcScore = getSdcScore(
                              getIntTime(sdcMins, sdcSecs),
                              ageGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                      child: Text(
                        ':',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _sdcSecController,
                        focusNode: _sdcSecFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _plkFocus.requestFocus(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: sdcSecValid ? null : '0-59'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw > 59) {
                            sdcSecValid = false;
                            sdcSecs = 59;
                          } else if (raw < 0) {
                            sdcSecValid = false;
                            sdcSecs = 0;
                          } else {
                            sdcSecValid = true;
                            sdcSecs = raw;
                          }
                          sdcScore = getSdcScore(
                              getIntTime(sdcMins, sdcSecs),
                              ageGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
                          calcTotal();
                        },
                      ),
                    )
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
                      _sdcMinController.text = sdcMins.toString();
                      sdcMinValid = true;
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        _sdcMinController.text = sdcMins.toString();
                        sdcMinValid = true;
                        sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      _sdcMinController.text = sdcMins.toString();
                      sdcMinValid = true;
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      _sdcSecController.text = sdcSecs.toString();
                      sdcSecValid = true;
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        _sdcSecController.text = sdcSecs.toString();
                        sdcSecValid = true;
                        sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                            ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      _sdcSecController.text = sdcSecs.toString();
                      sdcSecValid = true;
                      sdcScore = getSdcScore(getIntTime(sdcMins, sdcSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _plankMinController,
                        focusNode: _plkFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: plankMinsValid ? null : '0-4'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw < 0) {
                            plankMinsValid = false;
                            plankMins = 0;
                          } else if (raw > 4) {
                            plankMinsValid = false;
                            plankMins = 4;
                          } else {
                            plankMinsValid = true;
                            plankMins = raw;
                          }
                          plankScore = getPlkScore(
                              getIntTime(plankMins, plankSecs),
                              ageGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
                          calcTotal();
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                      child: Text(
                        ':',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _plankSecController,
                        focusNode: _plkSecFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _runFocus.requestFocus(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: plankSecsValid ? null : '0-59'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw > 59) {
                            plankSecsValid = false;
                            plankSecs = 59;
                          } else if (raw < 0) {
                            plankSecsValid = false;
                            plankSecs = 0;
                          } else {
                            plankSecsValid = true;
                            plankSecs = raw;
                          }
                          plankScore = getPlkScore(
                              getIntTime(plankMins, plankSecs),
                              ageGroups.indexOf(ageGroup) + 1,
                              gender == 'Male');
                          calcTotal();
                        },
                      ),
                    )
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
                      _plankMinController.text = plankMins.toString();
                      plankMinsValid = true;
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        _plankMinController.text = plankMins.toString();
                        plankMinsValid = true;
                        plankScore = getPlkScore(
                            getIntTime(plankMins, plankSecs),
                            ageGroups.indexOf(ageGroup) + 1,
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
                      _plankMinController.text = plankMins.toString();
                      plankMinsValid = true;
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                      _plankSecController.text = plankSecs.toString();
                      plankSecsValid = true;
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                        _plankSecController.text = plankSecs.toString();
                        plankSecsValid = true;
                        plankScore = getPlkScore(
                            getIntTime(plankMins, plankSecs),
                            ageGroups.indexOf(ageGroup) + 1,
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
                      _plankSecController.text = plankSecs.toString();
                      plankSecsValid = true;
                      plankScore = getPlkScore(getIntTime(plankMins, plankSecs),
                          ageGroups.indexOf(ageGroup) + 1, gender == 'Male');
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
                  event,
                  style: const TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _runMinController,
                        focusNode: _runFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: runMinValid ? null : '10-40'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw < 10) {
                            runMinValid = false;
                            runMins = 10;
                          } else if (raw > 40) {
                            runMinValid = false;
                            runMins = 40;
                          } else {
                            runMinValid = true;
                            runMins = raw;
                          }
                          calcRunScore();
                          calcTotal();
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                      child: Text(
                        ':',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _runSecController,
                        focusNode: _runSecFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: runSecValid ? null : '0-59'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw > 59) {
                            runSecValid = false;
                            runSecs = 59;
                          } else if (raw < 0) {
                            runSecValid = false;
                            runSecs = 0;
                          } else {
                            runSecValid = true;
                            runSecs = raw;
                          }
                          calcRunScore();
                          calcTotal();
                        },
                      ),
                    )
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
                      _runMinController.text = runMins.toString();
                      runMinValid = true;
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
                        _runMinController.text = runMins.toString();
                        runMinValid = true;
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
                      _runMinController.text = runMins.toString();
                      runMinValid = true;
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
                      _runSecController.text = runSecs.toString();
                      runSecValid = true;
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
                        _runSecController.text = runSecs.toString();
                        runSecValid = true;
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
                      _runSecController.text = runSecs.toString();
                      runSecValid = true;
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
                    centered: true,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'Min',
                    centered: true,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: '90%',
                    centered: true,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'Max',
                    centered: true,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: 'Score',
                    centered: true,
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
                    title: mdlMin,
                    centered: true,
                  ),
                  GridBox(
                    title: mdl90,
                    centered: true,
                  ),
                  GridBox(
                    title: mdlMax,
                    centered: true,
                  ),
                  GridBox(
                    title: mdlScore.toString(),
                    centered: true,
                    background: mdlPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'SPT',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: sptMin,
                    centered: true,
                  ),
                  GridBox(
                    title: spt90,
                    centered: true,
                  ),
                  GridBox(
                    title: sptMax,
                    centered: true,
                  ),
                  GridBox(
                    title: sptScore.toString(),
                    centered: true,
                    background: sptPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'HRP',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: hrpMin,
                    centered: true,
                  ),
                  GridBox(
                    title: hrp90,
                    centered: true,
                  ),
                  GridBox(
                    title: hrpMax,
                    centered: true,
                  ),
                  GridBox(
                    title: hrpScore.toString(),
                    centered: true,
                    background: hrpPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'SDC',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: sdcMin,
                    centered: true,
                  ),
                  GridBox(
                    title: sdc90,
                    centered: true,
                  ),
                  GridBox(
                    title: sdcMax,
                    centered: true,
                  ),
                  GridBox(
                    title: sdcScore.toString(),
                    centered: true,
                    background: sdcPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'PLK',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: plkMin,
                    centered: true,
                  ),
                  GridBox(
                    title: plk90,
                    centered: true,
                  ),
                  GridBox(
                    title: plkMax,
                    centered: true,
                  ),
                  GridBox(
                    title: plankScore.toString(),
                    centered: true,
                    background: plkPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: '2MR',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: runMin,
                    centered: true,
                  ),
                  GridBox(
                    title: run90,
                    centered: true,
                  ),
                  GridBox(
                    title: runMax,
                    centered: true,
                  ),
                  GridBox(
                    title: runScore.toString(),
                    centered: true,
                    background: runPass ? backgroundColor : failColor,
                  ),
                  GridBox(
                    title: 'Total',
                    centered: false,
                    background: primaryColor,
                    textColor: onPrimary,
                  ),
                  GridBox(
                    title: '',
                    centered: true,
                  ),
                  GridBox(
                    title: '',
                    centered: true,
                  ),
                  GridBox(
                    title: '',
                    centered: true,
                  ),
                  GridBox(
                    title: total.toString(),
                    centered: true,
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
                        sdcRaw: sdcMins.toString() + ':' + sdcSeconds,
                        sdcScore: sdcScore.toString(),
                        plkRaw: '${plankMins.toString()}:$plankSeconds',
                        plkScore: plankScore.toString(),
                        runRaw: runMins.toString() + ':' + runSeconds,
                        runScore: runScore.toString(),
                        runEvent: event,
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
