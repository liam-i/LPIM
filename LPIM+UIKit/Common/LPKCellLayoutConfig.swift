//
//  LPKCellLayoutConfig.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPKCellLayoutConfig: NSObject, LPKCellLayoutConfigDelegate {
    
    /// - Returns: 返回message的内容大小
//    func contentSize(_ model: LPKMessageModel, cellWidth width: CGFloat) -> CGSize {
        //    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
        //    return [config contentSize:cellWidth message:model.message];
//    }
    
    /// 需要构造的cellContent类名
//    func cellContent(_ model: LPKMessageModel) -> String {
        //    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
        //    NSString *cellContent = [config cellContent:model.message];
        //    return cellContent.length ? cellContent : @"NIMSessionUnknowContentView";
//    }
    
    /// 左对齐的气泡，cell气泡距离整个cell的内间距
//    func cellInsets(_ model: LPKMessageModel) -> UIEdgeInsets {
        //    if ([[self cellContent:model] isEqualToString:@"NIMSessionNotificationContentView"]) {
        //        return UIEdgeInsetsZero;
        //    }
        //    CGFloat cellTopToBubbleTop           = 3;
        //    CGFloat otherNickNameHeight          = 20;
        //    CGFloat otherBubbleOriginX           = [self shouldShowAvatar:model]? 55 : 0;
        //    CGFloat cellBubbleButtomToCellButtom = 13;
        //    if ([self shouldShowNickName:model])
        //    {
        //        //要显示名字
        //        return UIEdgeInsetsMake(cellTopToBubbleTop + otherNickNameHeight ,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
        //    }
        //    else
        //    {
        //        return UIEdgeInsetsMake(cellTopToBubbleTop,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
        //    }
//    }

    /// 左对齐的气泡，cell内容距离气泡的内间距
//    func contentViewInsets(_ model: LPKMessageModel) -> UIEdgeInsets {
        //    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
        //    return [config contentViewInsets:model.message];
//    }
    
    /// 是否显示头像
    func shouldShowAvatar(_ model: LPKMessageModel) -> Bool {
        let config = LPKUIConfig.shared.bubbleConfig(model.message)
        return config?.showAvatar ?? true
    }
    
    /// 左对齐的气泡，头像到左边的距离
    func avatarMargin(_ model: LPKMessageModel) -> CGFloat {
        return 8.0
    }
    
    /// 是否显示姓名
    func shouldShowNickName(_ model: LPKMessageModel) -> Bool {
        guard let message = model.message else { return true }
        
        if message.messageType == .notification {
            if let obj = message.messageObject as? NIMNotificationObject {
                if obj.notificationType == .team {
                    return false
                }
            }
        }
        
        if message.messageType == .tip {
            return false
        }
        
        var flag = false
        if let session = message.session {
            flag = session.sessionType == .team
        }
        return !message.isOutgoingMsg && flag
    }
    
    /// 左对齐的气泡，昵称到左边的距离
    func nickNameMargin(_ model: LPKMessageModel) -> CGFloat {
        return shouldShowAvatar(model) ? 57.0 : 10.0
    }
    
    /// 消息显示在左边
    func shouldShowLeft(_ model: LPKMessageModel) -> Bool {
        if let msg = model.message {
            return !msg.isOutgoingMsg
        }
        return false
    }
    
    /// 需要添加到Cell上的自定义视图
    func customViews(_ model: LPKMessageModel) -> [UIView] {
        return []
    }
}




