import PlatformView, { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { AMPSSplashComponent } from './AMPSSplashComponent';
import { SPLASH_BOTTOM } from '../common/common';
import { SplashBottomImageChild, SplashBottomModule, SplashBottomTextChild } from '../splash/SplashBottomModule';
import { AMPSSplashManager } from './AMPSSplashManager';

//底部自定义组件全局WrappedBuilder
export let globalSplashBottomBuilder: WrappedBuilder<[]> | undefined  = wrapBuilder(MyBuilder);
@Observed
export class OhosPlatformSplashView extends PlatformView {
  static splashBottomModule?: SplashBottomModule
  constructor(args: ESObject) {
    super();
    OhosPlatformSplashView.splashBottomModule = new SplashBottomModule(args.get(SPLASH_BOTTOM))
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(AMPSSplashWrappedBuilder);
  }

  dispose(): void {
    OhosPlatformSplashView.splashBottomModule = undefined
  }
}


@Builder
export function MyBuilder() {
  if (OhosPlatformSplashView.splashBottomModule?.initialized) {
    Stack() {
      ForEach(AMPSSplashManager.splashBottomModule?.textChildrens ?? [], (item: SplashBottomTextChild) => {
        Text(item?.text)
          .fontColor(item?.color)
          .offset({
            x: item?.x,
            y: item?.y
          })
      })
      ForEach(AMPSSplashManager.splashBottomModule?.imgChildrens ?? [], (imgItem: SplashBottomImageChild) => {
        Image($rawfile(`flutter_assets/${imgItem.imagePath}`))
          .width(imgItem?.width)
          .height(imgItem?.height)
          .offset({
            x: imgItem?.x,
            y: imgItem?.y
          })
      })
    }
    .backgroundColor(OhosPlatformSplashView.splashBottomModule?.backgroundColor)
    .height(OhosPlatformSplashView.splashBottomModule?.height)
    .width('100%')
    .alignContent(Alignment.TopStart)
  }
}


@Builder
export function AMPSSplashWrappedBuilder(params: Params) {
  AMPSSplashComponent()
}
