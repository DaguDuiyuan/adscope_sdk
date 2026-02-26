import 'dart:ui';

import '../adscope_sdk.dart';
import '../common.dart';
import '../data/amps_ad.dart';
import '../widget/splash_bottom_widget.dart';

///开屏广告类
class AMPSSplashAd {
  static const String _splashAdHandlerKey = "splash_ad_handler";
  AdOptions config;
  AdCallBack? mCallBack;
  VoidCallback? mCloseCallBack;
  AMPSSplashAd({required this.config, this.mCallBack}) {
    AdscopeSdk.invokeMethod(
      AMPSAdSdkMethodNames.splashCreate,
      config.toMap(),
    );
    setMethodCallHandler();
  }

  void setMethodCallHandler() {
    AdscopeSdk.removeMethodCallHandler(_splashAdHandlerKey);
    AdscopeSdk.addMethodCallHandler(_splashAdHandlerKey,
      (call) async {
        switch (call.method) {
          case AMPSSplashAdCallBackChannelMethod.onLoadSuccess:
            mCallBack?.onLoadSuccess?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onLoadFailure:
            mCloseCallBack?.call();
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onLoadFailure?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSSplashAdCallBackChannelMethod.onRenderOk:
            mCallBack?.onRenderOk?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onAdShow:
            mCallBack?.onAdShow?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onAdExposure:
            mCallBack?.onAdExposure?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onAdClicked:
            mCloseCallBack?.call();
            mCallBack?.onAdClicked?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onAdClosed:
            mCloseCallBack?.call();
            mCallBack?.onAdClosed?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onRenderFailure:
            mCallBack?.onRenderFailure?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onAdShowError:
            mCloseCallBack?.call();
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onAdShowError?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSSplashAdCallBackChannelMethod.onVideoPlayStart:
            mCallBack?.onVideoPlayStart?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onVideoPlayEnd:
            mCallBack?.onVideoPlayEnd?.call();
            break;
          case AMPSSplashAdCallBackChannelMethod.onVideoPlayError:
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onVideoPlayError?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSSplashAdCallBackChannelMethod.onVideoSkipToEnd:
            var map = call.arguments as Map<dynamic, dynamic>;
            mCallBack?.onVideoSkipToEnd?.call(map[AMPSSdkCallBackParamsKey.playDurationMs]);
            break;
          case AMPSSplashAdCallBackChannelMethod.onAdReward:
            mCallBack?.onAdReward?.call();
            break;
        }
      },
    );
  }

  ///开屏广告加载调用
  void load() async {
    await AdscopeSdk.invokeMethod(AMPSAdSdkMethodNames.splashLoad);
  }

  ///开屏广预加载
  void  preLoad() async {
    await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.splashPreLoad);
  }

  ///开屏广告显示调用
  void showAd({SplashBottomWidget? splashBottomWidget}) async {
    await AdscopeSdk.invokeMethod(
        AMPSAdSdkMethodNames.splashShowAd, splashBottomWidget?.toMap());
  }

  ///开屏广告是否有预加载
  Future<bool> isReadyAd() async {
    return await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.splashIsReadyAd);
  }

  ///获取ecpm
  Future<num> getECPM() async {
    return await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.splashGetECPM);
  }

  ///调用addPreLoadAdInfo
  void addPreLoadAdInfo() async {
    await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.splashAddPreLoadAdInfo);
  }

  ///调用addPreGetMediaExtraInfo
  Future<dynamic> addPreGetMediaExtraInfo() async {
    return await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.splashAddPreGetMediaExtraInfo);
  }

  void registerChannel(VoidCallback callBack) {
    mCloseCallBack = callBack;
  }

  Future destroy() {
    return AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.splashDestroy);
  }
}
