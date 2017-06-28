//
//  LPContactViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/19.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPContactViewController: LPBaseTableViewController {
    
    fileprivate var contacts: LPGroupedContacts!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NIMSDK.shared().systemNotificationManager.remove(self)
        NIMSDK.shared().loginManager.remove(self)
        NIMSDK.shared().userManager.remove(self)
        NIMSDK.shared().subscribeManager.remove(self)
        
        log.warning("release memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        
        
        
        NIMSDK.shared().systemNotificationManager.add(self)
        NIMSDK.shared().loginManager.add(self)
        NIMSDK.shared().userManager.add(self)
        NIMSDK.shared().subscribeManager.add(self)
    }
}

// MARK: - 
// MARK: - Private

extension LPContactViewController {
    
    fileprivate func prepareData() {
        contacts = LPGroupedContacts()
        
        let contactCellUtilIcon   = "icon"
        let contactCellUtilVC     = "vc"
        let contactCellUtilBadge  = "badge"
        let contactCellUtilTitle  = "title"
        let contactCellUtilUid    = "uid"
        let contactCellUtilSelectorName = "selName"
        
        /// 原始数据
        let systemCount = NIMSDK.shared().systemNotificationManager.allUnreadCount()
        let utils: [[String: Any]] = [[contactCellUtilIcon: #imageLiteral(resourceName: "icon_notification_normal"),
                                       contactCellUtilTitle: "验证消息",
                                       contactCellUtilVC: LPSystemNotificationViewController.self,
                                       contactCellUtilBadge: systemCount],
                                      [contactCellUtilIcon: #imageLiteral(resourceName: "icon_team_advance_normal"),
                                       contactCellUtilTitle: "高级群",
                                       contactCellUtilVC: LPAdvancedTeamListViewController.self],
                                      [contactCellUtilIcon: #imageLiteral(resourceName: "icon_team_normal_normal"),
                                       contactCellUtilTitle: "讨论组",
                                       contactCellUtilVC: LPNormalTeamListViewController.self],
                                      [contactCellUtilIcon: #imageLiteral(resourceName: "icon_blacklist_normal"),
                                       contactCellUtilTitle: "黑名单",
                                       contactCellUtilVC: LPBlackListViewController.self],
                                      [contactCellUtilIcon: #imageLiteral(resourceName: "icon_computer_normal"),
                                       contactCellUtilTitle: "我的电脑",
                                       contactCellUtilSelectorName: #selector(enterMyComputer)]]
        
        navigationItem.title = "通讯录"
        setUpNavItem()
        
        /// 构造显示的数据模型
        
        var members: [LPGroupMemberProtocol] = []
        for item in utils {
            let utilItem = LPContactUtilMember()
            utilItem.showName          = item[contactCellUtilTitle] as? String
            utilItem.icon              = item[contactCellUtilIcon] as? UIImage
            utilItem.vc                = item[contactCellUtilVC] as? AnyClass
            utilItem.badge             = item[contactCellUtilBadge] as? String
            utilItem.userId            = item[contactCellUtilUid]  as? String
            utilItem.selector          = item[contactCellUtilSelectorName]  as? Selector
            members.append(utilItem)
        }
        contacts.addGroupAbove(withTitle: "", members: members)
    }
    
    fileprivate func setUpNavItem() {
        let teamBtn = UIButton(type: .custom)
        teamBtn.addTarget(self, action: #selector(onOpera), for: .touchUpInside)
        teamBtn.setImage(#imageLiteral(resourceName: "icon_tinfo_normal"), for: .normal)
        teamBtn.setImage(#imageLiteral(resourceName: "icon_tinfo_pressed"), for: .highlighted)
        teamBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: teamBtn)
    }
    
    @objc fileprivate func onOpera(_ sender: UIButton) {
        let sheetVC = UIAlertController(title: "选择操作", message: nil, preferredStyle: .actionSheet)
        sheetVC.addAction(UIAlertAction(title: "添加好友", style: .destructive, handler: { (_) in
            //                vc = [[NTESContactAddFriendViewController alloc] initWithNibName:nil bundle:nil];
            //            [wself.navigationController pushViewController:vc animated:YES];
            
            
        }))
        sheetVC.addAction(UIAlertAction(title: "创建高级群", style: .default, handler: { (_) in
            //[wself presentMemberSelector:^(NSArray *uids) {
            //                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
            //                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
            //                    option.name       = @"高级群";
            //                    option.type       = NIMTeamTypeAdvanced;
            //                    option.joinMode   = NIMTeamJoinModeNoAuth;
            //                    option.postscript = @"邀请你加入群组";
            //                    [SVProgressHUD show];
            //                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
            //                        [SVProgressHUD dismiss];
            //                        if (!error) {
            //                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
            //                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            //                            [wself.navigationController pushViewController:vc animated:YES];
            //                        }else{
            //                            [wself.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
            //                        }
            //                    }];
            //                }];
        }))
        sheetVC.addAction(UIAlertAction(title: "创建讨论组", style: .default, handler: { (_) in
            //                [wself presentMemberSelector:^(NSArray *uids) {
            //                    if (!uids.count) {
            //                        return; //讨论组必须除自己外必须要有一个群成员
            //                    }
            //                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
            //                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
            //                    option.name       = @"讨论组";
            //                    option.type       = NIMTeamTypeNormal;
            //                    [SVProgressHUD show];
            //                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
            //                        [SVProgressHUD dismiss];
            //                        if (!error) {
            //                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
            //                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            //                            [wself.navigationController pushViewController:vc animated:YES];
            //                        }else{
            //                            [wself.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
            //                        }
            //                    }];
            //                }];
        }))
        sheetVC.addAction(UIAlertAction(title: "搜索高级群", style: .default, handler: { (_) in
            //                vc = [[NTESSearchTeamViewController alloc] initWithNibName:nil bundle:nil];
            //            [wself.navigationController pushViewController:vc animated:YES];
        }))
        sheetVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheetVC, animated: true, completion: nil)
    }
    
    fileprivate func presentMemberSelector(block: ([String])) {
        //    NSMutableArray *users = [[NSMutableArray alloc] init];
        //    //使用内置的好友选择器
        //    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
        //    //获取自己id
        //    let currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
        //    [users addObject:currentUserId];
        //    //将自己的id过滤
        //    config.filterIds = users;
        //    //需要多选
        //    config.needMutiSelected = YES;
        //    //初始化联系人选择器
        //    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
        //    //回调处理
        //    vc.finshBlock = block;
        //    [vc show];
    }
    
    @objc fileprivate func enterMyComputer() {
        let uid = NIMSDK.shared().loginManager.currentAccount()
        let vc = LPSessionViewController(session: NIMSession(uid, type: .P2P))
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 
// MARK: - Delegate

extension LPContactViewController: NIMUserManagerDelegate, NIMSystemNotificationManagerDelegate, NIMLoginManagerDelegate, NIMEventSubscribeManagerDelegate, LPContactUtilCellDelegate, LPKContactCellDelegate {
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.groupCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.memberCount(ofGroup: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = contacts.member(ofIndex: indexPath)
        let itemProtocol = item as! LPContactItemProtocol
        
        let cellId = itemProtocol.reuseId
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            let cellClazz = itemProtocol.cellName as! UITableViewCell.Type
            cell = cellClazz.init(style: .default, reuseIdentifier: cellId)
        }
        
        if itemProtocol.showAccessoryView {
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.accessoryType = .none
        }
        
        if cell is LPContactUtilCell {
            (cell as! LPContactUtilCell).refresh(with: itemProtocol, delegate: self)
        } else if cell is LPContactCell {
            (cell as! LPContactCell).refresh(user: itemProtocol, delegate: self)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contacts.title(ofGroup: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contacts.sortedGroupTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index + 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let item = contacts.member(ofIndex: indexPath) {
            return item.memberId.characters.count > 0
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete { return }
        
        let alert = UIAlertController(title: "删除好友", message: "删除好友后，将同时解除双方的好友关系", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (_) in
            guard let item = self.contacts.member(ofIndex: indexPath), let itemPro = item as? LPContactItemProtocol else { return }
            guard let uid = itemPro.userId else { return }
            
            LPHUD.showHUD(at: nil, text: nil)
            NIMSDK.shared().userManager.deleteFriend(uid, completion: { [weak self] (error) in
                LPHUD.hide(false)
                if error == nil {
                    self?.contacts.removeGroupMember(item)
                } else {
                    LPHUD.showError(at: nil, text: "删除失败")
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = contacts.member(ofIndex: indexPath) as? LPContactItemProtocol else { return }
        
        if let selector = item.selector, let sel = selector {
            perform(sel)
        } else if let vc = item.vc {
            let clazz = vc as! UIViewController.Type
            let vc = clazz.init(nibName: nil, bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        } else if let uid = item.userId {
            avatarClicked(uid)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = contacts.member(ofIndex: indexPath) as? LPContactItemProtocol {
            return item.uiHeight
        }
        return 44.0
    }
    
    // MARK: - NIMSDK Delegate
    
    func onSystemNotificationCountChanged(_ unreadCount: Int) {
        refresh()
    }
    
    func onLogin(_ step: NIMLoginStep) {
        if step == .syncOK && isViewLoaded { // 没有加载view的话viewDidLoad里会走一遍prepareData
            refresh()
        }
    }
    
    func onUserInfoChanged(_ user: NIMUser) {
        refresh()
    }
    
    func onFriendChanged(_ user: NIMUser) {
        refresh()
    }
    
    func onBlackListChanged() {
        refresh()
    }
    
    func onMuteListChanged() {
        refresh()
    }
    
    private func refresh() {
        prepareData()
        tableView.reloadData()
    }
    
    //#pragma mark - 
    
    // MARK: - NIMEventSubscribeManagerDelegate
    
    func onRecvSubscribeEvents(_ events: [Any]) {
        guard let events = events as? [NIMSubscribeEvent] else { return }
        guard let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows else { return }
        
        var ids: [String] = []
        for event in events {
            if let id = event.from {
                ids.append(id)
            }
        }
        
        var indexPaths: [IndexPath] = []
        for indexPath in indexPathsForVisibleRows {
            if let item = contacts.member(ofIndex: indexPath) as? LPContactItemProtocol {
                if let friendId = item.userId, ids.contains(friendId) {
                    indexPaths.append(indexPath)
                }
            }
        }
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    // MARK: - LPContactUtilCellDelegate
    
    func utilImageClicked(_ content: String?) {
        LPHUD.showText(at: nil, text: "点我干嘛 我是<\(content ?? "")>", center: true)
    }
    
    // MARK: - LPKContactCellDelegate
    
    func avatarClicked(_ uid: String) {
        let vc = LPPersonalCardViewController(uid: uid)
        navigationController?.pushViewController(vc, animated: true)
    }
}
