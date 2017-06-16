//
//  LPIMAppDelegate+Push.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import PushKit
import NIMSDK
import SwiftyJSON

// TODO: - 适配 UserNotifications #available(iOS 10.0, *)

// MARK: -
// MARK: - apns / pushkit

extension LPIMAppDelegate: PKPushRegistryDelegate {
    
    /// 注册推送服务
    func registerPushService() {
        
        // apns
        UIApplication.shared.registerForRemoteNotifications()
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        // pushkit
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NIMSDK.shared().updateApnsToken(deviceToken)
        log.info(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        log.info(userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error(error)
    }
    
    // MARK: - PKPushRegistryDelegate
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenForType type: PKPushType) {
        log.info("registry=\(registry), invalidate=\(type)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        if type == .voIP {
            NIMSDK.shared().updatePushKitToken(credentials.token)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        log.info("receive payload=\(payload.dictionaryPayload), type=\(type)")
        
        let json = JSON(payload.dictionaryPayload)
        let badge = json["aps"]["badge"].intValue
        UIApplication.shared.applicationIconBadgeNumber = badge
    }
}

