import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/shared_preferences_provider.dart';
import './sqlite/dbHelper.dart';
import './widgets/formatted_radio.dart';
import './widgets/grid_box.dart';
import './widgets/increment_decrement_button.dart';
import './calculators/bfCalculator.dart';
import './sqlite/bodyfat.dart';
import './savedPages/savedBodyfatsPage.dart';

class BodyfatPage extends ConsumerStatefulWidget {
  BodyfatPage(this.isPremium, this.upgradeNeeded);
  final bool isPremium;
  final VoidCallback upgradeNeeded;

  @override
  _BodyfatPageState createState() => _BodyfatPageState();
}

class _BodyfatPageState extends ConsumerState<BodyfatPage> {
  int age, height, weight, percent, min, max, percentMax, overUnder;
  double heightDouble, neck, waist, hip;
  String ageGroup, gender;
  bool bmiPass,
      bfPass,
      underWeight,
      ageValid,
      heightValid,
      weightValid,
      neckValid,
      waistValid,
      hipValid;
  SharedPreferences prefs;
  RegExp regExp;
  DBHelper dbHelper;

  List<String> ageGroups = ['17-20', '21-27', '28-39', '40+'];

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _heightDoubleController = TextEditingController();
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

  void setBenchmarks() {
    List<int> benchmarks =
        setBfBenchmarks(gender == 'Male', ageGroups.indexOf(ageGroup), height);
    setState(() {
      min = benchmarks[0];
      max = benchmarks[1];
      percentMax = benchmarks[2];
    });
  }

  void calcBmi() {
    setState(() {
      if (weight <= max) {
        if (weight >= min) {
          bmiPass = true;
          bfPass = true;
        } else {
          bmiPass = false;
          underWeight = true;
        }
      } else {
        bmiPass = false;
        underWeight = false;
        calcBf();
      }
    });
  }

  void calcBf() {
    double cirValue;
    if (gender == 'Male') {
      cirValue = waist - neck;
    } else {
      cirValue = waist + hip - neck;
    }
    setState(() {
      percent = getBfPercent(gender == 'Male', heightDouble, cirValue);
      overUnder = percent - percentMax;
      if (overUnder <= 0) {
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
    print('Height Double: ${bf.heightDouble}');
    final f = DateFormat('yyyyMMdd');
    final date = f.format(DateTime.now());
    final _dateController = TextEditingController(text: date);
    final _rankController = TextEditingController();
    final _nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
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
                  child: Text('Save Body Composition'),
                  onPressed: () {
                    bf.date = _dateController.text;
                    bf.rank = _rankController.text;
                    bf.name = _nameController.text;
                    if (bmiPass)
                      bf.bfPercent = bf.gender == 'Male' ? '18' : '28';
                    dbHelper.saveBodyfat(bf);
                    Navigator.pop(ctx);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedBodyfatsPage()));
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
    _heightController.dispose();
    _heightDoubleController.dispose();
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
  }

  @override
  void initState() {
    super.initState();
    dbHelper = new DBHelper();

    age = 22;
    height = 68;
    weight = 150;
    _weightController.text = weight.toString();
    neck = 16.0;
    _neckController.text = neck.toString();
    waist = 34.0;
    _waistController.text = waist.toString();
    hip = 34.0;
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

    gender = 'Male';

    bmiPass = true;
    bfPass = true;
    underWeight = false;

    ageValid = true;
    heightValid = true;
    weightValid = true;
    neckValid = true;
    waistValid = true;
    hipValid = true;

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('gender') != null) {
      gender = prefs.getString('gender');
    }
    if (prefs.getInt('age') != null) {
      age = prefs.getInt('age');
    }
    if (prefs.getInt('height') != null) {
      height = prefs.getInt('height');
    }

    _ageController.text = age.toString();
    ageGroup = getAgeGroup(age);
    heightDouble = height.toDouble();
    _heightController.text = height.toString();
    _heightDoubleController.text = heightDouble.toString();

    setBenchmarks();
    calcBmi();
    calcBf();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;
    final errorColor = Theme.of(context).colorScheme.error;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      padding: EdgeInsets.all(16.0),
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
                  calcBmi();
                  calcBf();
                });
              },
            ),
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
                      calcBmi();
                      calcBf();
                    },
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _heightFocus.requestFocus(),
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
                      calcBmi();
                      calcBf();
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
                      ageValid = true;
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
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _heightController,
                    focusNode: _heightFocus,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _weightFocus.requestFocus(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: heightValid ? null : '50-90'),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? 0;
                      setState(() {
                        if (raw < 58) {
                          height = 58;
                          heightValid = false;
                        } else if (raw > 80) {
                          height = 80;
                          heightValid = false;
                        } else {
                          height = raw;
                          heightValid = true;
                        }
                        heightDouble = height.toDouble();
                        _heightDoubleController.text = heightDouble.toString();
                        setBenchmarks();
                        calcBmi();
                        calcBf();
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
                      if (height > 58) {
                        height--;
                        _heightController.text = height.toString();
                        heightDouble = height.toDouble();
                        _heightDoubleController.text = heightDouble.toString();
                        setBenchmarks();
                        calcBmi();
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
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
                          _heightDoubleController.text =
                              heightDouble.toString();
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
                          _heightDoubleController.text =
                              heightDouble.toString();
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
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _weightController,
                    focusNode: _weightFocus,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: weightValid ? null : '50-350'),
                    onChanged: (value) {
                      int raw = int.tryParse(value) ?? 0;
                      setState(() {
                        if (raw < 50) {
                          weight = 50;
                          weightValid = false;
                        } else if (raw > 350) {
                          weight = 350;
                          weightValid = false;
                        } else {
                          weight = raw;
                          weightValid = true;
                        }
                        calcBmi();
                        calcBf();
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
                      if (weight > 50) {
                        weight--;
                        _weightController.text = weight.toString();
                        calcBmi();
                        calcBf();
                      }
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Slider(
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
                          calcBf();
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: width / 144,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  GridBox(
                    title: ageGroup,
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
                    title: 'Max',
                    centered: true,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: 'Pass/Fail',
                    centered: true,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: '${height.toString()} in.',
                    centered: false,
                    background: primaryColor,
                    textColor: textColor,
                  ),
                  GridBox(
                    title: min.toString(),
                    centered: true,
                  ),
                  GridBox(
                    title: max.toString(),
                    centered: true,
                  ),
                  GridBox(
                    title: bmiPass ? 'Pass' : 'Fail',
                    centered: true,
                    background: bmiPass ? backgroundColor : errorColor,
                  ),
                ],
              ),
            ),
            if (underWeight)
              Center(
                child: const Text(
                  'Underweight',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (!bmiPass && !underWeight)
              Column(
                children: <Widget>[
                  Divider(
                    color: Colors.yellow,
                  ),
                  const Text(
                    'Height to nearest 1/2 in.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IncrementDecrementButton(
                          child: '- 0.5',
                          width: 72,
                          fontSize: 16,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (heightDouble > 58.0) {
                              if (!(heightDouble ==
                                  (height.toDouble() - 0.5))) {
                                setState(() {
                                  heightDouble = heightDouble - 0.5;
                                  _heightDoubleController.text =
                                      heightDouble.toString();
                                });
                                calcBf();
                              }
                            }
                          },
                        ),
                        SizedBox(
                          width: 64,
                          child: TextField(
                            controller: _heightDoubleController,
                            textAlign: TextAlign.center,
                            enabled: false,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                          ),
                        ),
                        IncrementDecrementButton(
                          child: '+ 0.5',
                          width: 72,
                          fontSize: 16,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (heightDouble < 80.0) {
                              if (!(heightDouble ==
                                  (height.toDouble() + 0.5))) {
                                setState(() {
                                  heightDouble = heightDouble + 0.5;
                                  _heightDoubleController.text =
                                      heightDouble.toString();
                                });
                                calcBf();
                              }
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
                        'Neck',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: _neckController,
                          focusNode: _neckFocus,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => _waistFocus.requestFocus(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: neckValid ? null : '10-30'),
                          onChanged: (value) {
                            double raw = double.tryParse(value) ?? 10.0;
                            setState(() {
                              if (raw < 10) {
                                neck = 10;
                                neckValid = false;
                              } else if (raw > 30) {
                                neck = 30;
                                neckValid = false;
                              } else {
                                neck = raw;
                                neckValid = true;
                              }
                              calcBf();
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
                            if (neck > 10) {
                              neck = neck - 0.5;
                              _neckController.text = neck.toString();
                              calcBf();
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: Slider(
                            activeColor: primaryColor,
                            value: neck,
                            min: 10,
                            max: 30,
                            divisions: 40,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                neck = value;
                                _neckController.text = neck.toString();
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
                                _neckController.text = neck.toString();
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
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: _waistController,
                          focusNode: _waistFocus,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          textInputAction: gender == 'Female'
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onEditingComplete: () => gender == 'Female'
                              ? _hipFocus.requestFocus()
                              : FocusScope.of(context).unfocus(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: waistValid ? null : '20-50'),
                          onChanged: (value) {
                            double raw = double.tryParse(value) ?? 0.0;
                            setState(() {
                              if (raw < 20) {
                                waist = 20;
                                waistValid = false;
                              } else if (raw > 50) {
                                waist = 50;
                                waistValid = false;
                              } else {
                                waist = raw;
                                waistValid = true;
                              }
                              calcBf();
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
                            if (waist > 20) {
                              waist = waist - 0.5;
                              _waistController.text = waist.toString();
                              calcBf();
                            }
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: Slider(
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
                                _waistController.text = waist.toString();
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
                  if (gender == 'Female')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Hip',
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: _hipController,
                            focusNode: _hipFocus,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                            ],
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorText: hipValid ? null : '20-50'),
                            onChanged: (value) {
                              double raw = double.tryParse(value) ?? 0.0;
                              setState(() {
                                if (raw < 20) {
                                  hip = 20;
                                  hipValid = false;
                                } else if (raw > 50) {
                                  hip = 50;
                                  hipValid = false;
                                } else {
                                  hip = raw;
                                  hipValid = true;
                                }
                                calcBf();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  if (gender == 'Female')
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
                            child: Slider(
                              activeColor: primaryColor,
                              value: hip,
                              min: 20,
                              max: 50,
                              divisions: 60,
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  hip = value;
                                  _hipController.text = hip.toString();
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
                                  _hipController.text = hip.toString();
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
                    child: GridView.count(
                      crossAxisCount: 5,
                      childAspectRatio: width / 180,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                      shrinkWrap: true,
                      primary: false,
                      children: <Widget>[
                        GridBox(
                          title: '${heightDouble.toString()} in.',
                          centered: true,
                          background: primaryColor,
                          textColor: textColor,
                        ),
                        GridBox(
                          title: 'BF %',
                          centered: true,
                          background: primaryColor,
                          textColor: textColor,
                        ),
                        GridBox(
                          title: 'Max %',
                          centered: true,
                          background: primaryColor,
                          textColor: textColor,
                        ),
                        GridBox(
                          title: 'O/U',
                          centered: true,
                          background: primaryColor,
                          textColor: textColor,
                        ),
                        GridBox(
                          title: 'P/F',
                          centered: true,
                          background: primaryColor,
                          textColor: textColor,
                        ),
                        GridBox(
                          title: gender == 'Male'
                              ? '${(waist - neck).toString()} in.'
                              : '${(hip + waist - neck).toString()} in.',
                          centered: false,
                          background: primaryColor,
                          textColor: textColor,
                        ),
                        GridBox(
                          title: percent.toString(),
                          centered: true,
                        ),
                        GridBox(
                          title: percentMax.toString(),
                          centered: true,
                        ),
                        GridBox(
                          title: overUnder.toString(),
                          centered: true,
                        ),
                        GridBox(
                          title: bfPass ? 'Pass' : 'Fail',
                          centered: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor)),
                child: const Text('Save Body Comp Score'),
                onPressed: () {
                  if (widget.isPremium) {
                    Bodyfat bf = new Bodyfat(
                        id: null,
                        date: null,
                        rank: null,
                        name: null,
                        gender: gender,
                        age: age.toString(),
                        height: height.toString(),
                        weight: weight.toString(),
                        maxWeight: max.toString(),
                        bmiPass: bmiPass ? 1 : 0,
                        heightDouble: heightDouble.toString(),
                        neck: neck.toString(),
                        waist: waist.toString(),
                        hip: hip.toString(),
                        bfPercent: percent.toString(),
                        maxPercent: percentMax.toString(),
                        overUnder: overUnder.toString(),
                        bfPass: bfPass ? 1 : 0);
                    _saveBf(context, bf);
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
