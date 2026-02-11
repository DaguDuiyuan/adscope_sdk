import 'dart:io';

import 'package:adscope_sdk/amps_sdk_export.dart';
import 'package:adscope_sdk_example/data/common.dart';
import 'package:adscope_sdk_example/widgets/blurred_background.dart';
import 'package:adscope_sdk_example/widgets/button_widget.dart';
import 'package:flutter/material.dart';
class AMPSConstants {
  // 广告平台标识常量（与Java端保持一致）
  static const String AMPS_ADN_CSJ = "AMPS_ADN_CSJ"; // 穿山甲
  static const String AMPS_ADN_GM = "AMPS_ADN_GM";   // 广点通（或其他）
  static const String AMPS_ADN_KS = "AMPS_ADN_KS";   // 快手
  static const String AMPS_ADN_BD = "AMPS_ADN_BD";   // 百度
  static const String AMPS_ADN_GDT = "AMPS_ADN_GDT"; // 腾讯广告
}
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
        AMPSConstants.AMPS_ADN_CSJ: '{"name":"csj_data"}',
        AMPSConstants.AMPS_ADN_GM: '{"name":"gm_data"}',
        AMPSConstants.AMPS_ADN_KS: '{"name":"ks_data"}',
        AMPSConstants.AMPS_ADN_BD: '{"name":"bd_data"}',
        AMPSConstants.AMPS_ADN_GDT: '{"name":"gdt_data"}',
      };
    } else if (Platform.isIOS) {
      extraDataMap = {
        "GDT": {
          "userID": "111",
          "extra": "{\"orderId\":\"order001\"}", // 保留OC中的JSON字符串格式
        },
        // KS平台
        "KS": {
          "userID": "222",
          "extra": "{\"orderId\":\"order001\"}",
        },
        // CSJ平台
        "CSJ": {
          "userID": "333",
          "extra": "{\"orderId\":\"order001\"}",
        },
        // GM平台
        "GM": {
          "userID": "444",
          "extra": "{\"orderId\":\"order001\"}",
        },
        // BD平台
        "BD": {
          "userID": "555",
          "extra": "{\"orderId\":\"order001\"}",
        },
      };
    }
    AdOptions options =
        AdOptions(spaceId: rewardVideoSpaceId, extraDataMap: extraDataMap);
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
