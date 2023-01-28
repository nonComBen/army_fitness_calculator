import 'dart:io';

import 'package:acft_calculator/providers/purchases_provider.dart';
import 'package:acft_calculator/services/purchases_service.dart';
import 'package:acft_calculator/widgets/platform_widgets/platform_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../calculators/award_pts_calculator.dart';
import '../../calculators/pt_pts_calculator.dart';
import '../../calculators/weapons_pts_calculator.dart';
import '../../providers/shared_preferences_provider.dart';
import '../saved_pages/saved_ppw_page.dart';
import '../../sqlite/db_helper.dart';
import '../../sqlite/ppw.dart';
import '../../widgets/formatted_expansion_tile.dart';
import '../../widgets/formatted_radio.dart';
import '../../widgets/badge_card.dart';
import '../../widgets/decoration_card.dart';
import '../../classes/award_decoration.dart';
import '../../widgets/formatted_text_field.dart';

class PromotionPointPage extends ConsumerStatefulWidget {
  PromotionPointPage();

  static const String title = 'Promotion Points';

  @override
  _PromotionPointPageState createState() => _PromotionPointPageState();
}

class _PromotionPointPageState extends ConsumerState<PromotionPointPage> {
  int ptScore = 0,
      ptPts = 0,
      weaponHits = 0,
      weaponPts = 0,
      milTrainPts = 0,
      awardPts = 0,
      badgePts = 0,
      airbornePts = 0,
      awardsTotal = 0,
      ncoesPts = 0,
      wbcHrs = 0,
      wbcPts = 0,
      resHrs = 0,
      resPts = 0,
      tabPts = 0,
      ar350Pts = 0,
      milEdPts = 0,
      semHrs = 0,
      semHrPts = 0,
      mosCerts = 0,
      crossCerts = 0,
      personalCerts = 0,
      certPts = 0,
      degreePts = 0,
      langPts = 0,
      civEdPts = 0,
      totalPts = 0,
      milTrainMax = 340,
      awardsMax = 125,
      milEdMax = 200,
      civEdMax = 135;
  String rank = 'SGT',
      weapons = 'DA 3595-R / 5790-R / 5789-R / 7801 (M16/M4)',
      airborneLvl = 'None',
      ncoes = 'None';
  bool isRanger = false,
      isSf = false,
      isSapper = false,
      degreeCompleted = false,
      hasFornLang = false,
      isNewVersion = false,
      isPtValid = true,
      isWeaponValid = true,
      isCoaValid = true,
      isWbcValid = true,
      isResValid = true,
      isSemValid = true,
      isCertValid = true;
  late SharedPreferences prefs;
  RegExp regExp = RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
  DBHelper dbHelper = DBHelper();
  late PurchasesService purchasesService;

  List<AwardDecoration> decorations = [];
  List<dynamic> _badges = [];
  final List<String> versions = ['Before 1 Apr 23', 'After 1 Apr 23'];
  final List<String> proRanks = ['SGT', 'SSG'];
  final List<String> weaponCards = [
    'DA 3595-R / 5790-R / 5789-R / 7801 (M16/M4)',
    'DA 85 (M240B/M60/M249)',
    'DA 88-R (M9)',
    'DA 7814',
    'DA 5704 (Alt M9)',
    'DA 7304-R (M249 AR)',
    'CID (Practical Pistol)',
    'DA 7820-1',
  ];
  final List<String> airborne = [
    'None',
    'Basic',
    'Senior',
    'Master',
  ];

  final List<String> ncoesHonors = [
    'None',
    'Commandant\'s List',
    'Distinguished Leader',
    'Distinguished Honor Grad',
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
    super.initState();

    purchasesService = ref.read(purchasesProvider);

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

    prefs = ref.read(sharedPreferencesProvider);

    if (prefs.getString('rank') != null) {
      setState(() {
        rank = prefs.getString('rank')!;
      });
    }
  }

  void _resetMaximums() {
    if (rank == 'SGT') {
      if (isNewVersion) {
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
      if (isNewVersion) {
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
    if (isNewVersion) {
      ptPts = acftPts(ptScore);
    } else {
      ptPts = apftPts(ptScore, rank);
    }
  }

  void _calcWeaponPts() {
    weaponPts = newWeaponsPts(
        weaponCards.indexOf(weapons), rank, weaponHits, isNewVersion);
  }

  void _calcAwardPts() {
    awardPts = calcAwardpts(decorations);
  }

  void _calcBadgePts() {
    badgePts = newBadgePts(_badges, isNewVersion);
  }

  void _calcAirbornePts() {
    int index = airborne.indexOf(airborneLvl);
    if (isNewVersion) {
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
    if (isRanger) {
      tabPts += 40;
    }
    if (isSf) {
      tabPts += 40;
    }
    if (isSapper) {
      tabPts += 40;
    }
    _calcResPts();
  }

  void _calcResPts() {
    resPts = (resHrs / 10).floor() + tabPts;
    if (isNewVersion) {
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
    if (!isNewVersion && rank == 'SGT' && wbcPts > 80) {
      wbcPts = 80;
    } else if (wbcPts > 90) {
      wbcPts = 90;
    }
  }

  void _calcSemPts() {
    semHrPts = semHrs * 2;
  }

  void _calcDegreePts() {
    if (degreeCompleted) {
      degreePts = 20;
    } else {
      degreePts = 0;
    }
  }

  void _calcLangPts() {
    if (hasFornLang) {
      langPts = 25;
    } else {
      langPts = 0;
    }
  }

  void _calcCertPts() {
    if (isNewVersion) {
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
                      regExp.hasMatch(value!) ? null : 'Use yyyyMMdd Format',
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
                child: PlatformButton(
                  child: Text('Save'),
                  onPressed: () {
                    ppw.name = _nameController.text;
                    ppw.date = _dateController.text;
                    dbHelper.savePPW(ppw);
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushNamed(SavedPpwsPage.routeName);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAwardWarning(int index, String awardType) {
    final title = Text('Delete $awardType?');
    final content = Text('Are you sure you want to delete this $awardType?');
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
                      _deleteAward(index, awardType);
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
                    _deleteAward(index, awardType);
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
        decorations.removeAt(index);
        _calcAwardPts();
      } else {
        _badges.removeAt(index);
        _calcBadgePts();
      }
      _calcTotalPts();
    });
  }

  List<Widget> _decorationWidgets() {
    List<Widget> decorationCards = [];
    for (int i = 0; i < decorations.length; i++) {
      decorationCards.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DecorationCard(
            onLongPressed: () => _deleteAwardWarning(i, 'Decoration'),
            decoration: decorations[i],
            onAwardChosen: (value) {
              setState(() {
                decorations[i].name = value;
                _calcAwardPts();
                _calcTotalPts();
              });
            },
            onAwardNumberChanged: (value) {
              int raw = int.tryParse(value) ?? 0;
              setState(() {
                decorations[i].number = raw;
                _calcAwardPts();
                _calcTotalPts();
              });
            },
          ),
        ),
      );
    }
    return decorationCards;
  }

  List<Widget> _badgeWidgets() {
    List<Widget> badgeWidgets = [];
    for (int i = 0; i < _badges.length; i++) {
      badgeWidgets.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: BadgeCard(
          onLongPressed: () => _deleteAwardWarning(i, 'Badge'),
          badgeName: _badges[i]['name'],
          onBadgeChosen: (value) {
            setState(() {
              _badges[i]['name'] = value;
              _calcBadgePts();
              _calcTotalPts();
            });
          },
        ),
      ));
    }
    return badgeWidgets;
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
                          rank = value!;
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
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: SwitchListTile(
                      activeColor: Theme.of(context).colorScheme.onSecondary,
                      title: Text(
                          isNewVersion ? 'After 1 Apr 23' : 'Before 1 Apr 23'),
                      value: isNewVersion,
                      onChanged: (value) {
                        setState(() {
                          isNewVersion = value;
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
                      FormattedTextField(
                        contoller: _apftController,
                        focusNode: _apftFocus,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _weaponFocus.requestFocus(),
                        label: (isNewVersion ? 'ACFT' : 'APFT') + ' Score',
                        errorText: isPtValid
                            ? null
                            : isNewVersion
                                ? '0-600'
                                : '0-300',
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            if (raw < 0) {
                              ptScore = 0;
                              isPtValid = false;
                            } else if ((isNewVersion && raw > 600) ||
                                (!isNewVersion && raw > 300)) {
                              ptScore = isNewVersion ? 600 : 300;
                              isPtValid = false;
                            } else {
                              ptScore = raw;
                              isPtValid = true;
                            }
                            _calcPtPts();
                            _calcTotalPts();
                          });
                        },
                      ),
                      FormattedTextField(
                        contoller: _weaponController,
                        focusNode: _weaponFocus,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        label: 'Weapons Hits',
                        errorText: isWeaponValid ? null : '0-300',
                        onChanged: (value) {
                          int raw = int.tryParse(value) ?? 0;
                          setState(() {
                            if (raw < 0) {
                              weaponHits = 0;
                              isWeaponValid = false;
                            } else if (raw > 300) {
                              weaponHits = 300;
                              isWeaponValid = false;
                            } else {
                              weaponHits = raw;
                              isWeaponValid = true;
                            }
                            _calcWeaponPts();
                            _calcTotalPts();
                          });
                        },
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
                    onChanged: (dynamic value) {
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
                                decorations.add(
                                    AwardDecoration(name: 'None', number: 0));
                              });
                            },
                            icon: Icon(Icons.add))
                      ],
                    ),
                  ),
                ),
                if (decorations.length > 0)
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
                    onChanged: (dynamic value) {
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
                    onChanged: (dynamic value) {
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
                    FormattedTextField(
                      contoller: _resCourseController,
                      focusNode: _resFocus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => _wbcFocus.requestFocus(),
                      label: 'Resident Course Hours',
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
                    FormattedTextField(
                      contoller: _wbcController,
                      focusNode: _wbcFocus,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      label: 'Web-Based Course Hours',
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
                            value: isRanger,
                            onChanged: (value) {
                              setState(() {
                                isRanger = value!;
                                _calcTabPts();
                                _calcTotalPts();
                              });
                            }),
                        CheckboxListTile(
                            title: const Text('Special Forces'),
                            activeColor:
                                Theme.of(context).colorScheme.onSecondary,
                            value: isSf,
                            onChanged: (value) {
                              setState(() {
                                isSf = value!;
                                _calcTabPts();
                                _calcTotalPts();
                              });
                            }),
                        CheckboxListTile(
                            title: const Text('Sapper'),
                            activeColor:
                                Theme.of(context).colorScheme.onSecondary,
                            value: isSapper,
                            onChanged: (value) {
                              setState(() {
                                isSapper = value!;
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
                    FormattedTextField(
                      contoller: _semHrsController,
                      focusNode: _semHrsFocus,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      label: 'Semester Hours',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        value: degreeCompleted,
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
                            degreeCompleted = value!;
                            _calcDegreePts();
                            _calcTotalPts();
                          });
                        },
                      ),
                    ),
                    FormattedTextField(
                      contoller: _mosCertsController,
                      focusNode: _mosCertsFocus,
                      textInputAction: isNewVersion
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onEditingComplete: () => isNewVersion
                          ? _crossCertsFocus.requestFocus()
                          : FocusScope.of(context).unfocus(),
                      label: isNewVersion
                          ? 'MOS Enhancing Credentials'
                          : 'Tech/Pro Certifications',
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
                    if (isNewVersion)
                      FormattedTextField(
                        contoller: _crossCertsController,
                        focusNode: _crossCertsFocus,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            _personalCertsFocus.requestFocus(),
                        label: 'Cross-Functional Credentials',
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
                    if (isNewVersion)
                      FormattedTextField(
                        contoller: _personalCertsController,
                        focusNode: _personalCertsFocus,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        label: 'Personal Credentials',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        value: hasFornLang,
                        title: const Text(
                          'Foreign Language',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: const Text('Valid for one year'),
                        onChanged: (value) {
                          setState(() {
                            hasFornLang = value!;
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
              child: PlatformButton(
                child: const Text('Save Promotion Point Score'),
                onPressed: () {
                  if (purchasesService.isPremium) {
                    PPW ppw = PPW(
                      id: null,
                      date: null,
                      name: null,
                      rank: rank,
                      version: isNewVersion ? 1 : 0,
                      ptTest: ptPts,
                      weapons: weaponPts,
                      awards: awardPts,
                      badges: badgePts,
                      airborne: airbornePts,
                      ncoes: ncoesPts,
                      wbc: wbcPts,
                      resident: resPts,
                      tabs: tabPts,
                      ar350: ar350Pts,
                      semesterHours: semHrPts,
                      degree: degreePts,
                      certs: certPts,
                      language: langPts,
                      milTrainMax: milTrainMax,
                      awardsMax: awardsMax,
                      milEdMax: milEdMax,
                      civEdMax: civEdMax,
                      total: totalPts,
                    );
                    _savePpw(context, ppw);
                  } else {
                    purchasesService.upgradeNeeded(context);
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
