import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../consts/styles.dart';

class Ads {
  static RewardedAd? _rewardedAd;

  static int _numRewardedLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  static const String _adUnitIdAndroid =
      'ca-app-pub-3940256099942544/5224354917'; //ca-app-pub-6051303150575720/5425259488
  static const String _adUnitIdIos = 'ca-app-pub-3940256099942544/1712485313';//ca-app-pub-6051303150575720~8029040395

  static bool isAddShowed = false;

  static void showPreAdDialog(BuildContext context, Function ifShowed) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: Style.blockH * 4,
              width: Style.block * 16,
              decoration: BoxDecoration(color: Style.secondaryColor, borderRadius: BorderRadius.circular(Style.blockM * 0.5)),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: Style.block * 1.5),
                    child: Text(
                      "Get the Answer!",
                      style: Style.getTextStyle_2(),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                  height: Style.blockM * 0.6,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        "assets/show_ads_icon.svg",
                        width: Style.blockM * 2,
                        height: Style.blockM * 2,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        showRewardedAd(ifShowed);
                      },
                    ),
                    SizedBox(
                      height: Style.blockM * 0.2,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: Style.blockH * 1 / 3.5, horizontal: Style.blockH * 1 / 5),
                      height: Style.blockH,
                      width: Style.block * 11,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: FittedBox(
                          child: Text(
                            "Cancel",
                            style: Style.getTextStyle_3(color: Style.primaryColor.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          );
        });
  }

  static void createRewardedAd() {
    isAddShowed = false;
    RewardedAd.load(
        adUnitId: Platform.isAndroid ? _adUnitIdAndroid : _adUnitIdIos,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  static void showRewardedAd(Function ifShowed) {
    if (_rewardedAd == null) {
      ifShowed(isAdsShowed: false);
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (isAddShowed) ifShowed();
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      isAddShowed = true;
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }
}
