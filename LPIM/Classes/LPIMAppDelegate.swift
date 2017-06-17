//
//  AppDelegate.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK
import IQKeyboardManagerSwift

@UIApplicationMain
class LPIMAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        setupNIMSDK()
        setupServices()
        registerPushService()
        setupListenEvents()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.gray
        window?.makeKeyAndVisible()
        application.setStatusBarStyle(.lightContent, animated: true)
        
        setupMainViewController()
        
        log.info("launch with options \(String(describing: launchOptions))")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let count = NIMSDK.shared().conversationManager.allUnreadCount()
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NIMSDK.shared().loginManager.remove(self)
    }
}


// MARK: -
// MARK: - NIMLoginManagerDelegate

extension LPIMAppDelegate: NIMLoginManagerDelegate {
    
    // MARK: - NIMLoginManagerDelegate
    
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        var reason = "你被踢下线"
        switch code {
        case .byClient, .byClientManually:
            let clientName = clientType.clientName
            reason = clientName.characters.count > 0 ? "你的帐号被“\(clientName)”端踢出下线，请注意帐号信息安全" : "你的帐号被踢出下线，请注意帐号信息安全"
        case .byServer:
            reason = "你被服务器踢下线"
        }
        
        NIMSDK.shared().loginManager.logout { (error) in
            NotificationCenter.default.post(name: kLogoutNotification, object: nil)
            self.window?.rootViewController?.showAlert("下线通知", msg: reason)
        }
    }
    
    func onAutoLoginFailed(_ error: Error) {
        let error = error as NSError

        /// 只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
        log.error(error)
        let msg = LPSessionUtil.formatAutoLoginMessage(error: error)
        let alert = UIAlertController(title: "自动登录失败", message: msg, preferredStyle: .alert)
        if error.domain == NIMLocalErrorDomain && error.code == NIMLocalErrorCode.autoLoginRetryLimit.rawValue {
            alert.addAction(UIAlertAction(title: "重试", style: .cancel, handler: { (_) in
                guard let data = LPLoginManager.shared.currentLoginData else { return }
                guard let account = data.account else { return }
                guard let token = data.token else { return }
                if account.characters.count > 0 && token.characters.count > 0 {
                    let loginData = NIMAutoLoginData()
                    loginData.account = account
                    loginData.token = token
                    NIMSDK.shared().loginManager.autoLogin(loginData)
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "注销", style: .destructive, handler: { (_) in
            NIMSDK.shared().loginManager.logout({ (error) in
                NotificationCenter.default.post(name: kLogoutNotification, object: nil)
            })
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


// MARK: - misc

extension LPIMAppDelegate {
    
    func setupMainViewController() {
        // 如果有缓存用户名密码推荐使用自动登录
        if let data = LPLoginManager.shared.currentLoginData
            , let account = data.account, account.characters.count > 0
            , let token = data.token, token.characters.count > 0 {
            
            let loginData = NIMAutoLoginData()
            loginData.account = account
            loginData.token = token
            
            NIMSDK.shared().loginManager.autoLogin(loginData)
            LPServiceManager.shared.start()
            let mainVC = LPMainTabBarController()
            window?.rootViewController = mainVC
        } else {
            setupLoginViewController()
        }
        
    }
    
    func setupLoginViewController() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        let loginVC = LPLoginViewController(nibName: "LPLoginViewController", bundle: nil)
        window?.rootViewController = UINavigationController(rootViewController: loginVC)
    }
    
    func setupListenEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logoutNotification),
                                               name: kLogoutNotification,
                                               object: nil)
        NIMSDK.shared().loginManager.add(self)
    }
    
    // MARK: - 注销
    
    func logoutNotification(_ note: Notification) {
        LPLoginManager.shared.currentLoginData = nil
        LPServiceManager.shared.destory()
        setupLoginViewController()
    }
    
    // MARK: - logic impl
    
    func setupServices() {
        //    [[NTESLogManager sharedManager] start];
        //    [[NTESNotificationCenter sharedCenter] start];
        //    [[NTESSubscribeManager sharedManager] start];
    }
    
    func setupNIMSDK() {
        /// 在注册 LPIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
        NIMSDKConfig.shared().delegate = LPIMSDKConfigDelegate()
        NIMSDKConfig.shared().shouldSyncUnreadCount = true
        NIMSDKConfig.shared().maxAutoLoginRetryTimes = 10

        /// appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
        /// 如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
        /// 并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
        let option = NIMSDKOption(appKey: LPConfig.shared.appKey)
        option.apnsCername = LPConfig.shared.apnsCername
        option.pkCername = LPConfig.shared.pkCername
        NIMSDK.shared().register(with: option)
        
        /// 注册自定义消息的解析器
        //NIMCustomObject.registerCustomDecoder(NTESCustomAttachmentDecoder())
        
        /// 注册 NIMKit 自定义排版配置
        //[[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig class]];
    }
}


