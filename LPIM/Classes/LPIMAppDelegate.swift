//
//  AppDelegate.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

//#import "NTESAppDelegate.h"
//#import "NTESLoginViewController.h"
//#import "UIView+Toast.h"
//#import "NTESService.h"
//#import "NTESNotificationCenter.h"
//#import "NTESLogManager.h"
//#import "NTESDemoConfig.h"
//#import "NTESSessionUtil.h"
//#import "NTESMainTabController.h"
//#import "NTESLoginManager.h"
//#import "NTESCustomAttachmentDecoder.h"
//#import "NTESClientUtil.h"
//#import "NTESNotificationCenter.h"
//#import "NIMKit.h"
//#import "NTESSDKConfigDelegate.h"
//#import "NTESCellLayoutConfig.h"
//#import "NTESSubscribeManager.h"

@UIApplicationMain
class LPIMAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //    [self setupNIMSDK];
        //    [self setupServices];
        //    [self registerPushService];
        //    [self commonInitListenEvents];
        //
        //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //    self.window.backgroundColor = [UIColor grayColor];
        //    [self.window makeKeyAndVisible];
        //    [application setStatusBarStyle:UIStatusBarStyleLightContent];
        //
        //    [self setupMainViewController];
        //
        //
        //    DDLogInfo(@"launch with options %@",launchOptions);
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        //    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
        //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    //- (void)dealloc
    //{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    //}

}


// MARK: -
// MARK: - NIMLoginManagerDelegate

extension LPIMAppDelegate: NIMLoginManagerDelegate {
    
    // MARK: - NIMLoginManagerDelegate
    
    //#pragma NIMLoginManagerDelegate
    //-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
    //{
    //    NSString *reason = @"你被踢下线";
    //    switch (code) {
    //        case NIMKickReasonByClient:
    //        case NIMKickReasonByClientManually:{
    //            NSString *clientName = [NTESClientUtil clientName:clientType];
    //            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
    //            break;
    //        }
    //        case NIMKickReasonByServer:
    //            reason = @"你被服务器踢下线";
    //            break;
    //        default:
    //            break;
    //    }
    //    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }];
    //}
    //
    //- (void)onAutoLoginFailed:(NSError *)error
    //{
    //    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    //    DDLogInfo(@"onAutoLoginFailed %zd",error.code);
    //    [self showAutoLoginErrorAlert:error];
    //}

}


// MARK: - misc

extension LPIMAppDelegate {
    
    func setupMainViewController() {
        //    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
        //    NSString *account = [data account];
        //    NSString *token = [data token];
        //
        //    //如果有缓存用户名密码推荐使用自动登录
        //    if ([account length] && [token length])
        //    {
        //        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        //        loginData.account = account;
        //        loginData.token = token;
        //
        //        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        //        [[NTESServiceManager sharedManager] start];
        //        NTESMainTabController *mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
        //        self.window.rootViewController = mainTab;
        //    }
        //    else
        //    {
        //        [self setupLoginViewController];
        //    }
    }
    
    //- (void)setupLoginViewController
    //{
    //    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //    NTESLoginViewController *loginController = [[NTESLoginViewController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    //    self.window.rootViewController = nav;
    //}
    
    
    
    //- (void)commonInitListenEvents
    //{
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(logout:)
    //                                                 name:NTESNotificationLogout
    //                                               object:nil];
    //
    //    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    //}
    
    //#pragma mark - 注销
    //-(void)logout:(NSNotification*)note
    //{
    //    [self doLogout];
    //}
    //
    //- (void)doLogout
    //{
    //    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    //    [[NTESServiceManager sharedManager] destory];
    //    [self setupLoginViewController];
    //}
    
    
    //#pragma mark - logic impl
    //- (void)setupServices
    //{
    //    [[NTESLogManager sharedManager] start];
    //    [[NTESNotificationCenter sharedCenter] start];
    //    [[NTESSubscribeManager sharedManager] start];
    //}
    //
    //- (void)setupNIMSDK
    //{
    //    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
    //    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    //    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    //    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    //    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    //
    //
    //    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    //    NSString *appKey        = [[NTESDemoConfig sharedConfig] appKey];
    //    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    //    option.apnsCername      = [[NTESDemoConfig sharedConfig] apnsCername];
    //    option.pkCername        = [[NTESDemoConfig sharedConfig] pkCername];
    //    [[NIMSDK sharedSDK] registerWithOption:option];
    //
    //
    //    //注册自定义消息的解析器
    //    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    //
    //    //注册 NIMKit 自定义排版配置
    //    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig class]];
    //}
    //
    //#pragma mark - 登录错误回调
    //- (void)showAutoLoginErrorAlert:(NSError *)error
    //{
    //    NSString *message = [NTESSessionUtil formatAutoLoginMessage:error];
    //    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"自动登录失败"
    //                                                                message:message
    //                                                         preferredStyle:UIAlertControllerStyleAlert];
    //
    //    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
    //        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    //    {
    //        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
    //                                                              style:UIAlertActionStyleCancel
    //                                                            handler:^(UIAlertAction * _Nonnull action) {
    //                                                                LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    //                                                                NSString *account = [data account];
    //                                                                NSString *token = [data token];
    //                                                                if ([account length] && [token length])
    //                                                                {
    //                                                                    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
    //                                                                    loginData.account = account;
    //                                                                    loginData.token = token;
    //
    //                                                                    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
    //                                                                }
    //                                                            }];
    //        [vc addAction:retryAction];
    //    }
    //
    //
    //
    //    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销"
    //                                                           style:UIAlertActionStyleDestructive
    //                                                         handler:^(UIAlertAction * _Nonnull action) {
    //                                                             [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
    //                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    //                                                             }];
    //                                                         }];
    //    [vc addAction:logoutAction];
    //
    //    [self.window.rootViewController presentViewController:vc
    //                                                 animated:YES
    //                                               completion:nil];
    //}
}


