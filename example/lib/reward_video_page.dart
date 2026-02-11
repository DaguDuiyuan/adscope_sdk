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


// 2. 需要给渠道氮素设置时候再选择渠道设置。
/****
    String? useId = "xxxxx";//UserInfoManager.instance.getUserId().tostring()
    Map<String, dynamic>? extraDataMap;
    if (Platform.isAndroid) {
      const data = 'xxxxxxx';
      extraDataMap = <String, String>{
        AmpsAndroidConstants.ampsAdnCsj: data,
        AmpsAndroidConstants.ampsAdnGm: data,
        AmpsAndroidConstants.ampsAdnKs: data,
        AmpsAndroidConstants.ampsAdnBd: data,
        AmpsAndroidConstants.ampsAdnGdt: data,
      };
    } else if (Platform.isIOS) {
      const data = 'xxxxxx';
      //TODO IOS端KEY必须和下面一致:userID,extra
      extraDataMap = {
        AmpsIosConstants.ampsAdnGdt: {
          "userID": useId,
          "extra": data,
        },
        AmpsIosConstants.ampsAdnKs: {
          "userID": useId,
          "extra": data,
        },
        AmpsIosConstants.ampsAdnCsj: {
          "userID": useId,
          "extra": data,
        },
        AmpsIosConstants.ampsAdnGm: {
          "userID": useId,
          "extra": data,
        },
        AmpsIosConstants.ampsAdnBd: {
          "userID": useId,
          "extra": data,
        },
      };
    }
****/

    AdOptions options = AdOptions(
        spaceId: rewardVideoSpaceId,
        //userId: useId, //根据需要传入
        //extraDataMap: extraDataMap //根据需要传入
    );
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
