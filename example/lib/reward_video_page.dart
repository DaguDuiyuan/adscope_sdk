import 'dart:io';

import 'package:adscope_sdk/amps_sdk_export.dart';
import 'package:adscope_sdk_example/data/common.dart';
import 'package:adscope_sdk_example/widgets/blurred_background.dart';
import 'package:adscope_sdk_example/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class RewardVideoPage extends StatefulWidget {
  const RewardVideoPage({super.key, required this.title});

  final String title;

  @override
  State<RewardVideoPage> createState() => _RewardVideoPageState();
}

class _RewardVideoPageState extends State<RewardVideoPage> {
  AMPSRewardVideoAd? _rewardVideoAd;
  late RewardVideoCallBack _adCallBack;
  num eCpm = 0;
  bool initSuccess = false;
  bool couldBack = true;

  @override
  void initState() {
    super.initState();
    _adCallBack = RewardVideoCallBack(onLoadSuccess: () {
      _rewardVideoAd?.showAd();
      setState(() {
        couldBack = false;
      });
    }, onLoadFailure: (code, msg) {
      debugPrint("ad load failure=$code;$msg");
    }, onAdClicked: () {
      setState(() {
        couldBack = true;
      });
      debugPrint("ad load onAdClicked");
    }, onAdClosed: () {
      setState(() {
        couldBack = true;
      });
      debugPrint("ad load onAdClosed");
    }, onAdReward: () {
      debugPrint("ad load onAdReward");
    }, onAdShow: () {
      debugPrint("ad load onAdShow");
    }, onVideoPlayStart: () {
      debugPrint("ad load onVideoPlayStart");
    }, onVideoPlayEnd: () {
      debugPrint("ad load onVideoPlayEnd");
    }, onVideoSkipToEnd: (duration) {
      debugPrint("ad load onVideoSkipToEnd=$duration");
    });


// 2. 创建Map并赋值（核心逻辑）
    Map<String, dynamic>? extraDataMap;
    if (Platform.isAndroid) {
      extraDataMap = <String, String>{
        AmpsAndroidConstants.ampsAdnCsj: '{"name":"csj_data"}',
        AmpsAndroidConstants.ampsAdnGm: '{"name":"gm_data"}',
        AmpsAndroidConstants.ampsAdnKs: '{"name":"ks_data"}',
        AmpsAndroidConstants.ampsAdnBd: '{"name":"bd_data"}',
        AmpsAndroidConstants.ampsAdnGdt: '{"name":"gdt_data"}',
      };
    } else if (Platform.isIOS) {
      extraDataMap = {
        AmpsIosConstants.ampsAdnGdt: {
          "userID": "111",
          "extra": '{"orderId":"order001"}',
        },
        AmpsIosConstants.ampsAdnKs: {
          "userID": "222",
          "extra": '{"orderId":"order001"}',
        },
        AmpsIosConstants.ampsAdnCsj: {
          "userID": "333",
          "extra": '{"orderId":"order001"}',
        },
        AmpsIosConstants.ampsAdnGm: {
          "userID": "444",
          "extra": '{"orderId":"order001"}',
        },
        AmpsIosConstants.ampsAdnBd: {
          "userID": "555",
          "extra": '{"orderId":"order001"}',
        },
      };
    }

    AdOptions options = AdOptions(
        spaceId: rewardVideoSpaceId,
        extraDataMap: extraDataMap);
    _rewardVideoAd =
        AMPSRewardVideoAd(config: options, adCallBack: _adCallBack);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: couldBack,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const BlurredBackground(),
                Column(
                  children: [
                    const SizedBox(height: 100, width: 0),
                    ButtonWidget(
                        buttonText: '点击加载激励视频',
                        callBack: () {
                          _rewardVideoAd?.load();
                        })
                  ],
                )
              ],
            )));
  }
}
