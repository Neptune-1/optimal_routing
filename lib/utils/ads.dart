import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../consts/styles.dart';

class Ads {
  static RewardedAd? _rewardedAd;

  static int _numRewardedLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 5;

  static const String _adUnitIdAndroid =
      "ca-app-pub-6051303150575720/5425259488"; //'ca-app-pub-3940256099942544/5224354917'; //
  static const String _adUnitIdIos =
      "ca-app-pub-6051303150575720/9525082753"; // 'ca-app-pub-3940256099942544/1712485313';//

  static bool isAddShowed = false;

  static void showPreAdDialog(BuildContext context, Function ifShowed) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: Style.blockH * 5,
              width: Style.blockM * 13,
              decoration:
                  BoxDecoration(color: Style.secondaryColor, borderRadius: BorderRadius.circular(Style.blockM * 0.5)),
              child: Column(children: [
                SizedBox(
                  height: Style.blockH * 2.8,
                  child: Center(
                    child: _rewardedAd == null
                        ? Text(
                            "Sure?",
                            style: Style.getTextStyle_2(),
                          )
                        : SvgPicture.asset(
                            "assets/ads_icon_1.svg",
                            width: Style.blockH * 1.7,
                            height: Style.blockH * 1.7,
                          ),
                  ),
                ),
                Container(
                  height: Style.blockH * 2.2,
                  width: Style.blockM * 13,
                  decoration: BoxDecoration(
                      color: Style.accentColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(Style.blockM * 0.5))),
                  child: Stack(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.close,
                                size: Style.blockM * 2.5,
                              ),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.done,
                                size: Style.blockM * 2.5,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                showRewardedAd(ifShowed);
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                            height: Style.blockH * 2.2,
                            width: Style.blockM * 0.1,
                            decoration: BoxDecoration(
                              color: Style.primaryColor.withOpacity(0.3),
                            )),
                      )
                    ],
                  ),
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
