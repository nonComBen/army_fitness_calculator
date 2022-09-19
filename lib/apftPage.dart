import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import './providers/shared_preferences_provider.dart';
import './sqlite/dbHelper.dart';
import './widgets/formatted_drop_down.dart';
import './widgets/formatted_radio.dart';
import './widgets/grid_box.dart';
import './widgets/increment_decrement_button.dart';
import './calculators/puCalculator.dart';
import './calculators/suCalculator.dart';
import './calculators/runCalculator.dart';
import './sqlite/apft.dart';
import './savedPages/savedApftsPage.dart';

class ApftPage extends ConsumerStatefulWidget {
  ApftPage(this.isPremium, this.upgradeNeeded);
  final bool isPremium;
  final VoidCallback upgradeNeeded;

  @override
  _ApftPageState createState() => _ApftPageState();
}

class _ApftPageState extends ConsumerState<ApftPage> {
  String gender,
      ageGroup,
      event,
      puMin,
      pu90,
      puMax,
      suMin,
      su90,
      suMax,
      runMin,
      run90,
      runMax;
  int age, pu, su, min, sec, puScore, suScore, runScore, total;
  bool jrSoldier,
      puPass,
      suPass,
      runPass,
      totalPass,
      puProfile,
      suProfile,
      ageValid,
      minValid,
      secValid;
  SharedPreferences prefs;
  RegExp regExp;
  DBHelper dbHelper;

  final _ageController = new TextEditingController();
  final _ageFocus = new FocusNode();
  final _puController = new TextEditingController();
  final _puFocus = new FocusNode();
  final _suController = new TextEditingController();
  final _suFocus = new FocusNode();
  final _minController = new TextEditingController();
  final _minFocus = new FocusNode();
  final _secController = new TextEditingController();
  final _secFocus = new FocusNode();

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

  List<String> events = [
    'Run',
    'Walk',
    'Bike',
    'Swim',
  ];

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
    if (puProfile) {
      if (jrSoldier) {
        puScore = 60;
      } else {
        puScore = 0;
      }
    } else {
      puScore = getPuScore(gender == "Male", ageGroups.indexOf(ageGroup), pu);
    }
    if (puScore < 60 && !puProfile) {
      puPass = false;
    } else
      puPass = true;
  }

  void _calcSu() {
    if (suProfile) {
      if (jrSoldier) {
        suScore = 60;
      } else {
        suScore = 0;
      }
    } else {
      suScore = getSuScore(ageGroups.indexOf(ageGroup), su);
    }

    if (suScore < 60 && !suProfile) {
      suPass = false;
    } else
      suPass = true;
  }

  void _calcRun() {
    String seconds;
    if (sec.toString().length == 1) {
      seconds = '0' + sec.toString();
    } else
      seconds = sec.toString();

    int runTime = int.tryParse(min.toString() + seconds);
    if (event != 'Run') {
      runPass = passAltEvent(
          gender == "Male", ageGroups.indexOf(ageGroup), runTime, event);
      if (jrSoldier) {
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
          getRunScore(gender == "Male", ageGroups.indexOf(ageGroup), runTime);
      if (runScore < 60) {
        runPass = false;
      } else
        runPass = true;
    }
  }

  void _calculateApft() {
    setState(() {
      total = puScore + suScore + runScore;
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
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      regExp.hasMatch(value) ? null : 'Use yyyyMMdd Format',
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(ctx).nextFocus(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  child: Text('Save APFT'),
                  onPressed: () {
                    apft.date = _dateController.text;
                    apft.rank = _rankController.text;
                    apft.name = _nameController.text;
                    dbHelper.saveAPft(apft);
                    Navigator.pop(ctx);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedApftsPage()));
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
  void dispose() {
    super.dispose();
    _ageController.dispose();
    _puController.dispose();
    _suController.dispose();
    _minController.dispose();
    _secController.dispose();

    _ageFocus.dispose();
    _puFocus.dispose();
    _suFocus.dispose();
    _minFocus.dispose();
    _secController.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = new DBHelper();

    age = 22;
    pu = 50;
    _puController.text = pu.toString();
    su = 50;
    _suController.text = su.toString();
    min = 15;
    _minController.text = min.toString();
    sec = 30;
    _secController.text = sec.toString();

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
    _minFocus.addListener(() {
      if (_minFocus.hasFocus) {
        _minController.selection = TextSelection(
            baseOffset: 0, extentOffset: _minController.text.length);
      }
    });
    _secFocus.addListener(() {
      if (_secFocus.hasFocus) {
        _secController.selection = TextSelection(
            baseOffset: 0, extentOffset: _secController.text.length);
      }
    });

    puScore = 0;
    suScore = 0;
    runScore = 0;
    total = 0;

    puPass = true;
    suPass = true;
    runPass = true;
    totalPass = true;

    puProfile = false;
    suProfile = false;

    ageValid = true;
    minValid = true;
    secValid = true;

    gender = 'Male';
    event = 'Run';
    jrSoldier = false;

    puMin = '';
    pu90 = '';
    puMax = '';
    suMin = '';
    su90 = '';
    suMax = '';
    runMin = '';
    run90 = '';
    runMax = '';

    regExp = RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender');
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age');
    }
    if (prefs.getString('apft_event') != null) {
      event = prefs.getString('apft_event');
    }
    if (prefs.getBool('jr_soldier') != null) {
      jrSoldier = prefs.getBool('jr_soldier');
    }

    _ageController.text = age.toString();
    ageGroup = getAgeGroup(age);

    setBenchmarks();

    _calcPu();
    _calcSu();
    _calcRun();
    _calculateApft();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;
    final errorColor = Theme.of(context).colorScheme.error;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormattedRadio(
                titles: ['M', 'F'],
                values: ['Male', 'Female'],
                groupValue: gender,
                onChanged: (value) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    gender = value;
                    setBenchmarks();
                    _calcPu();
                    _calcSu();
                    _calcRun();
                    _calculateApft();
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
                      ageGroup = getAgeGroup(age);
                      setBenchmarks();
                      _calcPu();
                      _calcSu();
                      _calcRun();
                      _calculateApft();
                    },
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _puFocus.requestFocus(),
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
                      ageGroup = getAgeGroup(age);
                      _ageController.text = age.toString();
                      setBenchmarks();
                      _calcPu();
                      _calcSu();
                      _calcRun();
                      _calculateApft();
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
                        ageGroup = getAgeGroup(age);
                        _ageController.text = age.toString();
                        setBenchmarks();
                        _calcPu();
                        _calcSu();
                        _calcRun();
                        _calculateApft();
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
                      ageGroup = getAgeGroup(age);
                      _ageController.text = age.toString();
                      setBenchmarks();
                      _calcPu();
                      _calcSu();
                      _calcRun();
                      _calculateApft();
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
                FocusScope.of(context).unfocus();
                setState(() {
                  event = value;
                });
                setBenchmarks();
                _calcPu();
                _calcSu();
                _calcRun();
                _calculateApft();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Push Ups',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _puController,
                    focusNode: _puFocus,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _suFocus.requestFocus(),
                    textAlign: TextAlign.start,
                    enabled: !puProfile,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    maxLength: 2,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? 0;
                      setState(() {
                        pu = raw;
                        _calcPu();
                        if (jrSoldier) _calcRun();
                        _calculateApft();
                      });
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
                      if (pu > 0 && !puProfile) {
                        pu--;
                        _puController.text = pu.toString();
                        _calcPu();
                        if (jrSoldier) _calcRun();
                        _calculateApft();
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: primaryColor,
                      value: pu.toDouble(),
                      min: 0,
                      max: 99,
                      divisions: 100,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          if (puProfile) {
                            pu = 0;
                          } else {
                            pu = value.floor();
                            _puController.text = pu.toString();
                            _calcPu();
                            if (jrSoldier) _calcRun();
                            _calculateApft();
                          }
                        });
                      },
                    ),
                  ),
                  IncrementDecrementButton(
                    child: '+',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (pu < 99 && !puProfile) {
                        setState(() {
                          pu++;
                          _puController.text = pu.toString();
                          _calcPu();
                          if (jrSoldier) _calcRun();
                          _calculateApft();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                  title: const Text('Profile'),
                  value: puProfile,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: onSecondary,
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      puProfile = value;
                      if (value) {
                        pu = 0;
                        _puController.text = pu.toString();
                      }
                      _calcPu();
                      if (jrSoldier) _calcRun();
                      _calculateApft();
                    });
                  }),
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
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _suController,
                    focusNode: _suFocus,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _minFocus.requestFocus(),
                    textAlign: TextAlign.start,
                    enabled: !suProfile,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    maxLength: 2,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? 0;
                      setState(() {
                        su = raw;
                        _calcSu();
                        if (jrSoldier) _calcRun();
                        _calculateApft();
                      });
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
                      if (su > 0 && !suProfile) {
                        su--;
                        _suController.text = su.toString();
                        _calcSu();
                        if (jrSoldier) _calcRun();
                        _calculateApft();
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: primaryColor,
                      value: su.toDouble(),
                      min: 0,
                      max: 99,
                      divisions: 100,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          if (suProfile) {
                            su = 0;
                          } else {
                            su = value.floor();
                            _suController.text = su.toString();
                            _calcSu();
                            if (jrSoldier) _calcRun();
                            _calculateApft();
                          }
                        });
                      },
                    ),
                  ),
                  IncrementDecrementButton(
                    child: '+',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (su < 99 && !suProfile) {
                        setState(() {
                          su++;
                          _suController.text = su.toString();
                          _calcSu();
                          if (jrSoldier) _calcRun();
                          _calculateApft();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                  title: const Text('Profile'),
                  value: suProfile,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: onSecondary,
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      suProfile = value;
                      if (value) {
                        su = 0;
                        _suController.text = su.toString();
                      }
                      _calcSu();
                      if (jrSoldier) _calcRun();
                      _calculateApft();
                    });
                  }),
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
                      width: 70,
                      child: TextField(
                        controller: _minController,
                        focusNode: _minFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _secFocus.requestFocus(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: minValid ? null : '0-50'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw < 0) {
                            min = 0;
                            minValid = false;
                          } else if (raw > 50) {
                            min = 50;
                            minValid = false;
                          } else {
                            min = raw;
                            minValid = true;
                          }
                          _calcRun();
                          _calculateApft();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 8.0),
                      child: const Text(
                        ':',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _secController,
                        focusNode: _secFocus,
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
                            errorText: secValid ? null : '0-59'),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? -1;
                          if (raw < 0) {
                            sec = 0;
                            secValid = false;
                          } else if (raw > 59) {
                            sec = 59;
                            secValid = false;
                          } else {
                            sec = raw;
                            secValid = true;
                          }
                          _calcRun();
                          _calculateApft();
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
                      if (min > 0) {
                        min--;
                        _minController.text = min.toString();
                        _calcRun();
                        _calculateApft();
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: primaryColor,
                      value: min.toDouble(),
                      min: 0,
                      max: 50,
                      divisions: 51,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          min = value.floor();
                          _minController.text = min.toString();
                          _calcRun();
                          _calculateApft();
                        });
                      },
                    ),
                  ),
                  IncrementDecrementButton(
                    child: '+',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (min < 50) {
                        setState(() {
                          min++;
                          _minController.text = min.toString();
                          _calcRun();
                          _calculateApft();
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
                      if (sec > 0) {
                        sec--;
                        _secController.text = sec.toString();
                        _calcRun();
                        _calculateApft();
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: primaryColor,
                      value: sec.toDouble(),
                      min: 0,
                      max: 59,
                      divisions: 60,
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          sec = value.floor();
                          _secController.text = sec.toString();
                          _calcRun();
                          _calculateApft();
                        });
                      },
                    ),
                  ),
                  IncrementDecrementButton(
                    child: '+',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (sec < 59) {
                        setState(() {
                          sec++;
                          _secController.text = sec.toString();
                          _calcRun();
                          _calculateApft();
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
                child: CheckboxListTile(
                  title: Text('For Promotion Points'),
                  value: jrSoldier,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: onSecondary,
                  onChanged: (value) {
                    FocusScope.of(context).unfocus();
                    if (value) {
                      if (puProfile) puScore = 60;
                      if (suProfile) suScore = 60;
                      if (event != 'Run')
                        runScore = ((puScore + suScore) / 2).floor();
                    } else {
                      if (puProfile) puScore = 0;
                      if (suProfile) suScore = 0;
                      if (event != 'Run') runScore = 0;
                    }
                    setState(() {
                      jrSoldier = value;
                      _calculateApft();
                    });
                  },
                )),
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
                    textColor: textColor,
                  ),
                  GridBox(
                    title: 'Min',
                    centered: true,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: '90%',
                    centered: true,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: 'Max',
                    centered: true,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: 'Score',
                    centered: true,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: 'PU',
                    centered: false,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: puMin,
                    centered: true,
                  ),
                  GridBox(
                    title: pu90,
                    centered: true,
                  ),
                  GridBox(
                    title: puMax,
                    centered: true,
                  ),
                  GridBox(
                    title: puScore.toString(),
                    centered: true,
                    background: puPass ? backgroundColor : errorColor,
                  ),
                  GridBox(
                    title: 'SU',
                    centered: false,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: suMin,
                    centered: true,
                  ),
                  GridBox(
                    title: su90,
                    centered: true,
                  ),
                  GridBox(
                    title: suMax,
                    centered: true,
                  ),
                  GridBox(
                    title: suScore.toString(),
                    centered: true,
                    background: suPass ? backgroundColor : errorColor,
                  ),
                  GridBox(
                    title: event,
                    centered: false,
                    background: primaryColor,
                    textColor: textColor,
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
                    background: runPass ? backgroundColor : errorColor,
                  ),
                  GridBox(
                    title: 'Total',
                    centered: false,
                    background: primaryColor,
                    textColor: textColor,
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
                    background: totalPass ? backgroundColor : errorColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor)),
                child: const Text('Save APFT Score'),
                onPressed: () {
                  String runSeconds =
                      sec.toString().length == 1 ? '0$sec' : sec.toString();
                  if (widget.isPremium) {
                    Apft apft = new Apft(
                        id: null,
                        date: null,
                        rank: null,
                        name: null,
                        gender: gender,
                        age: age.toString(),
                        puRaw: pu.toString(),
                        puScore: puScore.toString(),
                        suRaw: su.toString(),
                        suScore: suScore.toString(),
                        runRaw: min.toString() + ':' + runSeconds,
                        runScore: runScore.toString(),
                        runEvent: event,
                        total: total.toString(),
                        altPass: runPass ? 1 : 0,
                        pass: totalPass ? 1 : 0);
                    _saveApft(context, apft);
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
