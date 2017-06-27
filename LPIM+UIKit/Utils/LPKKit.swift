//
//  LPKKit.swift
//  LPIM
//
//  Created by lipeng on 2017/6/20.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

public let LPKTeamInfoHasUpdatedNotification = Notification.Name("LPKTeamInfoHasUpdatedNotification")
public let LPKTeamMembersHasUpdatedNotification = Notification.Name("LPKTeamMembersHasUpdatedNotification")
public let LPKUserInfoHasUpdatedNotification = Notification.Name("LPKUserInfoHasUpdatedNotification")

public let LPKUserBlackListHasUpdatedNotification = "LPKUserBlackListHasUpdatedNotification"
public let LPKUserMuteListHasUpdatedNotification  = "LPKUserMuteListHasUpdatedNotification"

public let LPK_EmojiCatalog                                = "default"
public let LPK_EmojiPath                                   = "Emoji"
public let LPK_ChartletChartletCatalogPath                 = "Chartlet"
public let LPK_ChartletChartletCatalogContentPath          = "content"
public let LPK_ChartletChartletCatalogIconPath             = "icon"
public let LPK_ChartletChartletCatalogIconsSuffixNormal    = "normal"
public let LPK_ChartletChartletCatalogIconsSuffixHighLight = "highlighted"

class LPKKit: NSObject {
    static let shared: LPKKit = { return LPKKit() }()
    
    /// 内容提供者，由上层开发者注入。如果没有则使用默认 provider
    lazy var provider: LPKDataProviderDelegate = LPKDataProviderImpl() // 默认使用 LPKKit 的实现
    let resourceBundleName: String = "NIMKitResource.bundle" // LPKKit图片资源所在的 bundle 名称
    let emoticonBundleName: String = "NIMKitEmoticon.bundle" // LPKKit表情资源所在的 bundle 名称
    let settingBundleName: String = "NIMKitSettings.bundle"  // LPKKit设置资源所在的 bundle 名称
    
    fileprivate lazy var firer: LPKNotificationFirer = LPKNotificationFirer()
//    fileprivate lazy var layoutConfig: LPKCellLayoutConfig = LPKCellLayoutConfig()
    
    ///**
    // *  注册自定义的排版配置，通过注册自定义排版配置来实现自定义消息的定制化排版
    // */
    //- (void)registerLayoutConfig:(Class)layoutConfigClass;
    //
    ///**
    // *  返回当前的排版配置
    // */
    //- (id<NIMCellLayoutConfig>)layoutConfig;
    
    
    //- (void)registerLayoutConfig:(Class)layoutConfigClass
    //{
    //    id instance = [[layoutConfigClass alloc] init];
    //    if ([instance isKindOfClass:[NIMCellLayoutConfig class]])
    //    {
    //        self.layoutConfig = instance;
    //    }
    //    else
    //    {
    //        NSAssert(0, @"class should be subclass of NIMLayoutConfig");
    //    }
    //}
    //
    //- (id<NIMCellLayoutConfig>)layoutConfig
    //{
    //    return _layoutConfig;
    //}
    
    
    
    /// 用户信息变更通知接口
    ///
    /// - Parameter userIds: 用户id
    func notfiyUserInfoChanged(_ userIds: [String]) {
        if userIds.count == 0 {
            return
        }
        
        for userId in userIds {
            let session = NIMSession(userId, type: .P2P)
            
        }
        
        
        //    for (NSString * in ) {
        //        NIMSession * = [ session: type:NIMSessionTypeP2P];
        //        NIMKitFirerInfo *info = [[NIMKitFirerInfo alloc] init];
        //        info.session = session;
        //        info.notificationName = NIMKitUserInfoHasUpdatedNotification;
        //        [self.firer addFireInfo:info];
        //    }
    }
    
    /// 群信息变更通知接口
    ///
    /// - Parameter teamIds: 群id
    func notifyTeamInfoChanged(_ teamIds: [String]?) {
        if let teamIds = teamIds, teamIds.count > 0 {
            for teamId in teamIds {
                notifyTeam(teamId)
            }
        } else {
            notifyTeam(nil)
        }
    }
    
    /// 群成员变更通知接口
    ///
    /// - Parameter teamIds: 群id
    func notifyTeamMemebersChanged(_ teamIds: [String]?) {
        if let teamIds = teamIds, teamIds.count > 0 {
            for teamId in teamIds {
                notifyTeamMemebers(teamId)
            }
        } else {
            notifyTeamMemebers(nil)
        }
    }
    
    /// 返回用户信息
    func info(byUser userId: String, option: LPKInfoFetchOption?) -> LPKInfo? {
        return provider.info?(byUser: userId, option: option)
    }
    
    /// 返回群信息
    func info(byTeam teamId: String, option: LPKInfoFetchOption?) -> LPKInfo? {
        return provider.info?(byTeam:teamId, option:option)
    }
}

// MARK: - 
// MARK: - Private

extension LPKKit {
    
    fileprivate func notifyTeam(_ teamId: String?) {
        //    NIMKitFirerInfo *info = [[NIMKitFirerInfo alloc] init];
        //    if (teamId.length) {
        //        NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
        //        info.session = session;
        //    }
        //    info.notificationName = NIMKitTeamInfoHasUpdatedNotification;
        //    [self.firer addFireInfo:info];
    }
    
    fileprivate func notifyTeamMemebers(_ teamId: String?) {
        //    NIMKitFirerInfo *info = [[NIMKitFirerInfo alloc] init];
        //    if (teamId.length) {
        //        NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
        //        info.session = session;
        //    }
        //    extern NSString *NIMKitTeamMembersHasUpdatedNotification;
        //    info.notificationName = NIMKitTeamMembersHasUpdatedNotification;
        //    [self.firer addFireInfo:info];
    }
}
