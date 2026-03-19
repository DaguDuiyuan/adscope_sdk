//
//  AMPSplashView.swift
//  amps_sdk
//
//  Created by dagu on 2026/03/19.
//

import AMPSAdSDK
import Flutter
import Foundation

class AMPSplashViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        return AMPSplashView(frame: frame, viewId: viewId, args: args)
    }
    
    func createArgsCodec() -> any FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class AMPSplashView: NSObject, FlutterPlatformView {
    private var iosView: IOSSplashView
    var args: Any?
    
    init(frame: CGRect, viewId: Int64, args: Any?) {
        self.iosView = IOSSplashView(frame: frame)
        self.args = args
        super.init()
    }
    
    func view() -> UIView {
        // 从AMPSSplashManager获取开屏广告实例
        if let splashAd = AMPSSplashManager.shared.getSplashAd() {
            if let splashParam = args as? [String: Any] {
                // 获取底部视图配置
                if let bottomViewParam = splashParam["SplashBottomView"] as? [String: Any] {                    
                    let height = bottomViewParam["height"] as? CGFloat ?? 0
                    let bgColor = bottomViewParam["backgroundColor"] as? String
                    
                    var imageModel: SplashBottomImage?
                    var textModel: SplashBottomText?
                    
                    if let children = bottomViewParam["children"] as? [[String: Any]] {
                        for child in children {
                            let type = child["type"] as? String ?? ""
                            if type == "image" {
                                imageModel = SplashBottomImage(
                                    x: child["x"] as? CGFloat,
                                    y: child["y"] as? CGFloat,
                                    imagePath: child["imagePath"] as? String,
                                    width: child["width"] as? CGFloat,
                                    height: child["height"] as? CGFloat
                                )
                            } else if type == "text" {
                                textModel = SplashBottomText(
                                    x: child["x"] as? CGFloat,
                                    y: child["y"] as? CGFloat,
                                    text: child["text"] as? String,
                                    width: child["width"] as? CGFloat,
                                    height: child["height"] as? CGFloat,
                                    color: child["color"] as? String,
                                    fontSize: child["fontSize"] as? CGFloat
                                )
                            }
                        }
                    }
                    
                    // 如果有底部视图配置，创建底部视图
                    if height > 1 {
                        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
                        
                        if let bgColor = bgColor {
                            bottomView.backgroundColor = UIColor(hexString: bgColor)
                        }
                        
                        if let imageModel = imageModel {
                            let imageView = UIImageView(frame: CGRect(x: imageModel.x ?? 0, y: imageModel.y ?? 0, width: imageModel.width ?? 100, height: imageModel.height ?? 100))
                            if let imageName = imageModel.imagePath {
                                imageView.image = AMPSEventManager.shared.getImage(imageName)
                            }
                            imageView.backgroundColor = UIColor.orange
                            bottomView.addSubview(imageView)
                        }
                        
                        if let textModel = textModel, let text = textModel.text {
                            let width = UIScreen.main.bounds.width - (textModel.x ?? 0)
                            let tagLabel = UILabel(frame: CGRect(x: textModel.x ?? 0, y: textModel.y ?? 0, width: width, height: 0))
                            tagLabel.numberOfLines = 0
                            if let color = textModel.color {
                                tagLabel.textColor = UIColor(hexString: color)
                            }
                            tagLabel.text = text
                            if let font = textModel.fontSize {
                                tagLabel.font = UIFont.systemFont(ofSize: font)
                            }
                            
                            // 计算文本高度
                            let fittingSize = tagLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
                            tagLabel.frame.size.height = fittingSize.height
                            bottomView.addSubview(tagLabel)
                        }
                        
                        // 设置底部视图
                        splashAd.adConfiguration.bottomView = bottomView
                    }
                }
            }
            
            AMPSSplashManager.shared.showSplashAdInView(iosView)
        }
        
        return iosView
    }
    
    /// 获取当前主窗口
    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}

class IOSSplashView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
