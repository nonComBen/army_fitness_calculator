import 'dart:io';

import 'package:acft_calculator/methods/theme_methods.dart';
import 'package:acft_calculator/widgets/platform_widgets/platform_item_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../providers/purchases_provider.dart';
import '../../services/purchases_service.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../constants/pt_age_group_table.dart';
import '../../widgets/acft_table.dart';

class AcftTablePage extends ConsumerStatefulWidget {
  const AcftTablePage({Key? key, this.ageGroup, this.gender}) : super(key: key);
  final String? ageGroup;
  final String? gender;

  @override
  ConsumerState<AcftTablePage> createState() => _AcftTablePageState();
}

class _AcftTablePageState extends ConsumerState<AcftTablePage> {
  late String _ageGroup, _gender;
  List<String> _genders = ['Male', 'Female'];

  late PurchasesService purchasesService;
  late BannerAd myBanner;

  @override
  void initState() {
    super.initState();
    purchasesService = ref.read(purchasesProvider);
    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/5102704125'
          : 'ca-app-pub-2431077176117105/2855814736',
      size: AdSize.banner,
      listener: BannerAdListener(),
      request: AdRequest(nonPersonalizedAds: true),
    );
    myBanner.load();

    _ageGroup = widget.ageGroup!;
    _gender = widget.gender!;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'ACFT Table',
      body: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 8,
          left: 8,
          right: 8,
          top: 8,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  GridView.count(
                    crossAxisCount: width > 700 ? 2 : 1,
                    childAspectRatio: width > 700 ? width / 230 : width / 115,
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformItemPicker(
                          label: Text(
                            'Age Group',
                            style: TextStyle(
                              color: getTextColor(context),
                            ),
                          ),
                          value: _ageGroup,
                          items: ptAgeGroups,
                          onChanged: (dynamic value) {
                            setState(() {
                              _ageGroup = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformItemPicker(
                          label: Text(
                            'Gender',
                            style: TextStyle(
                              color: getTextColor(context),
                            ),
                          ),
                          value: _gender,
                          items: _genders,
                          onChanged: (dynamic value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  AcftTable(
                    ageGroup: _ageGroup,
                    gender: _gender,
                  ),
                ],
              ),
            ),
            if (!purchasesService.isPremium)
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
