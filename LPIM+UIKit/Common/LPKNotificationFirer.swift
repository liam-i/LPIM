//
//  LPKNotificationFirer.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

class LPKNotificationFirer: NSObject, LPKTimerHolderDelegate {
    lazy var cachedInfo: [String: LPKFirerInfo] = [:]
    lazy var timer: LPKTimerHolder = LPKTimerHolder()
    lazy var timeInterval: TimeInterval = 1.0
    
    func addFireInfo(_ info: LPKFirerInfo) {
        assert(Thread.isMainThread, "info must be fired in main thread")
        if cachedInfo.count == 0 {
            timer.startTimer(seconds: timeInterval, delegate: self, repeats: false)
        }
        cachedInfo[info.saveIdentity()] = info
    }
    
    func onLPKTimerFired(holder: LPKTimerHolder) {
        var dict: [String: [Any]] = [:]
        for info in cachedInfo.values {
            var fireInfos = dict[info.notificationName] ?? []
            fireInfos.append(info.fireObject())
            dict[info.notificationName] = fireInfos
        }
        
        for notification in dict {
            let userinfo = ["InfoId": notification.value]
            NotificationCenter.default.post(name: Notification.Name(notification.key), object: nil, userInfo: userinfo)
        }
        cachedInfo.removeAll()
    }
}

class LPKFirerInfo {
    var session: NIMSession?
    var notificationName: String = ""
    
    func fireObject() -> Any {
        if let session = session {
            return session.sessionId
        }
        return NSNull()
    }
    
    func saveIdentity() -> String {
        if let session = session {
            return String(format: "%@-%zd", session.sessionId, session.sessionType.rawValue)
        }
        return notificationName
    }
}
