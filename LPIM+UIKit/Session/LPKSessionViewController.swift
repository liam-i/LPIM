//
//  LPKSessionViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/24.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK
//@interface NIMSessionViewController : UIViewController<NIMSessionInteractorDelegate,NIMInputActionDelegate,NIMMessageCellDelegate,NIMChatManagerDelegate,NIMConversationManagerDelegate>
//
//@property (nonatomic, strong)  UITableView *tableView;
//
//@property (nonatomic, strong)  NIMInputView *sessionInputView;
//
//@property (nonatomic, strong)  NIMSession *session;
//
//
//
//
///**
// *  当前当初的菜单所关联的消息
// *
// *  @discussion 在菜单点击方法中，想获取所点的消息，可以调用此接口
// */
//@property (nonatomic, strong, readonly)     NIMMessage *messageForMenu;
//
///**
// *  会话页主标题
// *
// *  @discussion 可以更改文字的大小，颜色等属性，文案内容请使用 - (NSString *)sessionTitle 接口
// */
//@property (nonatomic, strong, readonly)    UILabel *titleLabel;
//
///**
// *  会话页子标题
// *
// *  @discussion 可以更改文字的大小，颜色等属性，文案内容请使用 - (NSString *)sessionSubTitle 接口
// */
//@property (nonatomic, strong, readonly)    UILabel *subTitleLabel;
//
//
//
///**
// *  初始化方法
// *
// *  @param session 所属会话
// *
// *  @return 会话页实例
// */
//- (instancetype)initWithSession:(NIMSession *)session;
//
//
//#pragma mark - 界面
///**
// *  会话页导航栏标题
// */
//- (NSString *)sessionTitle;
//
///**
// *  会话页导航栏子标题
// */
//- (NSString *)sessionSubTitle;
//
///**
// *  刷新导航栏标题
// */
//- (void)refreshSessionTitle:(NSString *)title;
//
///**
// *  刷新导航子栏标题
// */
//- (void)refreshSessionSubTitle:(NSString *)title;
//
///**
// *  会话页长按消息可以弹出的菜单
// *
// *  @param message 长按的消息
// *
// *  @return 菜单，为UIMenuItem的数组
// */
//- (NSArray *)menusItems:(NIMMessage *)message;
//
///**
// *  会话页详细配置
// */
//- (id<NIMSessionConfig>)sessionConfig;
//
//
//#pragma mark - 消息接口
///**
// *  发送消息
// *
// *  @param message 消息
// */
//- (void)sendMessage:(NIMMessage *)message;
//
//#pragma mark - 录音接口
///**
// *  录音失败回调
// *
// *  @param error 失败原因
// */
//- (void)onRecordFailed:(NSError *)error;
//
///**
// *  录音内容是否可以被发送
// *
// *  @param filepath 录音路径
// *
// *  @return 是否允许发送
// *
// *  @discussion 在此回调里检查录音时长是否满足要求发送的录音时长
// */
//- (BOOL)recordFileCanBeSend:(NSString *)filepath;
//
///**
// *  语音不能发送的原因
// *
// *  @discussion 可以显示录音时间不满足要求之类的文案
// */
//- (void)showRecordFileNotSendReason;
//
//#pragma mark - 操作接口
//
///**
// *  追加一条消息
// *
// *  @param message 消息
// *
// *  @discussion 不会比较时间戳，直接加在消息列表末尾。不会触发 DB 操作，，请手动调用 SDK 里 saveMessage:forSession:completion: 接口。
// */
//
//- (void)uiAddMessages:(NSArray *)messages;
//
//
///**
// *  插入一条消息
// *
// *  @param message 消息
// *
// *  @discussion 会比较时间戳，加在合适的地方，不推荐聊天室这种大消息量场景使用。不会触发 DB 操作，，请手动调用 SDK 里 saveMessage:forSession:completion: 接口。
// */
//
//- (void)uiInsertMessages:(NSArray *)messages;
//
///**
// *  删除一条消息
// *
// *  @param message 消息
// *
// *  @return 被删除的 MessageModel
// *
// *  @discussion 不会触发 DB 操作，请手动调用 SDK 里 deleteMessage: 接口
// */
//- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message;
//
///**
// *  更新一条消息
// *
// *  @param message 消息
// *
// *  @discussion 不会触发 DB 操作，请手动调用 SDK 里 updateMessage:forSession:completion: 接口
// */
//- (void)uiUpdateMessage:(NIMMessage *)message;
//
//@end

class LPKSessionViewController: UIViewController {

    convenience init(session: NIMSession) {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    /// 相册
    func onTapMediaItemPicture(_ item: LPKMediaItem) {
        
    }
    
    /// 拍摄
    func onTapMediaItemShoot(_ item: LPKMediaItem) {
        
    }
    
    /// 位置
    func onTapMediaItemLocation(_ item: LPKMediaItem) {
        
    }

}


//@interface NIMSessionViewController ()<NIMMediaManagerDelegate,NIMInputDelegate>
//
//@property (nonatomic,readwrite) NIMMessage *messageForMenu;
//
//@property (nonatomic,strong)    UILabel *titleLabel;
//
//@property (nonatomic,strong)    UILabel *subTitleLabel;
//
//@property (nonatomic,strong)    NSIndexPath *lastVisibleIndexPathBeforeRotation;
//
//@property (nonatomic,strong)  NIMSessionConfigurator *configurator;
//
//@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;
//
//@end
//
//@implementation NIMSessionViewController
//
//- (instancetype)initWithSession:(NIMSession *)session{
//    self = [super initWithNibName:nil bundle:nil];
//    if (self) {
//        _session = session;
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    [self removeListener];
//
//    _tableView.delegate = nil;
//    _tableView.dataSource = nil;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //导航栏
//    [self setupNav];
//    //消息 tableView
//    [self setupTableView];
//    //输入框 inputView
//    [self setupInputView];
//    //会话相关逻辑配置器安装
//    [self setupConfigurator];
//    //添加监听
//    [self addListener];
//    //进入会话时，标记所有消息已读，并发送已读回执
//    [self markRead];
//    //更新已读位置
//    [self uiCheckReceipt];
//}
//
//- (void)setupNav
//{
//    [self setUpTitleView];
//    NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] init];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.leftItemsSupplementBackButton = YES;
//}
//
//- (void)setupTableView
//{
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.tableView.backgroundColor = NIMKit_UIColorFromRGB(0xe4e7ec);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//    [self.view addSubview:self.tableView];
//}
//
//
//- (void)setupInputView
//{
//    BOOL disableInputView = NO;
//    if ([self.sessionConfig respondsToSelector:@selector(disableInputView)]) {
//        disableInputView = [self.sessionConfig disableInputView];
//    }
//    if (!disableInputView) {
//        self.sessionInputView = [[NIMInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.nim_width,0) config:self.sessionConfig];
//        [self.sessionInputView refreshStatus:NIMInputStatusText];
//        [self.sessionInputView setSession:self.session];
//        [self.sessionInputView setInputDelegate:self];
//        [self.sessionInputView setInputActionDelegate:self];
//        [self.view addSubview:_sessionInputView];
//
//        self.tableView.nim_height -= self.sessionInputView.toolBar.nim_height;
//    }
//}
//
//
//- (void)setupConfigurator
//{
//    _configurator = [[NIMSessionConfigurator alloc] init];
//    [_configurator setup:self];
//
//    BOOL needProximityMonitor = YES;
//    if ([self.sessionConfig respondsToSelector:@selector(disableProximityMonitor)]) {
//        needProximityMonitor = !self.sessionConfig.disableProximityMonitor;
//    }
//    [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:needProximityMonitor];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.interactor onViewWillAppear];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.interactor onViewDidDisappear];
//
//    [self.sessionInputView endEditing:YES];
//}
//
//
//- (void)viewDidLayoutSubviews{
//    [self changeLeftBarBadge:self.conversationManager.allUnreadCount];
//    [self.interactor resetLayout];
//}
//
//
//
//#pragma mark - 消息收发接口
//- (void)sendMessage:(NIMMessage *)message
//{
//    [self.interactor sendMessage:message];
//}
//
//
//#pragma mark - Touch Event
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [_sessionInputView endEditing:YES];
//}
//
//
//#pragma mark - NIMSessionConfiguratorDelegate
//
//- (void)didFetchMessageData
//{
//    [self uiCheckReceipt];
//    [self.tableView reloadData];
//    [self.tableView nim_scrollToBottom:NO];
//}
//
//- (void)didRefreshMessageData
//{
//    [self refreshSessionTitle:self.sessionTitle];
//    [self refreshSessionSubTitle:self.sessionSubTitle];
//    [self.tableView reloadData];
//}
//
//#pragma mark - 会话title
//- (NSString *)sessionTitle
//{
//    NSString *title = @"";
//    NIMSessionType type = self.session.sessionType;
//    switch (type) {
//        case NIMSessionTypeTeam:{
//            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
//            title = [NSString stringWithFormat:@"%@(%zd)",[team teamName],[team memberNumber]];
//        }
//            break;
//        case NIMSessionTypeP2P:{
//            title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
//        }
//            break;
//        default:
//            break;
//    }
//    return title;
//}
//
//- (NSString *)sessionSubTitle{return @"";};
//
//#pragma mark - NIMChatManagerDelegate
//
//- (void)willSendMessage:(NIMMessage *)message
//{
//    id<NIMSessionInteractor> interactor = self.interactor;
//
//    if ([message.session isEqual:self.session]) {
//        if ([interactor findMessageModel:message]) {
//            [interactor updateMessage:message];
//        }else{
//            [interactor addMessages:@[message]];
//        }
//    }
//}
//
////发送结果
//- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
//{
//    if ([message.session isEqual:_session]) {
//        [self.interactor updateMessage:message];
//    }
//}
//
////发送进度
//-(void)sendMessage:(NIMMessage *)message progress:(float)progress
//{
//    if ([message.session isEqual:_session]) {
//        [self.interactor updateMessage:message];
//    }
//}
//
////接收消息
//- (void)onRecvMessages:(NSArray *)messages
//{
//    NIMMessage *message = messages.firstObject;
//    NIMSession *session = message.session;
//    if (![session isEqual:self.session] || !messages.count){
//        return;
//    }
//
//    [self uiAddMessages:messages];
//    [self sendMessageReceipt:messages];
//
//    [self.conversationManager markAllMessagesReadInSession:self.session];
//}
//
//
//- (void)fetchMessageAttachment:(NIMMessage *)message progress:(float)progress
//{
//    if ([message.session isEqual:_session]) {
//        [self.interactor updateMessage:message];
//    }
//}
//
//- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
//{
//    if ([message.session isEqual:_session]) {
//        NIMMessageModel *model = [self.interactor findMessageModel:message];
//        //下完缩略图之后，因为比例有变化，重新刷下宽高。
//        [model calculateContent:self.tableView.frame.size.width force:YES];
//        [self.interactor updateMessage:message];
//    }
//}
//
//- (void)onRecvMessageReceipt:(NIMMessageReceipt *)receipt
//{
//    if ([receipt.session isEqual:self.session] && [self shouldHandleReceipt]) {
//        [self uiCheckReceipt];
//    }
//}
//
//#pragma mark - NIMConversationManagerDelegate
//- (void)messagesDeletedInSession:(NIMSession *)session{
//    [self.interactor resetMessages];
//    [self.tableView reloadData];
//}
//
//- (void)didAddRecentSession:(NIMRecentSession *)recentSession
//           totalUnreadCount:(NSInteger)totalUnreadCount{
//    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
//}
//
//- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
//              totalUnreadCount:(NSInteger)totalUnreadCount{
//    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
//}
//
//- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
//              totalUnreadCount:(NSInteger)totalUnreadCount{
//    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
//}
//
//
//- (void)changeUnreadCount:(NIMRecentSession *)recentSession
//         totalUnreadCount:(NSInteger)totalUnreadCount{
//    if ([recentSession.session isEqual:self.session]) {
//        return;
//    }
//    [self changeLeftBarBadge:totalUnreadCount];
//}
//
//#pragma mark - NIMMediaManagerDelegate
//- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
//    if (!filePath || error) {
//        _sessionInputView.recording = NO;
//        [self onRecordFailed:error];
//    }
//}
//
//- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
//    if(!error) {
//        if ([self recordFileCanBeSend:filePath]) {
//            [self sendMessage:[NIMMessageMaker msgWithAudio:filePath]];
//        }else{
//            [self showRecordFileNotSendReason];
//        }
//    } else {
//        [self onRecordFailed:error];
//    }
//    _sessionInputView.recording = NO;
//}
//
//- (void)recordAudioDidCancelled {
//    _sessionInputView.recording = NO;
//}
//
//- (void)recordAudioProgress:(NSTimeInterval)currentTime {
//    [_sessionInputView updateAudioRecordTime:currentTime];
//}
//
//- (void)recordAudioInterruptionBegin {
//    [[NIMSDK sharedSDK].mediaManager cancelRecord];
//}
//
//#pragma mark - 录音相关接口
//- (void)onRecordFailed:(NSError *)error{}
//
//- (BOOL)recordFileCanBeSend:(NSString *)filepath
//{
//    return YES;
//}
//
//- (void)showRecordFileNotSendReason{}
//
//#pragma mark - NIMInputDelegate
//- (void)showInputView
//{
//    [self.tableView setUserInteractionEnabled:NO];
//}
//
//- (void)hideInputView
//{
//    [self.tableView setUserInteractionEnabled:YES];
//}
//
//- (void)inputViewSizeToHeight:(CGFloat)height showInputView:(BOOL)show
//{
//    [self.tableView setUserInteractionEnabled:!show];
//    [self.interactor changeLayout:height];
//}
//
//#pragma mark - NIMInputActionDelegate
//- (BOOL)onTapMediaItem:(NIMMediaItem *)item{
//    SEL sel = item.selctor;
//    BOOL handled = sel && [self respondsToSelector:sel];
//    if (handled) {
//        NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
//        handled = YES;
//    }
//    return handled;
//}
//
//- (void)onTextChanged:(id)sender{}
//
//- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers
//{
//    NIMMessage *message = [NIMMessageMaker msgWithText:text];
//    if (atUsers.count) {
//        NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
//        apnsOption.userIds = atUsers;
//        apnsOption.forcePush = YES;
//
//        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
//        option.session = self.session;
//
//        NSString *me = [[NIMKit sharedKit].provider infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option].showName;
//        apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你",me];
//        message.apnsMemberOption = apnsOption;
//    }
//    [self sendMessage:message];
//}
//
//- (void)onSelectChartlet:(NSString *)chartletId
//                 catalog:(NSString *)catalogId{}
//
//- (void)onCancelRecording
//{
//    [[NIMSDK sharedSDK].mediaManager cancelRecord];
//}
//
//- (void)onStopRecording
//{
//    [[NIMSDK sharedSDK].mediaManager stopRecord];
//}
//
//- (void)onStartRecording
//{
//    _sessionInputView.recording = YES;
//
//    NIMAudioType type = NIMAudioTypeAAC;
//    if ([self.sessionConfig respondsToSelector:@selector(recordType)])
//    {
//        type = [self.sessionConfig recordType];
//    }
//
//    NSTimeInterval duration = [NIMKitUIConfig sharedConfig].globalConfig.recordMaxDuration;
//
//    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
//
//    [[NIMSDK sharedSDK].mediaManager record:type
//                                     duration:duration];
//}
//
//#pragma mark - NIMMessageCellDelegate
//- (BOOL)onTapCell:(NIMKitEvent *)event{
//    BOOL handle = NO;
//    NSString *eventName = event.eventName;
//    if ([eventName isEqualToString:NIMKitEventNameTapAudio])
//    {
//        [self.interactor mediaAudioPressed:event.messageModel];
//        handle = YES;
//    }
//    return handle;
//}
//
//- (void)onRetryMessage:(NIMMessage *)message
//{
//    if (message.isReceivedMsg) {
//        [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:message
//                                                           error:nil];
//    }else{
//        [[[NIMSDK sharedSDK] chatManager] resendMessage:message
//                                                  error:nil];
//    }
//}
//
//- (BOOL)onLongPressCell:(NIMMessage *)message
//                 inView:(UIView *)view
//{
//    BOOL handle = NO;
//    NSArray *items = [self menusItems:message];
//    if ([items count] && [self becomeFirstResponder]) {
//        UIMenuController *controller = [UIMenuController sharedMenuController];
//        controller.menuItems = items;
//        _messageForMenu = message;
//        [controller setTargetRect:view.bounds inView:view];
//        [controller setMenuVisible:YES animated:YES];
//        handle = YES;
//    }
//    return handle;
//}
//
//#pragma mark - 配置项
//- (id<NIMSessionConfig>)sessionConfig
//{
//    return nil;
//}
//
//#pragma mark - 菜单
//- (NSArray *)menusItems:(NIMMessage *)message
//{
//    NSMutableArray *items = [NSMutableArray array];
//
//    if (message.messageType == NIMMessageTypeText) {
//        [items addObject:[[UIMenuItem alloc] initWithTitle:@"复制"
//                                                    action:@selector(copyText:)]];
//    }
//    [items addObject:[[UIMenuItem alloc] initWithTitle:@"删除"
//                                                action:@selector(deleteMsg:)]];
//    return items;
//
//}
//
//- (NIMMessage *)messageForMenu
//{
//    return _messageForMenu;
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    NSArray *items = [[UIMenuController sharedMenuController] menuItems];
//    for (UIMenuItem *item in items) {
//        if (action == [item action]){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//
//- (void)copyText:(id)sender
//{
//    NIMMessage *message = [self messageForMenu];
//    if (message.text.length) {
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        [pasteboard setString:message.text];
//    }
//}
//
//- (void)deleteMsg:(id)sender
//{
//    NIMMessage *message    = [self messageForMenu];
//    [self uiDeleteMessage:message];
//    [self.conversationManager deleteMessage:message];
//}
//
//- (void)menuDidHide:(NSNotification *)notification
//{
//    [UIMenuController sharedMenuController].menuItems = nil;
//}
//
//
//#pragma mark - 操作接口
//- (void)uiAddMessages:(NSArray *)messages
//{
//    [self.interactor addMessages:messages];
//}
//
//- (void)uiInsertMessages:(NSArray *)messages
//{
//    [self.interactor insertMessages:messages];
//}
//
//- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message{
//    NIMMessageModel *model = [self.interactor deleteMessage:message];
//    if (model.shouldShowReadLabel)
//    {
//        [self uiCheckReceipt];
//    }
//    return model;
//}
//
//- (void)uiUpdateMessage:(NIMMessage *)message{
//    [self.interactor updateMessage:message];
//}
//
//- (void)uiCheckReceipt
//{
//    if ([self shouldHandleReceipt]) {
//        [self.interactor checkReceipt];
//    }
//}
//
//#pragma mark - NIMMeidaButton
//- (void)onTapMediaItemPicture:(NIMMediaItem *)item
//{
//    [self.interactor mediaPicturePressed];
//}
//
//- (void)onTapMediaItemShoot:(NIMMediaItem *)item
//{
//    [self.interactor mediaShootPressed];
//}
//
//- (void)onTapMediaItemLocation:(NIMMediaItem *)item
//{
//    [self.interactor mediaLocationPressed];
//}
//
//#pragma mark - 旋转处理 (iOS8 or above)
//- (void)viewWillTransitionToSize:(CGSize)size
//       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    self.lastVisibleIndexPathBeforeRotation = [self.tableView indexPathsForVisibleRows].lastObject;
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    if (self.view.window) {
//        __weak typeof(self) wself = self;
//        [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
//         {
//             [[NIMSDK sharedSDK].mediaManager cancelRecord];
//             [wself.interactor cleanCache];
//             [wself.sessionInputView reset];
//             [wself.tableView reloadData];
//             [wself.tableView scrollToRowAtIndexPath:wself.lastVisibleIndexPathBeforeRotation atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//         } completion:nil];
//    }
//}
//
//
//#pragma mark - 标记已读
//- (void)markRead
//{
//    if (![self disableAutoMarkRead]) {
//        [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
//        [self sendMessageReceipt:self.interactor.items];
//    }
//}
//
//#pragma mark - 已读回执
//- (void)sendMessageReceipt:(NSArray *)messages
//{
//    if ([self shouldHandleReceipt]) {
//        [self.interactor sendMessageReceipt:messages];
//    }
//}
//
//
//#pragma mark - Private
//
//- (void)addListener
//{
//
//    if (![self.sessionConfig respondsToSelector:@selector(disableReceiveNewMessages)]
//        || ![self.sessionConfig disableReceiveNewMessages]) {
//        [[NIMSDK sharedSDK].chatManager addDelegate:self];
//    }
//    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
//}
//
//- (void)removeListener
//{
//    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
//    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
//}
//
//- (void)changeLeftBarBadge:(NSInteger)unreadCount
//{
//    NIMCustomLeftBarView *leftBarView = (NIMCustomLeftBarView *)self.navigationItem.leftBarButtonItem.customView;
//    leftBarView.badgeView.badgeValue = @(unreadCount).stringValue;
//    leftBarView.badgeView.hidden = !unreadCount;
//}
//
//
//- (BOOL)shouldHandleReceipt
//{
//    return [self.interactor shouldHandleReceipt];
//}
//
//
//- (BOOL)disableAutoMarkRead
//{
//    return [self.sessionConfig respondsToSelector:@selector(disableAutoMarkMessageRead)] &&
//    [self.sessionConfig disableAutoMarkMessageRead];
//}
//
//- (id<NIMConversationManager>)conversationManager{
//    switch (self.session.sessionType) {
//        case NIMSessionTypeChatroom:
//            return nil;
//            break;
//        case NIMSessionTypeP2P:
//        case NIMSessionTypeTeam:
//        default:
//            return [NIMSDK sharedSDK].conversationManager;
//    }
//}
//
//
//- (void)setUpTitleView
//{
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
//    self.titleLabel.text = self.sessionTitle;
//
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//
//    self.subTitleLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.subTitleLabel.textColor = [UIColor grayColor];
//    self.subTitleLabel.font = [UIFont systemFontOfSize:12.f];
//    self.subTitleLabel.text = self.sessionSubTitle;
//    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
//
//    UIView *titleView = [[UIView alloc] init];
//    [titleView addSubview:self.titleLabel];
//    [titleView addSubview:self.subTitleLabel];
//
//    self.navigationItem.titleView = titleView;
//
//    [self layoutTitleView];
//
//}
//
//- (void)layoutTitleView
//{
//    CGFloat maxLabelWidth = 150.f;
//    [self.titleLabel sizeToFit];
//    self.titleLabel.nim_width = maxLabelWidth;
//
//    [self.subTitleLabel sizeToFit];
//    self.subTitleLabel.nim_width = maxLabelWidth;
//
//
//    UIView *titleView = self.navigationItem.titleView;
//
//    titleView.nim_width  = MAX(self.titleLabel.nim_width, self.subTitleLabel.nim_width);
//    titleView.nim_height = self.titleLabel.nim_height + self.subTitleLabel.nim_height;
//
//    self.subTitleLabel.nim_bottom  = titleView.nim_height;
//}
//
//
//
//- (void)refreshSessionTitle:(NSString *)title
//{
//    self.titleLabel.text = title;
//    [self layoutTitleView];
//}
//
//
//- (void)refreshSessionSubTitle:(NSString *)title
//{
//    self.subTitleLabel.text = title;
//    [self layoutTitleView];
//}
//
//
//@end
//
