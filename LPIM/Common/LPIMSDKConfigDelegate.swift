//
//  LPIMSDKConfigDelegate.swift
//  LPIM
//
//  Created by lipeng on 2017/6/18.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPIMSDKConfigDelegate: NSObject, NIMSDKConfigDelegate {
    
    func shouldIgnoreNotification(_ notification: NIMNotificationObject) -> Bool {
        let ignore = false
        let content = notification.content
        
        /// 这里做个示范如何忽略部分通知 (不在聊天界面显示)
        if content is NIMTeamNotificationContent {
            //        NSArray *types = [[NTESBundleSetting sharedConfig] ignoreTeamNotificationTypes];
            //        NIMTeamOperationType type = [(NIMTeamNotificationContent *)content operationType];
            //        for (NSString *item in types) {
            //            if (type == [item integerValue])
            //            {
            //                ignore = YES;
            //                break;
            //            }
            //        }
        }
        
        return ignore
    }
}
