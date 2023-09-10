import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/mdl_setup_table.dart';
import '../providers/shared_preferences_provider.dart';
import '../widgets/mdl_setup_card.dart';
import '../../widgets/platform_widgets/platform_scaffold.dart';
import '../../providers/premium_state_provider.dart';

class MdlSetupPage extends ConsumerWidget {
  const MdlSetupPage({Key? key}) : super(key: key);

  static const String routeName = 'mdlSetupRoute';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPremium = false;
    late BannerAd myBanner;
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      isPremium = true;
    } else {
      final prefs = ref.read(sharedPreferencesProvider);
      isPremium = ref.read(premiumStateProvider) ||
          (prefs.getBool('isPremium') ?? false);

      myBanner = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-2431077176117105/2476540786'
            : 'ca-app-pub-2431077176117105/7916569725',
        size: AdSize.banner,
        listener: BannerAdListener(),
        request: AdRequest(nonPersonalizedAds: true),
      );

      myBanner.load();
    }

    final width = MediaQuery.of(context).size.width;
    return PlatformScaffold(
      title: 'MDL Setup',
      body: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: width > 700 ? 2 : 1,
                childAspectRatio: width > 700 ? width / 430 : width / 215,
                shrinkWrap: true,
                primary: false,
                children: mdlSetupTable
                    .map(
                      (e) => MdlSetupCard(
                        title: e[0],
                        image: Image.asset('assets/mdl_images/${e[1]}.png'),
                        weights: e[2],
                      ),
                    )
                    .toList(),
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
      ),
    );
  }
}
