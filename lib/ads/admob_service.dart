import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannedAdUnitId => Platform.isAndroid
      ? "ca-app-pub-3940256099942544/6300978111"
      : "ca-app-pub-3940256099942544/6300978111";
  static initialze() {
    MobileAds.instance.initialize();
  }

  static BannerAd createBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.banner,
        adUnitId: bannedAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => print('ad loaded'),
            onAdClosed: (Ad ad) => print("ad closed"),
            onAdFailedToLoad: (Ad ad, error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => print("ad opened")),
        request: const AdRequest());
    return ad;
  }
}
