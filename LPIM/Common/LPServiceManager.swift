//
//  LPServiceManager.swift
//  LPIM
//
//  Created by lipeng on 2017/6/18.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

// MARK: -
// MARK: - LPService

//@objc protocol LPServiceDelegate {
//    @objc optional func onCleanData()
//    @objc optional func onReceiveMemoryWarning()
//    @objc optional func onEnterBackground()
//    @objc optional func onEnterForeground()
//    @objc optional func onAppWillTerminate()
//}

class LPService: NSObject {
    static let shared: LPService? = { return LPServiceManager.shared.singleton(by: LPService.self) }()
    
    override required  init() {
        super.init()
    }
    
    /// 空方法，只是输出log而已
    /// 大部分的NIMService懒加载即可，但是有些因为业务需要在登录后就需要立马生成
    func start() {
        log.debug("LPService \(self) Started")
    }
}

// MARK: - 
// MARK: - LPServiceManager

class LPServiceManager: NSObject {
    fileprivate let lock: NSRecursiveLock = NSRecursiveLock()
    fileprivate var core: LPServiceManagerImpl?
    
    static let shared: LPServiceManager = { return LPServiceManager() }()
//    override init() {
//        super.init()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(callReceiveMemoryWarning),
//                                               name: .UIApplicationDidReceiveMemoryWarning,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(callEnterBackground),
//                                               name: .UIApplicationDidEnterBackground,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(callEnterForeground),
//                                               name: .UIApplicationWillEnterForeground,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(callAppWillTerminate),
//                                               name: .UIApplicationWillTerminate,
//                                               object: nil)
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        lock.lock()
        let key = NIMSDK.shared().loginManager.currentAccount()
        core = LPServiceManagerImpl(key: key)
        lock.unlock()
    }
    
    func destory() {
        lock.lock()
        //callSingletonClean()
        core = nil
        lock.unlock()
    }
}

// MARK: - Private

extension LPServiceManager {
    
    fileprivate func singleton(by singletonClass: AnyClass) -> LPService? {
        var instance: LPService?
        lock.lock()
        instance = core?.singleton(by: singletonClass)
        lock.unlock()
        return instance
    }
    
    // MARK: - Call Functions
    
//    fileprivate func callSingletonClean() {
//        call(selector: #selector(onCleanData))
//    }
//    
//    func callReceiveMemoryWarning() {
//        call(selector: #selector(onReceiveMemoryWarning))
//    }
//    
//    func callEnterBackground() {
//        call(selector: #selector(onEnterBackground))
//    }
//    
//    func callEnterForeground() {
//        call(selector: #selector(onEnterForeground))
//    }
//    
//    func callAppWillTerminate() {
//        call(selector: #selector(onAppWillTerminate))
//    }
    
    fileprivate func call(selector: Selector) {
        core?.callSingleton(selector: selector)
    }
    
}

fileprivate class LPServiceManagerImpl {
    var key: String
    var singletons: [AnyHashable: LPService] = [:]
    
    init(key: String) {
        self.key = key
    }
    
    func singleton(by singletonClass: AnyClass) -> LPService? {
        let singletonClassName = NSStringFromClass(singletonClass)
        var singleton = singletons[singletonClassName]
        if singleton == nil, let serviceType = singletonClass as? LPService.Type  {
            singleton = serviceType.init()
            singletons[singletonClassName] = singleton
        }
        return singleton
    }
    
    func callSingleton(selector: Selector) {
        for obj in singletons.values where obj.responds(to: selector) {
            obj.perform(selector)
        }
    }
}
