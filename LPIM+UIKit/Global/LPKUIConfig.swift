//
//  LPKUIConfig.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

// MARK: -
// MARK: - LPKUIConfig

class LPKUIConfig {
    static let shared: LPKUIConfig = { return LPKUIConfig() }()
    
    private lazy var cachedBubbleSettings: [String: LPKBubbleConfig] = [:]
    private lazy var cachedGlobalSettings: LPKGlobalConfig = LPKGlobalConfig()
    
    let maxNotificationTipPadding: CGFloat = 20.0
    
    var defaultMediaItems: [LPKMediaItem] {
        return [LPKMediaItem(selector: #selector(LPKSessionViewController.onTapMediaItemPicture),
                             normalImage: UIImage.lp_image(named: "bk_media_picture_normal"),
                             selectedImage: UIImage.lp_image(named: "bk_media_picture_nomal_pressed"),
                             title: "相册"),
                LPKMediaItem(selector: #selector(LPKSessionViewController.onTapMediaItemShoot),
                             normalImage: UIImage.lp_image(named: "bk_media_shoot_normal"),
                             selectedImage: UIImage.lp_image(named: "bk_media_shoot_pressed"),
                             title: "拍摄"),
                LPKMediaItem(selector: #selector(LPKSessionViewController.onTapMediaItemLocation),
                             normalImage: UIImage.lp_image(named: "bk_media_position_normal"),
                             selectedImage: UIImage.lp_image(named: "bk_media_position_pressed"),
                             title: "位置")
        ]
    }
    
    lazy var globalConfig: LPKGlobalConfig = LPKGlobalConfig()
    
    func bubbleConfig(_ message: NIMMessage?) -> LPKBubbleConfig? {
        guard let message = message else { return nil }
        guard let key = self.key(message) else { return nil }
        var config = self.config(for: key, isRight: message.isOutgoingMsg)
        config = config ?? unsupportConfig(message)
        config?.message = message
        return config
    }
    
    func unsupportConfig(_ message: NIMMessage) -> LPKBubbleConfig? {
        return config(for: "Unsupport", isRight: message.isOutgoingMsg)
    }
    
    private func key(_ message: NIMMessage) -> String? {
        let messageDict = [NIMMessageType.text.rawValue: "Text",
                           NIMMessageType.image.rawValue: "Image",
                           NIMMessageType.video.rawValue: "Video",
                           NIMMessageType.audio.rawValue: "Audio",
                           NIMMessageType.file.rawValue: "File",
                           NIMMessageType.location.rawValue: "Location",
                           NIMMessageType.tip.rawValue: "Tip"]
        let notificationDict = [NIMNotificationType.team.rawValue: "Team_Notification",
                                NIMNotificationType.chatroom.rawValue: "Chatroom_Notification",
                                NIMNotificationType.netCall.rawValue: "Netcall_Notification",]
        if message.messageType == .notification {
            if let msgObj = message.messageObject, let obj = msgObj as? NIMNotificationObject {
                return notificationDict[obj.notificationType.rawValue]
            }
        }
        return messageDict[message.messageType.rawValue]
    }
    
    private func config(for key: String, isRight: Bool) -> LPKBubbleConfig? {
        let configKey = cachedCustomBubbleSettingKey(key, isRight: isRight)
        if let config = cachedBubbleSettings[configKey] {
            return config
        }
        
        let name = "\(LPKKit.shared.settingBundleName)/NIMKitBubbleSetting.plist"
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else { return nil }
        
        if let bubbleSetting = NSDictionary(contentsOfFile: path), let info = bubbleSetting[key] as? NSDictionary {
            guard let content_Insets = info["Content_Insets"] as? NSDictionary else { return nil }
            let config = LPKBubbleConfig()
            
            if let insetsString = LPKConfigHelper.configHelper(configs: content_Insets, isRight: isRight)?.stringValue {
                config.contentInset = UIEdgeInsetsFromString(insetsString)
            }
            
            if let contentColor = info["Content_Color"] as? NSDictionary {
                config.textColor = LPKConfigHelper.configHelper(configs: contentColor, isRight: isRight)?.stringValue
            }
            
            if let textFontSize = info["Content_Font_Size"] as? NSDictionary {
                if let floatValue = LPKConfigHelper.configHelper(configs: textFontSize, isRight: isRight)?.floatValue {
                    config.textFontSize = CGFloat(floatValue)
                }
            }
            
            config.bubbleConfig = LPKConfigHelper.bubbleConfigHelper(configs: info, isRight: isRight)
            config.showAvatar = (info["Show_Avatar"] as AnyObject).boolValue
            cachedBubbleSettings[configKey] = config
            
            return config
        }
        return nil
    }
    
    private func cachedCustomBubbleSettingKey(_ key: String, isRight: Bool) -> String {
        return key.appendingFormat("-%zd", isRight as CVarArg)
    }
}

// MARK: - 
// MARK: - LPKGlobalConfig

class LPKGlobalConfig {
    var messageInterval: TimeInterval?
    var messageLimit: Int?
    var recordMaxDuration: TimeInterval?
    var maxLength: Int?
    var placeholder: String?
    
    private var leftBubbleConfig: LPKBubbleStyle?
    private var rightBubbleConfig: LPKBubbleStyle?

    init() {
        let name = LPKKit.shared.settingBundleName + "/NIMKitGlobalSetting.plist"
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else { return }
        guard let globalSetting = NSDictionary(contentsOfFile: path) else { return }
        
        leftBubbleConfig = LPKConfigHelper.bubbleConfigHelper(configs: globalSetting, isRight: false)
        rightBubbleConfig = LPKConfigHelper.bubbleConfigHelper(configs: globalSetting, isRight: true)
        
        messageInterval   = (globalSetting["Message_Interval"] as AnyObject).doubleValue
        messageLimit      = (globalSetting["Message_Limit"] as AnyObject).integerValue
        recordMaxDuration = (globalSetting["Record_Max_Duration"] as AnyObject).doubleValue
        
        placeholder     = (globalSetting["Placeholder"] as AnyObject).stringValue
        maxLength       = (globalSetting["Max_Length"] as AnyObject).integerValue
    }
    
    func bubbleStyle(isRight: Bool) -> LPKBubbleStyle? {
        return isRight ? rightBubbleConfig : leftBubbleConfig
    }
}

class LPKBubbleConfig {
    var contentInset: UIEdgeInsets?
    var textColor: String?
    var textFontSize: CGFloat?
    var showAvatar: Bool?
    
    fileprivate var message: NIMMessage?
    fileprivate var bubbleConfig: LPKBubbleStyle?
    
    func contentTextColor() -> UIColor? {
        if let textColor = textColor {
            return UIColor(textColor)
        }
        return nil
    }
    
    func contentTextFont() -> UIFont? {
        if let textFontSize = textFontSize {
            return UIFont.systemFont(ofSize: textFontSize)
        }
        return nil
    }
    
    func bubbleImage(state: UIControlState) -> UIImage? {
        let bubbleConfig = customBubbleConfig()
        if let name = bubbleConfig?.bubbleImage(state: state), let insets = bubbleConfig?.bubbleInsets(state: state) {
            return UIImage.lp_image(named: name)?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        }
        return nil
    }
    
    func bubbleInsets(state: UIControlState) -> UIEdgeInsets? {
        let bubbleConfig = customBubbleConfig()
        return bubbleConfig?.bubbleInsets(state: state)
    }
    
    private func customBubbleConfig() -> LPKBubbleStyle? {
        var bubbleConfig = self.bubbleConfig
        if bubbleConfig == nil  {
            //如果没有特殊定义，则取全局的设置
            let global = LPKUIConfig.shared.globalConfig
            bubbleConfig = global.bubbleStyle(isRight: message?.isOutgoingMsg ?? true)
            
        }
        return bubbleConfig
    }
}

class LPKConfigHelper {
    class func configHelper(configs: NSDictionary, isRight: Bool) -> AnyObject? {
        return (isRight ? configs["Right"] : configs["Left"]) as AnyObject
    }
    
    class func bubbleConfigHelper(configs: NSDictionary, isRight: Bool) -> LPKBubbleStyle? {
        guard let bubbleDict = configs["Bubble"] as? NSDictionary else { return nil }
        guard let bubbleConfig = configHelper(configs: bubbleDict, isRight: isRight) as? NSDictionary else { return nil }
        
        let name   = "Name"
        let insets = "Insets"
        
        let bubble = LPKBubbleStyle()
        
        guard let normal = bubbleConfig["Normal"] as? NSDictionary else { return nil }
        bubble.bubbleImageNormal = normal[name] as? String
        if let str = normal[insets] as? String {
            bubble.bubbleImageInsertsNormal = UIEdgeInsetsFromString(str)
        }
        
        guard let highlighted = bubbleConfig["Highlighted"] as? NSDictionary else { return nil }
        bubble.bubbleImageHightlighted = highlighted[name] as? String
        if let str = highlighted[insets] as? String {
            bubble.bubbleImageInsertsHighlighted = UIEdgeInsetsFromString(str)
        }
        
        return bubble
    }

}

class LPKBubbleStyle {
    var bubbleImageNormal: String?
    var bubbleImageHightlighted: String?
    var bubbleImageInsertsNormal: UIEdgeInsets?
    var bubbleImageInsertsHighlighted: UIEdgeInsets?
    
    func bubbleImage(state: UIControlState) -> String? {
        switch state {
        case UIControlState.highlighted:
            return bubbleImageHightlighted
        default:
            return bubbleImageNormal
        }
    }
    
    func bubbleInsets(state: UIControlState) -> UIEdgeInsets? {
        switch state {
        case UIControlState.highlighted:
            return bubbleImageInsertsHighlighted
        default:
            return bubbleImageInsertsNormal
        }
    }
}
