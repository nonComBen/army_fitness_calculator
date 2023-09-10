import 'dart:io';

import 'package:acft_calculator/providers/tracking_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../methods/theme_methods.dart';
import '../../providers/premium_state_provider.dart';
import '../../widgets/platform_widgets/platform_item_picker.dart';
import '../../methods/platform_show_modal_bottom_sheet.dart';
import '../../providers/purchases_provider.dart';
import '../../services/purchases_service.dart';
import '../../widgets/platform_widgets/platform_button.dart';
import '../../calculators/award_pts_calculator.dart';
import '../../calculators/pt_pts_calculator.dart';
import '../../calculators/weapons_pts_calculator.dart';
import '../../providers/shared_preferences_provider.dart';
import '../../widgets/platform_widgets/platform_checkbox_list_tile.dart';
import '../../widgets/platform_widgets/platform_expansion_list_tile.dart';
import '../../widgets/platform_widgets/platform_icon_button.dart';
import '../../widgets/platform_widgets/platform_text_field.dart';
import '../saved_pages/saved_ppw_page.dart';
import '../../sqlite/db_helper.dart';
import '../../sqlite/ppw.dart';
import '../../widgets/platform_widgets/platform_selection_widget.dart';
import '../../widgets/badge_card.dart';
import '../../widgets/decoration_card.dart';
import '../../classes/award_decoration.dart';

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
  String weapons = '(M16/M4) DA 3595-R / 5790-R / 5789-R / 7801',
      airborneLvl = 'None',
      ncoes = 'None';
  Object rank = 'SGT', version = 'newVersion';
  bool isRanger = false,
      isSf = false,
      isSapper = false,
      degreeCompleted = false,
      hasFornLang = false,
      isNewVersion = true,
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
  late TextStyle expansionTextStyle;
  late Color primaryColor;
  late Color onPrimaryColor;
  late BannerAd myBanner;

  List<AwardDecoration> decorations = [];
  List<dynamic> _badges = [];
  final List<String> versions = ['Before 1 Apr 23', 'After 1 Apr 23'];
  final List<String> proRanks = ['SGT', 'SSG'];
  final List<String> weaponCards = [
    '(M16/M4) DA 3595-R / 5790-R / 5789-R / 7801',
    '(M240B/M60/M249) DA 85',
    '(M9) DA 88-R',
    'DA 7814',
    '(Alt M9) DA 5704',
    '(M249 AR)DA 7304-R',
    '(Practical Pistol) CID',
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

    myBanner.dispose();
  }

  @override
  void initState() {
    super.initState();

    prefs = ref.read(sharedPreferencesProvider);

    purchasesService = ref.read(purchasesProvider);
    bool trackingAllowed = ref.read(trackingProvider).trackingAllowed;

    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/3104815499'
          : 'ca-app-pub-2431077176117105/7432472116',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest(nonPersonalizedAds: !trackingAllowed),
    );
    myBanner.load();

    if (prefs.getString('rank') != null) {
      rank = prefs.getString('rank').toString();
    }

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

    _resetMaximums();
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
      ptPts = apftPts(ptScore, rank.toString());
    }
  }

  void _calcWeaponPts() {
    weaponPts = newWeaponsPts(weaponCards.indexOf(weapons), rank.toString(),
        weaponHits, isNewVersion);
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
                child: PlatformTextField(
                  controller: _nameController,
                  label: 'Name',
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
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(SavedPpwsPage.routeName);
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
    final textStyle = TextStyle(color: onPrimaryColor);

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
            onSelectedItemChanged: (index) {
              setState(() {
                decorations[i].name = DecorationCard.awards[index];
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
          onSelectedItemChanged: (index) {
            setState(() {
              _badges[i]['name'] = BadgeCard.badges[index];
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
    final isPremium =
        ref.read(premiumStateProvider) || (prefs.getBool('isPremium') ?? false);
    primaryColor = getPrimaryColor(context);
    onPrimaryColor = getOnPrimaryColor(context);
    final width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).viewPadding.left -
        MediaQuery.of(context).viewPadding.right;
    expansionTextStyle = TextStyle(color: onPrimaryColor, fontSize: 22);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 180 : width / 90,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformSelectionWidget(
                            titles: [Text('SGT'), Text('SSG')],
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformSelectionWidget(
                          titles: [
                            Text('Before 1 Apr 23'),
                            Text('After 1 Apr 23')
                          ],
                          values: ['oldVersion', 'newVersion'],
                          groupValue: version,
                          onChanged: (value) {
                            setState(() {
                              version = value!;
                              isNewVersion = version == 'newVersion';
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
                PlatformExpansionTile(
                  title: Text(
                    'Military Training',
                    style: expansionTextStyle,
                  ),
                  trailing: Text(
                    '$milTrainPts/$milTrainMax',
                    style: expansionTextStyle,
                  ),
                  initiallyExpanded: true,
                  collapsedBackgroundColor: primaryColor,
                  children: [
                    GridView.count(
                        crossAxisCount: width > 700 ? 2 : 1,
                        childAspectRatio:
                            width > 700 ? width / 230 : width / 115,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          PlatformTextField(
                            controller: _apftController,
                            focusNode: _apftFocus,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                            ],
                            onEditingComplete: () =>
                                _weaponFocus.requestFocus(),
                            label: (isNewVersion ? 'ACFT' : 'APFT') + ' Score',
                            decoration: InputDecoration(
                              label: Text(
                                  (isNewVersion ? 'ACFT' : 'APFT') + ' Score'),
                            ),
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
                          PlatformTextField(
                            controller: _weaponController,
                            focusNode: _weaponFocus,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                            ],
                            label: 'Weapons Hits',
                            decoration: InputDecoration(
                              label: const Text('Weapons Hits'),
                            ),
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
                      child: PlatformItemPicker(
                        value: weapons,
                        label: Text(
                          'Weapons Card',
                          style: TextStyle(
                            color: getTextColor(context),
                          ),
                        ),
                        items: weaponCards,
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
                  child: Divider(color: onPrimaryColor),
                ),
                PlatformExpansionTile(
                  title: Text(
                    'Awards',
                    style: expansionTextStyle,
                  ),
                  trailing: Text(
                    '$awardsTotal/$awardsMax',
                    style: expansionTextStyle,
                  ),
                  collapsedBackgroundColor: primaryColor,
                  initiallyExpanded: false,
                  children: [
                    Card(
                      color: getContrastingBackgroundColor(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Decorations',
                              style: TextStyle(fontSize: 18),
                            ),
                            PlatformIconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    decorations.add(AwardDecoration(
                                        name: 'None', number: 0));
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: 35,
                                ))
                          ],
                        ),
                      ),
                    ),
                    if (decorations.length > 0)
                      GridView.count(
                        crossAxisCount: width > 700 ? 2 : 1,
                        childAspectRatio:
                            width > 700 ? width / 230 : width / 115,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                        shrinkWrap: true,
                        primary: false,
                        children: _decorationWidgets(),
                      ),
                    Card(
                      color: getContrastingBackgroundColor(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Badges',
                              style: TextStyle(fontSize: 18),
                            ),
                            PlatformIconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _badges.add({'name': 'None'});
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                size: 35,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (_badges.length > 0)
                      GridView.count(
                        crossAxisCount: width > 700 ? 2 : 1,
                        childAspectRatio:
                            width > 700 ? width / 230 : width / 115,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                        shrinkWrap: true,
                        primary: false,
                        children: _badgeWidgets(),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PlatformItemPicker(
                        value: airborneLvl,
                        label: Text(
                          'Airborne Advantage',
                          style: TextStyle(
                            color: getTextColor(context),
                          ),
                        ),
                        items: airborne,
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
                  child: Divider(color: onPrimaryColor),
                ),
                PlatformExpansionTile(
                  title: Text(
                    'Military Education',
                    style: expansionTextStyle,
                  ),
                  trailing: Text(
                    '$milEdPts/$milEdMax',
                    style: expansionTextStyle,
                  ),
                  initiallyExpanded: false,
                  collapsedBackgroundColor: primaryColor,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: PlatformItemPicker(
                        value: ncoes,
                        label: Text(
                          'NCOES Honors',
                          style: TextStyle(
                            color: getTextColor(context),
                          ),
                        ),
                        items: ncoesHonors,
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
                        PlatformTextField(
                          controller: _resCourseController,
                          focusNode: _resFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          onEditingComplete: () => _wbcFocus.requestFocus(),
                          label: 'Resident Course Hours',
                          decoration: InputDecoration(
                            label: const Text('Resident Course Hours'),
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
                        PlatformTextField(
                          controller: _wbcController,
                          focusNode: _wbcFocus,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          label: 'Web-Based Course Hours',
                          decoration: InputDecoration(
                            label: const Text('Web-Based Course Hours'),
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
                              ? width / 225
                              : width > 400
                                  ? width / 150
                                  : width / 75,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 1.0,
                          shrinkWrap: true,
                          primary: false,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Platform.isIOS ? 20.0 : 8),
                              child: PlatformCheckboxListTile(
                                title: const Text('Ranger'),
                                activeColor: onPrimaryColor,
                                value: isRanger,
                                onChanged: (value) {
                                  setState(() {
                                    isRanger = value!;
                                    _calcTabPts();
                                    _calcTotalPts();
                                  });
                                },
                                onIosTap: () {
                                  setState(() {
                                    isRanger = !isRanger;
                                    _calcTabPts();
                                    _calcTotalPts();
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Platform.isIOS ? 20.0 : 8),
                              child: PlatformCheckboxListTile(
                                title: const Text('Special Forces'),
                                activeColor: onPrimaryColor,
                                value: isSf,
                                onChanged: (value) {
                                  setState(() {
                                    isSf = value!;
                                    _calcTabPts();
                                    _calcTotalPts();
                                  });
                                },
                                onIosTap: () {
                                  setState(() {
                                    isSf = !isSf;
                                    _calcTabPts();
                                    _calcTotalPts();
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Platform.isIOS ? 20.0 : 8),
                              child: PlatformCheckboxListTile(
                                title: const Text('Sapper'),
                                activeColor: onPrimaryColor,
                                value: isSapper,
                                onChanged: (value) {
                                  setState(() {
                                    isSapper = value!;
                                    _calcTabPts();
                                    _calcTotalPts();
                                  });
                                },
                                onIosTap: () {
                                  setState(() {
                                    isSapper = !isSapper;
                                    _calcTabPts();
                                    _calcTotalPts();
                                  });
                                },
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: onPrimaryColor),
                ),
                PlatformExpansionTile(
                  title: Text(
                    'Civilian Education',
                    style: expansionTextStyle,
                  ),
                  trailing: Text(
                    '$civEdPts/$civEdMax',
                    style: expansionTextStyle,
                  ),
                  initiallyExpanded: false,
                  collapsedBackgroundColor: primaryColor,
                  children: [
                    GridView.count(
                      crossAxisCount: width > 700 ? 2 : 1,
                      childAspectRatio: width > 700 ? width / 200 : width / 100,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      shrinkWrap: true,
                      primary: false,
                      children: <Widget>[
                        PlatformTextField(
                          controller: _semHrsController,
                          focusNode: _semHrsFocus,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          label: 'Semester Hours',
                          decoration: InputDecoration(
                            label: const Text('Semester Hours'),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: PlatformCheckboxListTile(
                            activeColor: onPrimaryColor,
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
                            onIosTap: () {
                              setState(() {
                                degreeCompleted = !degreeCompleted;
                                _calcDegreePts();
                                _calcTotalPts();
                              });
                            },
                          ),
                        ),
                        PlatformTextField(
                          controller: _mosCertsController,
                          focusNode: _mosCertsFocus,
                          textInputAction: isNewVersion
                              ? TextInputAction.next
                              : TextInputAction.done,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          onEditingComplete: () => isNewVersion
                              ? _crossCertsFocus.requestFocus()
                              : FocusScope.of(context).unfocus(),
                          label: isNewVersion
                              ? 'MOS Enhancing Credentials'
                              : 'Tech/Pro Certifications',
                          decoration: InputDecoration(
                            label: Text(isNewVersion
                                ? 'MOS Enhancing Credentials'
                                : 'Tech/Pro Certifications'),
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
                        if (isNewVersion)
                          PlatformTextField(
                            controller: _crossCertsController,
                            focusNode: _crossCertsFocus,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                            ],
                            onEditingComplete: () =>
                                _personalCertsFocus.requestFocus(),
                            label: 'Cross-Functional Credentials',
                            decoration: InputDecoration(
                              label: const Text('Cross-Functional Credentials'),
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
                        if (isNewVersion)
                          PlatformTextField(
                            controller: _personalCertsController,
                            focusNode: _personalCertsFocus,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                            ],
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            label: 'Personal Credentials',
                            decoration: InputDecoration(
                              label: const Text('Personal Credentials'),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: PlatformCheckboxListTile(
                            activeColor: onPrimaryColor,
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
                            onIosTap: () {
                              setState(() {
                                hasFornLang = !hasFornLang;
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
                  child: Divider(color: onPrimaryColor),
                ),
                DecoratedBox(
                    decoration: BoxDecoration(color: primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Points',
                              style: TextStyle(
                                  fontSize: 22, color: onPrimaryColor)),
                          Text('$totalPts/800',
                              style: TextStyle(
                                  fontSize: 22, color: onPrimaryColor))
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: PlatformButton(
                    child: const Text('Save Promotion Point Score'),
                    onPressed: () {
                      if (isPremium) {
                        PPW ppw = PPW(
                          id: null,
                          date: null,
                          name: null,
                          rank: rank.toString(),
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
