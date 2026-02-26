import 'package:adscope_sdk/amps_sdk_export.dart';
import 'package:adscope_sdk_example/data/common.dart';
import 'package:flutter/material.dart';
class InterstitialShowPage extends StatefulWidget {
  const InterstitialShowPage({super.key, required this.title});

  final String title;

  @override
  State<InterstitialShowPage> createState() => _InterstitialShowPageState();
}

class _InterstitialShowPageState extends State<InterstitialShowPage> {
  late AdCallBack _adCallBack;
  AMPSInterstitialAd? _interAd;
  num eCpm = 0;
  @override
  void initState() {
    super.initState();
    _adCallBack = AdCallBack(
        onRenderOk: () {
          _interAd?.showAd();
          debugPrint("ad load onRenderOk");
        },
        onLoadFailure: (code, msg) {
          debugPrint("ad load failure=$code;$msg");
        },
        onAdClicked: () {
          debugPrint("ad load onAdClicked");
        },
        onAdClosed: () {
          debugPrint("ad load onAdClosed");
        },
        onAdShow: () {
          debugPrint("ad load onAdShow");
        });

    AdOptions options = AdOptions(spaceId: interstitialSpaceId);
    _interAd = AMPSInterstitialAd(config: options, mCallBack: _adCallBack);
  }
  @override
  void dispose() {
    super.dispose();
    _interAd?.destroy();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: [
        Column(
          children:[
            ElevatedButton(
            child: const Text('点击展示插屏'),
            onPressed: () {
              // 返回上一页
              AdOptions options = AdOptions(spaceId: interstitialSpaceId);
              _interAd = AMPSInterstitialAd(config: options, mCallBack: _adCallBack);
              _interAd?.load();
            },
          )
          ]
        ),
      ],)
    );
  }
}