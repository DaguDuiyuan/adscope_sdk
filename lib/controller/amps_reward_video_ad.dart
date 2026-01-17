import 'package:adscope_sdk/adscope_sdk.dart';
import 'package:adscope_sdk/amps_sdk_export.dart';

import '../common.dart';

class AMPSRewardVideoAd {
  static const String _rewardAdHandlerKey = "reward_ad_handler";
  AdOptions config;
  RewardVideoCallBack? adCallBack;

  AMPSRewardVideoAd({required this.config, this.adCallBack}) {
    AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.rewardVideoCreate, config.toMap());

    setMethodCallHandler();
  }

  void setMethodCallHandler() {
    AdscopeSdk.removeMethodCallHandler(_rewardAdHandlerKey);
    AdscopeSdk.addMethodCallHandler(_rewardAdHandlerKey,
      (call) async {
        switch (call.method) {
          case AMPSRewardedVideoCallBackChannelMethod.onLoadSuccess:
            adCallBack?.onLoadSuccess?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onLoadFailure:
            var map = call.arguments as Map<dynamic, dynamic>;
            adCallBack?.onLoadFailure?.call(map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onAdShow:
            adCallBack?.onAdShow?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onAdClicked:
            adCallBack?.onAdClicked?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onAdClosed:
            adCallBack?.onAdClosed?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onVideoPlayStart:
            adCallBack?.onVideoPlayStart?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onVideoPlayEnd:
            adCallBack?.onVideoPlayEnd?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onVideoPlayError:
            var map = call.arguments as Map<dynamic, dynamic>;
            adCallBack?.onVideoPlayError?.call(
                map[AMPSSdkCallBackErrorKey.code],
                map[AMPSSdkCallBackErrorKey.message]);
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onVideoSkipToEnd:
            var map = call.arguments as Map<dynamic, dynamic>;
            adCallBack?.onVideoSkipToEnd
                ?.call(map[AMPSSdkCallBackParamsKey.playDurationMs]);
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onAdReward:
            adCallBack?.onAdReward?.call();
            break;
          case AMPSRewardedVideoCallBackChannelMethod.onAdCached:
            adCallBack?.onAdCached?.call();
            break;
        }
      },
    );
  }

  ///激励视频广告加载调用
  void load() async {
    await AdscopeSdk.invokeMethod(AMPSAdSdkMethodNames.rewardVideoLoad);
  }

  ///激励视频广预加载
  void preLoad() async {
    await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.rewardVideoPreLoad);
  }

  ///激励视频广告显示调用
  void showAd() async {
    await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.rewardVideoShowAd);
  }

  ///激励视频广告是否有预加载
  Future<bool> isReadyAd() async {
    return await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.rewardVideoIsReadyAd);
  }

  ///销毁视频广告
  destroy() async {
    AdscopeSdk.invokeMethod(AMPSAdSdkMethodNames.rewardVideoDestroyAd);
  }

  ///获取ecpm
  Future<num> getECPM() async {
    return await AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.rewardVideoGetECPM);
  }

  ///添加预加载广告
  addPreLoadAdInfo() async {
    AdscopeSdk
        .invokeMethod(AMPSAdSdkMethodNames.rewardVideoAddPreLoadAdInfo);
  }

  ///获取MediaExtraInfo
  Future<dynamic> addPreGetMediaExtraInfo() async {
    return await AdscopeSdk
        .invokeMapMethod(AMPSAdSdkMethodNames.rewardVideoGetMediaExtraInfo);
  }
}