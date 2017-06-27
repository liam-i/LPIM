//
//  LPMainTabBarController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPMainTabBarController: UITabBarController {
    static let shared: LPMainTabBarController? = {
        if let appDelegate = UIApplication.shared.delegate as? LPIMAppDelegate, let vc = appDelegate.window?.rootViewController {
            if vc is LPMainTabBarController {
                return vc as? LPMainTabBarController
            }
        }
        return nil
    }()
    
//    fileprivate var navigationHandlers: NSArray?
//    fileprivate var animator: NTESNavigationAnimator?
    fileprivate var sessionUnreadCount: Int = 0
    fileprivate var systemUnreadCount: Int = 0
    fileprivate var customSystemUnreadCount: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
    
    deinit {
        NIMSDK.shared().systemNotificationManager.remove(self)
        NIMSDK.shared().conversationManager.remove(self)
        NotificationCenter.default.removeObserver(self)
        log.warning("release memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()

//        NIMSDK.shared().systemNotificationManager.add(self)
//        NIMSDK.shared().conversationManager.add(self)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(customNotificationCountChanged),
//                                               name: kCustomNotificationCountChanged,
//                                               object: nil)
    }
    
    
    
    
    func setupViewControllers() {
        sessionUnreadCount = NIMSDK.shared().conversationManager.allUnreadCount()
        systemUnreadCount = NIMSDK.shared().systemNotificationManager.allUnreadCount()
//    self.customSystemUnreadCount = [[NTESCustomNotificationDB sharedInstance] unreadCount];
        
        let tabbars: [(vc: UIViewController, title: String, image_n: UIImage, image_s: UIImage, badgeValue: Int)] = [
            (LPSessionListViewController(), "LPIM", #imageLiteral(resourceName: "icon_message_normal"), #imageLiteral(resourceName: "icon_message_pressed"), sessionUnreadCount),
            (LPContactViewController(), "通讯录", #imageLiteral(resourceName: "icon_contact_normal"), #imageLiteral(resourceName: "icon_contact_pressed"), systemUnreadCount),
            (LPContactViewController(), "直播间", #imageLiteral(resourceName: "icon_chatroom_normal"), #imageLiteral(resourceName: "icon_chatroom_pressed"), 0),
            (LPSettingViewController(), "设置", #imageLiteral(resourceName: "icon_setting_normal"), #imageLiteral(resourceName: "icon_setting_pressed"), customSystemUnreadCount),
        ]
        
        //var handleArray: [Int] = []
        var vcArray: [UIViewController] = []
        tabbars.forEach { (item) in
            let vc = item.vc
            let nav = LPBaseNavigationController(rootViewController: vc)
            nav.tabBarItem = UITabBarItem(title: item.title, image: item.image_n, selectedImage: item.image_s)
            nav.tabBarItem.badgeValue = item.badgeValue > 0 ? "\(item.badgeValue)" : nil
            nav.tabBarItem.titlePositionAdjustment.vertical = -3.0
            
            //        NTESNavigationHandler *handler = [[NTESNavigationHandler alloc] initWithNavigationController:nav];
            //        nav.delegate = handler;
            
            vcArray.append(nav)
//            [handleArray addObject:handler];
        }
        viewControllers = vcArray
//        navigationHandlers = [NSArray arrayWithArray:handleArray];
    }
}

// MARK: -
// MARK: - Private

extension LPMainTabBarController {
    fileprivate func refreshSessionBadge() {
        viewControllers?[0].tabBarItem.badgeValue = sessionUnreadCount > 0 ? "\(sessionUnreadCount)" : nil
    }
    
    fileprivate func refreshContactBadge() {
        viewControllers?[1].tabBarItem.badgeValue = systemUnreadCount > 0 ? "\(systemUnreadCount)" : nil
    }
    
    fileprivate func refreshSettingBadge() {
        viewControllers?[3].tabBarItem.badgeValue = customSystemUnreadCount > 0 ? "\(customSystemUnreadCount)" : nil
    }
    
    //#pragma mark - Rotate
    //
    //- (BOOL)shouldAutorotate{
    //    BOOL enableRotate = [NTESBundleSetting sharedConfig].enableRotate;
    //    return enableRotate ? [self.selectedViewController shouldAutorotate] : NO;
    //}
    //
    //- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //    BOOL enableRotate = [NTESBundleSetting sharedConfig].enableRotate;
    //    return enableRotate ? [self.selectedViewController supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
    //}
}

// MARK: - 
// MARK: - Delegate / Notification

extension LPMainTabBarController: NIMSystemNotificationManagerDelegate, NIMConversationManagerDelegate {
    
    // MARK: - Notification
    
    func customNotificationCountChanged(_ notification: Notification) {
        //    NTESCustomNotificationDB *db = [NTESCustomNotificationDB sharedInstance];
        //    self.customSystemUnreadCount = db.unreadCount;
        //    [self refreshSettingBadge];
    }
    
    // MARK: - NIMSystemNotificationManagerDelegate
    
    func onSystemNotificationCountChanged(_ unreadCount: Int) {
        systemUnreadCount = unreadCount
        refreshContactBadge()
    }
    
    // MARK: - NIMConversationManagerDelegate
    
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        sessionUnreadCount = totalUnreadCount
        refreshSessionBadge()
    }
    
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        sessionUnreadCount = totalUnreadCount
        refreshSessionBadge()
    }
    
    func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        sessionUnreadCount = totalUnreadCount
        refreshSessionBadge()
    }
    
    func messagesDeleted(in session: NIMSession) {
        sessionUnreadCount = NIMSDK.shared().conversationManager.allUnreadCount()
        refreshSessionBadge()
    }
    
    func allMessagesDeleted() {
        sessionUnreadCount = 0
        refreshSessionBadge()
    }
}
