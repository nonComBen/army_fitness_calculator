import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  BannerAd? _bannerAd;
  bool _adLoaded = false;

  BannerAd? get bannerAd {
    return _bannerAd ?? null;
  }

  bool get adLoaded {
    return _adLoaded;
  }

  void initialize({required double width, required double height}) {
    _bannerAd = BannerAd(
      // test ad unit ids
      // adUnitId: Platform.isAndroid
      //     ? 'ca-app-pub-3940256099942544/6300978111'
      //     : 'ca-app-pub-3940256099942544/2934735716',
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2431077176117105/8950325543'
          : 'ca-app-pub-2431077176117105/4488336359',
      size: AdSize(
        height: height > 900 ? 100 : 50,
        width: width.truncate(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _adLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
      request: AdRequest(
          keywords: <String>['army', 'military', 'fitness', 'outdoors'],
          nonPersonalizedAds: true),
    );

    bannerAd!.load();
  }
}
