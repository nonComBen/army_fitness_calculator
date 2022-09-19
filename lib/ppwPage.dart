import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './calculators/award_pts_calculator.dart';
import './calculators/pt_pts_calculator.dart';
import './calculators/weapons_pts_calculator.dart';
import './providers/shared_preferences_provider.dart';
import './savedPages/savedPpwPage.dart';
import './sqlite/dbHelper.dart';
import './sqlite/ppw.dart';
import './widgets/formatted_expansion_tile.dart';
import './widgets/formatted_radio.dart';

class PromotionPointPage extends ConsumerStatefulWidget {
  PromotionPointPage(this.isPremium, this.upgradeNeeded);
  final bool isPremium;
  final VoidCallback upgradeNeeded;

  @override
  _PromotionPointPageState createState() => _PromotionPointPageState();
}

class _PromotionPointPageState extends ConsumerState<PromotionPointPage> {
  int ptScore,
      ptPts,
      weaponHits,
      weaponPts,
      milTrainPts,
      awardPts,
      badgePts,
      airbornePts,
      awardsTotal,
      ncoesPts,
      wbcHrs,
      wbcPts,
      resHrs,
      resPts,
      tabPts,
      ar350Pts,
      milEdPts,
      semHrs,
      semHrPts,
      mosCerts,
      crossCerts,
      personalCerts,
      certPts,
      degreePts,
      langPts,
      civEdPts,
      totalPts,
      milTrainMax,
      awardsMax,
      milEdMax,
      civEdMax;
  String rank = 'SGT', weapons, airborneLvl, ncoes;
  bool ranger, sf, sapper, degree, fornLang, newVersion;
  bool ptValid, weaponValid, coaValid, wbcValid, resValid, semValid, certValid;
  SharedPreferences prefs;
  RegExp regExp;
  DBHelper dbHelper;

  List<dynamic> _decorations = [];
  List<dynamic> _badges = [];
  List<String> versions = ['Before 1 Apr 23', 'After 1 Apr 23'];
  List<String> proRanks = ['SGT', 'SSG'];
  List<String> weaponCards = [
    'DA 3595-R / 5790-R / 5789-R / 7801 (M16/M4)',
    'DA 85 (M240B/M60/M249)',
    'DA 88-R (M9)',
    'DA 7814',
    'DA 5704 (Alt M9)',
    'DA 7304-R (M249 AR)',
    'CID (Practical Pistol)',
    'DA 7820-1'
  ];
  List<String> airborne = ['None', 'Basic', 'Senior', 'Master'];
  List<String> awards = [
    'None',
    'Soldiers Medal',
    'Purple Heart',
    'BSM',
    'BSM w/V Device',
    'MSM/DMSM',
    'ARCOM/JSCOM/Equiv',
    'ARCOM/Air Medal w/V Device',
    'AAM/JSAM/Equiv',
    'MOVSM',
    'AGCM/AF Res Medal',
    'COA'
  ];
  List<String> badges = [
    'None',
    'EIB/EFMB/ESB',
    'CIB/CMB/CAB',
    'Master Parachute Badge',
    'Master EOD Badge',
    'Master/Gold Recruiter Badge',
    'Master Gunner Badge',
    'Divers Badge (First Class)',
    'Master Aviation Badge',
    'Master Instructor Badge',
    'Instructor Badge (Basic/Senior)',
    'Senior Parachute Badge',
    'Senior EOD Badge',
    'Presidential Service Badge',
    'VP Service Badge',
    'Drill Sergeant Badge',
    'Recruiter Badge (Basic)',
    'Divers Badge (Supervisor/Salvage)',
    'Parachute Combat Badge (Senior)',
    'Senior Aviation Badge',
    'Free Fall Badge (Master)',
    'Senior Space Badge',
    'Parachute Badge',
    'Parachute Combat Badge (Basic)',
    'Rigger Badge',
    'Divers Badge (SCUBA/2nd Class)',
    'EOD Badge (Basic)',
    'Pathfinder Badge',
    'Air Assault Badge',
    'Aviation Badge',
    'Army Staff ID Badge',
    'JCoS ID Badge',
    'SecDef Service Badge',
    'Space Badge',
    'Free Fall Badge (Basic)',
    'Special Operations Divers Badge (Basic)',
    'Tomb Guard ID Badge',
    'Military Horseman ID Badge',
    'Driver/Mech Badge',
  ];
  List<String> ncoesHonors = [
    'None',
    'Commandant\'s List',
    'Distinguished Leader',
    'Distinguished Honor Grad'
  ];

  final _apftController = TextEditingController();
  final _weaponController = TextEditingController();
  final _wbcController = TextEditingController();
  final _resCourseController = TextEditingController();
  final _semHrsController = TextEditingController();
  final _mosCertsController = TextEditingController();
  final _crossCertsController = TextEditingController();
  final _personalCertsController = TextEditingController();

  final _apftFocus = FocusNode();
  final _weaponFocus = FocusNode();
  final _wbcFocus = FocusNode();
  final _resFocus = FocusNode();
  final _semHrsFocus = FocusNode();
  final _mosCertsFocus = FocusNode();
  final _crossCertsFocus = FocusNode();
  final _personalCertsFocus = FocusNode();

  void _resetMaximums() {
    if (rank == 'SGT') {
      if (newVersion) {
        milTrainMax = 280;
        awardsMax = 145;
        milEdMax = 240;
        civEdMax = 135;
      } else {
        milTrainMax = 340;
        awardsMax = 125;
        milEdMax = 200;
        civEdMax = 135;
      }
    } else {
      if (newVersion) {
        milTrainMax = 230;
        awardsMax = 165;
        milEdMax = 245;
        civEdMax = 160;
      } else {
        milTrainMax = 255;
        awardsMax = 165;
        milEdMax = 220;
        civEdMax = 160;
      }
    }
  }

  void _calcPtPts() {
    if (newVersion) {
      ptPts = acftPts(ptScore);
    } else {
      ptPts = apftPts(ptScore, rank);
    }
  }

  void _calcWeaponPts() {
    weaponPts = newWeaponsPts(
        weaponCards.indexOf(weapons), rank, weaponHits, newVersion);
  }

  void _calcAwardPts() {
    awardPts = calcAwardpts(_decorations);
  }

  void _calcBadgePts() {
    badgePts = newBadgePts(_badges, newVersion);
  }

  void _calcAirbornePts() {
    int index = airborne.indexOf(airborneLvl);
    if (newVersion) {
      if (index == 0) {
        airbornePts = 0;
      } else if (index == 1) {
        airbornePts = 20;
      } else {
        airbornePts = 15;
      }
    } else {
      if (index == 0) {
        airbornePts = 0;
      } else if (index == 1) {
        airbornePts = 20;
      } else if (index == 2) {
        airbornePts = 25;
      } else if (index == 3) {
        airbornePts = 30;
      }
    }
  }

  void _calcNcoesPts() {
    int index = ncoesHonors.indexOf(ncoes);
    if (index == 0) {
      ncoesPts = 0;
    } else if (index == 1) {
      ncoesPts = 20;
    } else {
      ncoesPts = 40;
    }
  }

  void _calcTabPts() {
    tabPts = 0;
    if (ranger) {
      tabPts += 40;
    }
    if (sf) {
      tabPts += 40;
    }
    if (sapper) {
      tabPts += 40;
    }
    _calcResPts();
  }

  void _calcResPts() {
    resPts = (resHrs / 10).floor() + tabPts;
    if (newVersion) {
      if (rank == 'SGT' && resPts > 110) {
        resPts = 110;
      } else if (rank == 'SSG' && resPts > 115) {
        resPts = 115;
      }
    } else {
      if (rank == 'SGT' && resPts > 80) {
        resPts = 80;
      } else if (rank == 'SSG' && resPts > 90) {
        resPts = 90;
      }
    }
  }

  void _calcWbcPts() {
    wbcPts = (wbcHrs / 5).floor();
    if (!newVersion && rank == 'SGT' && wbcPts > 80) {
      wbcPts = 80;
    } else if (wbcPts > 90) {
      wbcPts = 90;
    }
  }

  void _calcSemPts() {
    semHrPts = semHrs * 2;
  }

  void _calcDegreePts() {
    if (degree) {
      degreePts = 20;
    } else {
      degreePts = 0;
    }
  }

  void _calcLangPts() {
    if (fornLang) {
      langPts = 25;
    } else {
      langPts = 0;
    }
  }

  void _calcCertPts() {
    if (newVersion) {
      certPts = (mosCerts * 15) + (crossCerts * 10) + (personalCerts * 5);
    } else {
      certPts = mosCerts * 10;
    }
    if (certPts > 50) {
      certPts = 50;
    }
  }

  _calcTotalPts() {
    milTrainPts = ptPts + weaponPts;
    if (milTrainPts > milTrainMax) {
      milTrainPts = milTrainMax;
    }
    awardsTotal = awardPts + badgePts;
    if (awardsTotal > awardsMax) {
      awardsTotal = awardsMax;
    }
    awardsTotal += airbornePts;
    milEdPts = ncoesPts + resPts + wbcPts;
    if (milEdPts > milEdMax) {
      milEdPts = milEdMax;
    }
    civEdPts = semHrPts + certPts + degreePts + langPts;
    if (civEdPts > civEdMax) {
      civEdPts = civEdMax;
    }
    totalPts = milTrainPts + awardsTotal + milEdPts + civEdPts;
  }

  _savePpw(BuildContext context, PPW ppw) {
    final f = new DateFormat('yyyyMMdd');
    final date = f.format(DateTime.now());
    final _dateController = TextEditingController(text: date);
    final _nameController = TextEditingController();
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _dateController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      regExp.hasMatch(value) ? null : 'Use yyyyMMdd Format',
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
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    ppw.name = _nameController.text;
                    ppw.date = _dateController.text;
                    dbHelper.savePPW(ppw);
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SavedPpwsPage(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _delete(int index, String type) {
    final title = Text('Delete $type?');
    final content = Text('Are you sure you want to delete this $type?');
    final textStyle = TextStyle(color: Theme.of(context).colorScheme.onPrimary);

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context2) => CupertinoAlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel', style: textStyle),
                    onPressed: () {
                      Navigator.pop(context2);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Delete', style: textStyle),
                    onPressed: () {
                      Navigator.pop(context2);
                      _deleteAward(index, type);
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context2) {
            return AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel', style: textStyle),
                  onPressed: () {
                    Navigator.pop(context2);
                  },
                ),
                TextButton(
                  child: Text('Delete', style: textStyle),
                  onPressed: () {
                    Navigator.pop(context2);
                    _deleteAward(index, type);
                  },
                )
              ],
            );
          });
    }
  }

  void _deleteAward(int index, String type) {
    setState(() {
      if (type == 'Decoration') {
        _decorations.removeAt(index);
        _calcAwardPts();
      } else {
        _badges.removeAt(index);
        _calcBadgePts();
      }
      _calcTotalPts();
    });
  }

  List<Widget> _decorationWidgets() {
    List<Widget> decorations = [];
    for (int i = 0; i < _decorations.length; i++) {
      decorations.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onLongPress: () => _delete(i, 'Decoration'),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: _decorations[i]['name'],
                      decoration:
                          const InputDecoration(labelText: 'Decoration'),
                      items: awards.map((award) {
                        return DropdownMenuItem(
                          child: Text(
                            award,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: award,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _decorations[i]['name'] = value;
                          _calcAwardPts();
                          _calcTotalPts();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 60,
                      child: TextFormField(
                        initialValue: _decorations[i]['number'].toString(),
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            _decorations[i]['number'] = raw;
                            _calcAwardPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return decorations;
  }

  List<Widget> _badgeWidgets() {
    List<Widget> badgeWidgets = [];
    for (int i = 0; i < _badges.length; i++) {
      badgeWidgets.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onLongPress: () => _delete(i, 'Badge'),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: _badges[i]['name'],
                decoration: const InputDecoration(labelText: 'Badge'),
                items: badges.map((badge) {
                  return DropdownMenuItem(
                    child: Text(badge, overflow: TextOverflow.ellipsis),
                    value: badge,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _badges[i]['name'] = value;
                    _calcBadgePts();
                    _calcTotalPts();
                  });
                },
              ),
            ),
          ),
        ),
      ));
    }
    return badgeWidgets;
  }

  @override
  void dispose() {
    super.dispose();
    _apftController.dispose();
    _weaponController.dispose();
    _wbcController.dispose();
    _resCourseController.dispose();
    _semHrsController.dispose();
    _mosCertsController.dispose();
    _crossCertsController.dispose();
    _personalCertsController.dispose();

    _apftFocus.dispose();
    _weaponFocus.dispose();
    _wbcFocus.dispose();
    _resFocus.dispose();
    _semHrsFocus.dispose();
    _mosCertsFocus.dispose();
    _crossCertsFocus.dispose();
    _personalCertsFocus.dispose();
  }

  @override
  void initState() {
    dbHelper = new DBHelper();

    ptScore = 0;
    ptPts = 0;
    weaponHits = 0;
    weaponPts = 0;
    milTrainPts = 0;
    awardPts = 0;
    badgePts = 0;
    airbornePts = 0;
    awardsTotal = 0;
    ncoesPts = 0;
    wbcHrs = 0;
    wbcPts = 0;
    resHrs = 0;
    resPts = 0;
    tabPts = 0;
    ar350Pts = 0;
    milEdPts = 0;
    semHrs = 0;
    semHrPts = 0;
    mosCerts = 0;
    crossCerts = 0;
    personalCerts = 0;
    certPts = 0;
    degreePts = 0;
    langPts = 0;
    civEdPts = 0;
    totalPts = 0;

    milTrainMax = 340;
    awardsMax = 125;
    milEdMax = 200;
    civEdMax = 135;

    newVersion = false;
    ptValid = true;
    weaponValid = true;
    coaValid = true;
    wbcValid = true;
    resValid = true;
    semValid = true;
    certValid = true;

    weapons = 'DA 3595-R / 5790-R / 5789-R / 7801 (M16/M4)';
    ncoes = 'None';
    airborneLvl = 'None';

    _apftController.text = ptScore.toString();
    _weaponController.text = weaponHits.toString();
    _wbcController.text = wbcHrs.toString();
    _resCourseController.text = resHrs.toString();
    _semHrsController.text = semHrs.toString();
    _mosCertsController.text = mosCerts.toString();
    _crossCertsController.text = crossCerts.toString();
    _personalCertsController.text = personalCerts.toString();

    _apftFocus.addListener(() {
      if (_apftFocus.hasFocus) {
        _apftController.selection = TextSelection(
            baseOffset: 0, extentOffset: _apftController.text.length);
      }
    });
    _weaponFocus.addListener(() {
      if (_weaponFocus.hasFocus) {
        _weaponController.selection = TextSelection(
            baseOffset: 0, extentOffset: _weaponController.text.length);
      }
    });
    _wbcFocus.addListener(() {
      if (_wbcFocus.hasFocus) {
        _wbcController.selection = TextSelection(
            baseOffset: 0, extentOffset: _wbcController.text.length);
      }
    });
    _resFocus.addListener(() {
      if (_resFocus.hasFocus) {
        _resCourseController.selection = TextSelection(
            baseOffset: 0, extentOffset: _resCourseController.text.length);
      }
    });
    _semHrsFocus.addListener(() {
      if (_semHrsFocus.hasFocus) {
        _semHrsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _semHrsController.text.length);
      }
    });
    _mosCertsFocus.addListener(() {
      if (_mosCertsFocus.hasFocus) {
        _mosCertsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _mosCertsController.text.length);
      }
    });
    _crossCertsFocus.addListener(() {
      if (_crossCertsFocus.hasFocus) {
        _crossCertsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _crossCertsController.text.length);
      }
    });
    _personalCertsFocus.addListener(() {
      if (_personalCertsFocus.hasFocus) {
        _personalCertsController.selection = TextSelection(
            baseOffset: 0, extentOffset: _personalCertsController.text.length);
      }
    });

    ranger = false;
    sf = false;
    sapper = false;
    degree = false;
    fornLang = false;

    regExp = new RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('rank') != null) {
      setState(() {
        rank = prefs.getString('rank');
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView.count(
                crossAxisCount: width > 700 ? 2 : 1,
                childAspectRatio: width > 700 ? width / 230 : width / 115,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  FormattedRadio(
                      titles: ['SGT', 'SSG'],
                      values: ['SGT', 'SSG'],
                      groupValue: rank,
                      onChanged: (value) {
                        setState(() {
                          rank = value;
                          _resetMaximums();
                          _calcPtPts();
                          _calcWeaponPts();
                          _calcTotalPts();
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: SwitchListTile(
                      activeColor: Theme.of(context).colorScheme.onSecondary,
                      title: Text(
                          newVersion ? 'After 1 Apr 23' : 'Before 1 Apr 23'),
                      value: newVersion,
                      onChanged: (value) {
                        setState(() {
                          newVersion = value;
                          _resetMaximums();
                          _calcPtPts();
                          _calcWeaponPts();
                          _calcAwardPts();
                          _calcBadgePts();
                          _calcAirbornePts();
                          _calcResPts();
                          _calcWbcPts();
                          _calcCertPts();
                          _calcTotalPts();
                        });
                      },
                    ),
                  ),
                ]),
            FormattedExpansionTile(
              title: 'Military Training',
              trailing: '$milTrainPts/$milTrainMax',
              initiallyExpanded: true,
              children: [
                GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 230 : width / 115,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _apftController,
                          focusNode: _apftFocus,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                              label: Text(
                                  (newVersion ? 'ACFT' : 'APFT') + ' Score'),
                              border: OutlineInputBorder(),
                              errorText: ptValid
                                  ? null
                                  : newVersion
                                      ? '0-600'
                                      : '0-300'),
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? 0;
                            setState(() {
                              if (raw < 0) {
                                ptScore = 0;
                                ptValid = false;
                              } else if ((newVersion && raw > 600) ||
                                  (!newVersion && raw > 300)) {
                                ptScore = newVersion ? 600 : 300;
                                ptValid = false;
                              } else {
                                ptScore = raw;
                                ptValid = true;
                              }
                              _calcPtPts();
                              _calcTotalPts();
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _weaponController,
                          focusNode: _weaponFocus,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                              label: Text('Weapons Hits'),
                              border: OutlineInputBorder(),
                              errorText: weaponValid ? null : '0-300'),
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? 0;
                            setState(() {
                              if (raw < 0) {
                                weaponHits = 0;
                                weaponValid = false;
                              } else if (raw > 300) {
                                weaponHits = 300;
                                weaponValid = false;
                              } else {
                                weaponHits = raw;
                                weaponValid = true;
                              }
                              _calcWeaponPts();
                              _calcTotalPts();
                            });
                          },
                        ),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: weapons,
                    decoration:
                        const InputDecoration(labelText: 'Weapons Card'),
                    items: weaponCards.map((card) {
                      return DropdownMenuItem(
                        child: Text(card, overflow: TextOverflow.ellipsis),
                        value: card,
                      );
                    }).toList(),
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        weapons = value;
                        _calcWeaponPts();
                        _calcTotalPts();
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Divider(color: Theme.of(context).colorScheme.onSecondary),
            ),
            FormattedExpansionTile(
              title: 'Awards',
              trailing: '$awardsTotal/$awardsMax',
              initiallyExpanded: false,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Decorations',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            iconSize: 35,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _decorations.add({'name': 'None', 'number': 0});
                              });
                            },
                            icon: Icon(Icons.add))
                      ],
                    ),
                  ),
                ),
                if (_decorations.length > 0)
                  GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 230 : width / 115,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    shrinkWrap: true,
                    primary: false,
                    children: _decorationWidgets(),
                  ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Badges',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            iconSize: 35,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _badges.add({'name': 'None'});
                              });
                            },
                            icon: Icon(Icons.add))
                      ],
                    ),
                  ),
                ),
                if (_badges.length > 0)
                  GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 230 : width / 115,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    shrinkWrap: true,
                    primary: false,
                    children: _badgeWidgets(),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: DropdownButtonFormField(
                    value: airborneLvl,
                    decoration:
                        const InputDecoration(labelText: 'Airborne Advantage'),
                    items: airborne.map((ab) {
                      return DropdownMenuItem(
                        child: Text(ab),
                        value: ab,
                      );
                    }).toList(),
                    onChanged: (value) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        airborneLvl = value;
                        _calcAirbornePts();
                        _calcTotalPts();
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(color: Theme.of(context).colorScheme.onSecondary),
            ),
            FormattedExpansionTile(
              title: 'Military Education',
              trailing: '$milEdPts/$milEdMax',
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: DropdownButtonFormField(
                    value: ncoes,
                    decoration:
                        const InputDecoration(labelText: 'NCOES Honors'),
                    items: ncoesHonors.map((honors) {
                      return DropdownMenuItem(
                        child: Text(honors),
                        value: honors,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ncoes = value;
                        _calcNcoesPts();
                        _calcTotalPts();
                      });
                    },
                  ),
                ),
                GridView.count(
                  crossAxisCount: width > 700 ? 2 : 1,
                  childAspectRatio: width > 700 ? width / 230 : width / 115,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _resCourseController,
                        focusNode: _resFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: const InputDecoration(
                          label: Text('Resident Course Hours'),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            if (raw < 0) {
                              resHrs = 0;
                            } else {
                              resHrs = raw;
                            }
                            _calcResPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _wbcController,
                        focusNode: _wbcFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: const InputDecoration(
                          label: Text('Web-Based Course Hours'),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            if (raw < 0) {
                              wbcHrs = 0;
                            } else {
                              wbcHrs = raw;
                            }
                            _calcWbcPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.count(
                      crossAxisCount: width > 800
                          ? 3
                          : width > 400
                              ? 2
                              : 1,
                      childAspectRatio: width > 800
                          ? width / 300
                          : width > 400
                              ? width / 200
                              : width / 100,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      shrinkWrap: true,
                      primary: false,
                      children: [
                        CheckboxListTile(
                            title: const Text('Ranger'),
                            activeColor:
                                Theme.of(context).colorScheme.onSecondary,
                            value: ranger,
                            onChanged: (value) {
                              setState(() {
                                ranger = value;
                                _calcTabPts();
                                _calcTotalPts();
                              });
                            }),
                        CheckboxListTile(
                            title: const Text('Special Forces'),
                            activeColor:
                                Theme.of(context).colorScheme.onSecondary,
                            value: sf,
                            onChanged: (value) {
                              setState(() {
                                sf = value;
                                _calcTabPts();
                                _calcTotalPts();
                              });
                            }),
                        CheckboxListTile(
                            title: const Text('Sapper'),
                            activeColor:
                                Theme.of(context).colorScheme.onSecondary,
                            value: sapper,
                            onChanged: (value) {
                              setState(() {
                                sapper = value;
                                _calcTabPts();
                                _calcTotalPts();
                              });
                            }),
                      ]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: Theme.of(context).colorScheme.onSecondary),
            ),
            FormattedExpansionTile(
              title: 'Civilian Education',
              trailing: '$civEdPts/$civEdMax',
              initiallyExpanded: false,
              children: [
                GridView.count(
                  crossAxisCount: width > 700 ? 2 : 1,
                  childAspectRatio: width > 700 ? width / 230 : width / 115,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _semHrsController,
                        focusNode: _semHrsFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: const InputDecoration(
                          label: Text('Semester Hours'),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            if (raw < 0) {
                              semHrs = 0;
                            } else {
                              semHrs = raw;
                            }
                            _calcSemPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        value: degree,
                        title: const Text(
                          'Degree',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text('Must have been completed ' +
                            (rank == 'SGT'
                                ? 'since joining Active Duty'
                                : 'in current grade')),
                        onChanged: (value) {
                          setState(() {
                            degree = value;
                            _calcDegreePts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _mosCertsController,
                        focusNode: _mosCertsFocus,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          label: Text(newVersion
                              ? 'MOS Enhancing Credentials'
                              : 'Tech/Pro Certifications'),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            if (raw < 0) {
                              mosCerts = 0;
                            } else {
                              mosCerts = raw;
                            }
                            _calcCertPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                    if (newVersion)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _crossCertsController,
                          focusNode: _crossCertsFocus,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: const InputDecoration(
                            label: Text('Cross-Functional Credentials'),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? 0;
                            setState(() {
                              if (raw < 0) {
                                crossCerts = 0;
                              } else {
                                crossCerts = raw;
                              }
                              _calcCertPts();
                              _calcTotalPts();
                            });
                          },
                        ),
                      ),
                    if (newVersion)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _personalCertsController,
                          focusNode: _personalCertsFocus,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: const InputDecoration(
                            label: Text('Personal Credentials'),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            int raw = int.tryParse(value) ?? 0;
                            setState(() {
                              if (raw < 0) {
                                personalCerts = 0;
                              } else {
                                personalCerts = raw;
                              }
                              _calcCertPts();
                              _calcTotalPts();
                            });
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        value: fornLang,
                        title: const Text(
                          'Foreign Language',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: const Text('Valid for one year'),
                        onChanged: (value) {
                          setState(() {
                            fornLang = value;
                            _calcLangPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Points',
                          style: TextStyle(
                              fontSize: 22,
                              color:
                                  Theme.of(context).colorScheme.onSecondary)),
                      Text('$totalPts/800',
                          style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onSecondary))
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary)),
                child: const Text('Save Promotion Point Score'),
                onPressed: () {
                  if (widget.isPremium) {
                    PPW ppw = new PPW(
                      null,
                      null,
                      null,
                      rank,
                      newVersion ? 1 : 0,
                      ptPts,
                      weaponPts,
                      awardPts,
                      badgePts,
                      airbornePts,
                      ncoesPts,
                      wbcPts,
                      resPts,
                      tabPts,
                      ar350Pts,
                      semHrPts,
                      degreePts,
                      certPts,
                      langPts,
                      milTrainMax,
                      awardsMax,
                      milEdMax,
                      civEdMax,
                      totalPts,
                    );
                    _savePpw(context, ppw);
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
