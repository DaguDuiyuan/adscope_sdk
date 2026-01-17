import 'package:flutter/services.dart';

import '../adscope_sdk.dart';
import '../common.dart';
import '../data/amps_ad.dart';
///插屏广告对象入口类
class AMPSInterstitialAd {
  static const String _interstitialAdHandlerKey = "interstitial_ad_handler";
  AdOptions config;
  AdCallBack? mCallBack;

  AMPSInterstitialAd({required this.config, this.mCallBack}) {
    AdscopeSdk.invokeMethod(
      AMPSAdSdkMethodNames.interstitialCreate,
      config.toMap(),
    );
    setMethodCallHandler(null);
  }

  void setMethodCallHandler(VoidCallback? closeWidgetCall) {
    // 注册前先移除旧的（如果存在），确保全局只有一个初始化回调在运行
    AdscopeSdk.removeMethodCallHandler(_interstitialAdHandlerKey);
    AdscopeSdk.addMethodCallHandler(_interstitialAdHandlerKey,
      (call) async {
        switch (call.method) {
          case AMPSInterstitialAdCallBackChannelMethod.onLoadSuccess:
            mCallBack?.onLoadSuccess?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onLoadFailure:
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onLoadFailure?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onRenderOk:
            mCallBack?.onRenderOk?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onAdShow:
            mCallBack?.onAdShow?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onAdExposure:
            mCallBack?.onAdExposure?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onAdClicked:
            closeWidgetCall?.call();
            mCallBack?.onAdClicked?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onAdClosed:
            closeWidgetCall?.call();
            mCallBack?.onAdClosed?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onRenderFailure:
            mCallBack?.onRenderFailure?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onAdShowError:
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onAdShowError?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onVideoPlayStart:
            mCallBack?.onVideoPlayStart?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onVideoPlayEnd:
            mCallBack?.onVideoPlayEnd?.call();
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onVideoPlayError:
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onVideoPlayError?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onVideoSkipToEnd:
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onVideoSkipToEnd?.call(map[AMPSSdkCallBackParamsKey.playDurationMs]);
            break;
          case AMPSInterstitialAdCallBackChannelMethod.onAdReward:
            mCallBack?.onAdReward?.call();
            break;
        }
      },
    );
  }
  ///广告加载调用方法
  void load() async {
    setMethodCallHandler(null);
    await AdscopeSdk.invokeMethod(
      AMPSAdSdkMethodNames.interstitialLoad
    );
  }

  ///广预加载
  void  preLoad() async {
    await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.interstitialPreLoad);
  }

  ///插屏广告显示调用方法
  void showAd() async {
    await AdscopeSdk.invokeMethod(AMPSAdSdkMethodNames.interstitialShowAd);
  }
  ///是否有预加载
  Future<bool> isReadyAd() async {
    return await AdscopeSdk.invokeMethod(AMPSAdSdkMethodNames.interstitialIsReadyAd);
  }
  ///获取ecpm
  Future<num> getECPM() async {
    return await AdscopeSdk.invokeMethod(AMPSAdSdkMethodNames.interstitialGetEcpm);
  }
  
  ///调用addPreLoadAdInfo
  void addPreLoadAdInfo() async {
    await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.interstitialAddPreLoadAdInfo);
  }

  ///调用addPreGetMediaExtraInfo
  Future<dynamic> addPreGetMediaExtraInfo() async {
    return await AdscopeSdk.invokeMapMethod(AMPSAdSdkMethodNames.interstitialGetMediaExtraInfo);
  }

  Future destroy() {
    return AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.interstitialDestroy);
  }
}
