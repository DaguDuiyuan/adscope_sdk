//
//  AMPSSplashManager.swift
//  amps_sdk
//
//  Created by duzhaoquan on 2025/10/22.
//

import Foundation
import Flutter
import AMPSAdSDK

private enum AMPSSplashConstant {
    /// 开屏广告默认底部视图高度（兜底值）
    static let defaultBottomViewHeight: CGFloat = 0
    /// 图片视图默认尺寸（避免零尺寸导致不可见）
    static let defaultImageSize: CGSize = CGSize(width: 100, height: 100)
    /// 标签视图默认字体大小
    static let defaultFontSize: CGFloat = 14
}

class AMPSSplashManager: NSObject {
    
    static let shared = AMPSSplashManager()
    private override init() {super.init()}
//    private var splashAd: ASNPSplashAd?
    private var splashAd: AMPSSplashAd?

    
    // MARK: - Public Methods
    
    /// 获取开屏广告实例，供平台视图使用
    func getSplashAd() -> AMPSSplashAd? {
        return splashAd
    }
    
    /// 显示开屏广告，供平台视图使用
    func showSplashAdInView(_ view: UIView) {
        guard let splashAd = splashAd else { return }
        guard let window = getKeyWindow() else { return }
        splashAd.showSplashView(in: window)
    }
    
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case AMPSAdSdkMethodNames.splashCreate:
            handleSplashCreate(arguments: arguments, result: result)
        case AMPSAdSdkMethodNames.splashLoad:
            handleSplashLoad(result: result)
        case AMPSAdSdkMethodNames.splashShowAd:
            handleSplashShowAd(arguments: arguments, result: result)
        case AMPSAdSdkMethodNames.splashGetEcpm:
            result(splashAd?.eCPM() ?? 0)
        case AMPSAdSdkMethodNames.splashDestroy:
            cleanupViewsAfterAdClosed()
            result(nil)
        case AMPSAdSdkMethodNames.splashIsReadyAd:
            result(splashAd != nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleSplashCreate(arguments: [String: Any]?, result: FlutterResult) {
    
        guard let param = arguments else {
            return
        }
        let config = AdOptionModule.getAdConfig(para: param)
        splashAd = AMPSSplashAd(spaceId: config.spaceId, adConfiguration: config)
        splashAd?.delegate = self
        result(true)
    }
//    // MARK: - Private Methods
    private func handleSplashLoad( result: FlutterResult) {
    
        splashAd?.delegate = self
        splashAd?.load()
        result(true)
    }
        
    private func handleSplashShowAd(arguments: [String: Any]?, result: FlutterResult) {
        guard let splashAd = splashAd else {
            result(false)
            return
        }
        
        guard let window = getKeyWindow() else {
            
            result(false)
            return
        }
        if let param = arguments {
            let height = param["height"]  as? CGFloat ?? 0
            let bgColor = param["backgroundColor"] as? String
            var imageModel: SplashBottomImage?
            var textModel: SplashBottomText?
            if let children = param["children"] as? [[String: Any]] {
                children.forEach { child in
                    let type = child["type"] as? String ?? ""
                    if type == "image"{
                        imageModel = Tools.convertToModel(from: child)
                    }else if type == "text" {
                        textModel = Tools.convertToModel(from: child)
                    }
                }
            }
            if height > 1 {
                let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(window.bounds.width), height: height))
                if let bgColor = bgColor{
                    bottomView.backgroundColor = UIColor(hexString: bgColor)
                }
                
                if let imageModel = imageModel {
                    let imageView = UIImageView(frame: CGRect(x: imageModel.x ?? 0, y: imageModel.y ?? 0, width: imageModel.width ?? 100, height: imageModel.height ?? 100))
                    if let imageName =  imageModel.imagePath {
                        imageView.image = AMPSEventManager.shared.getImage(imageName)
                    }
                    
                    bottomView.addSubview(imageView)
                    imageView.backgroundColor  = UIColor.orange
                }
                if let text = textModel?.text {
                    let widht = window.bounds.width - (textModel?.x ?? 0)
                    let tagLabel = UILabel(frame: CGRect(x: textModel?.x ?? 0, y: textModel?.y ?? 0, width: widht, height: 0))
                    tagLabel.numberOfLines = 0
                    if let color = textModel?.color {
                        tagLabel.textColor = UIColor(hexString: color)
                    }
                    tagLabel.text = text
                    if let font = textModel?.fontSize {
                        tagLabel.font = UIFont.systemFont(ofSize: font)
                    }
                    bottomView.addSubview(tagLabel)
                    let fittingSize = tagLabel.sizeThatFits(CGSize(width: widht, height: CGFloat.greatestFiniteMagnitude))
                    tagLabel.frame.size.height = fittingSize.height // 应用计算出的高度
                }
                splashAd.adConfiguration.bottomView = bottomView
                splashAd.showSplashView(in: window)
                
            }
            
        }
        else{
            if let window = getKeyWindow() {
                splashAd.showSplashView(in: window)
            }
        }

    }
    
    
    private func cleanupViewsAfterAdClosed() {
        splashAd?.delegate = nil
        splashAd?.remove()
        splashAd = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        AMPSEventManager.shared.sendToFlutter(method, arg: args)
    }
    

}

extension AMPSSplashManager: AMPSSplashAdDelegate {
    func ampsSplashAdLoadSuccess(_ splashAd: AMPSSplashAd) {
        sendMessage(AMPSSplashAdCallBackChannelMethod.onLoadSuccess)
        sendMessage(AMPSSplashAdCallBackChannelMethod.onRenderOk)
    }
    func ampsSplashAdLoadFail(_ splashAd: AMPSSplashAd, error: (any Error)?) {
        sendMessage(AMPSSplashAdCallBackChannelMethod.onLoadFailure, ["code": (error as? NSError)?.code ?? 0,"message":(error as? NSError)?.localizedDescription ?? ""])
    }
    func ampsSplashAdDidShow(_ splashAd: AMPSSplashAd) {
        sendMessage(AMPSSplashAdCallBackChannelMethod.onAdShow)
    }
    func ampsSplashAdExposured(_ splashAd: AMPSSplashAd){
        sendMessage(AMPSSplashAdCallBackChannelMethod.onAdExposure)
    }
    func ampsSplashAdDidClick(_ splashAd: AMPSSplashAd) {
        sendMessage(AMPSSplashAdCallBackChannelMethod.onAdClicked)
    }
    
    func ampsSplashAdShowFail(_ splashAd: AMPSSplashAd, error: (any Error)?) {
        sendMessage(AMPSSplashAdCallBackChannelMethod.onAdShowError,["code": (error as? NSError)?.code ?? 0,"message":(error as? NSError)?.localizedDescription ?? ""])
    }
    func ampsSplashAdDidClose(_ splashAd: AMPSSplashAd) {
        sendMessage(AMPSSplashAdCallBackChannelMethod.onAdClosed)
        cleanupViewsAfterAdClosed()
    }
}

