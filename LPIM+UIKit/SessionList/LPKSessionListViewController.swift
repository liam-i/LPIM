//
//  LPKSessionListViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/19.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK
import Kingfisher

private let kCellID = "LPKSessionListCell"
class LPKSessionListViewController: UIViewController {
    /// 会话列表tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate         = self
        tableView.dataSource       = self
        tableView.tableFooterView  = UIView()
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return tableView
    }()
    
    /// 最近会话集合
    lazy var recentSessions: [NIMRecentSession] = []
    
    /// 删除会话时是不是也同时删除服务器会话 (防止漫游)
    lazy var autoRemoveRemoteSession = true
    
    deinit {
        NIMSDK.shared().conversationManager.remove(self)
        NIMSDK.shared().loginManager.remove(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
        if let recents = NIMSDK.shared().conversationManager.allRecentSessions() {
            recentSessions = recents
        }
        
        NIMSDK.shared().conversationManager.add(self)
        NIMSDK.shared().loginManager.add(self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(teamInfoHasUpdatedNotification),
                                               name: LPKTeamInfoHasUpdatedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(teamMembersHasUpdatedNotification),
                                               name: LPKTeamMembersHasUpdatedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userInfoHasUpdatedNotification),
                                               name: LPKUserInfoHasUpdatedNotification,
                                               object: nil)
    }
    
    /// 选中某一条最近会话时触发的事件回调
    /// discussion: 默认将进入会话界面
    ///
    /// - Parameters:
    ///   - recent: 最近会话
    ///   - indexPath: 最近会话cell所在的位置
    func selectedRecent(at indexPath: IndexPath, recent: NIMRecentSession) {
        //    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:recentSession.session];
        //    [self.navigationController pushViewController:vc animated:YES];
    }
    
    /// 选中某一条最近会话的头像控件，触发的事件回调
    /// discussion: 默认将进入会话界面
    ///
    /// - Parameters:
    ///   - recent: 最近会话
    ///   - at: 最近会话cell所在的位置
    func selectedAvatar(at indexPath: IndexPath, recent: NIMRecentSession) {
        
    }
    
    /// 删除某一条最近会话时触发的事件回调
    /// discussion: 默认将删除会话，并检查是否需要删除服务器的会话（防止漫游）
    ///
    /// - Parameters:
    ///   - indexPath: 最近会话cell所在的位置
    ///   - recent: 最近会话
    func deleteRecent(at indexPath: IndexPath, recent: NIMRecentSession) {
        let manager = NIMSDK.shared().conversationManager
        manager.delete(recent)
    }
    
    /// cell显示的会话名
    /// discussion: 默认实现为：点对点会话，显示聊天对象的昵称(没有昵称则显示账号)；群聊会话，显示群名称。
    ///
    /// - Parameter recent: 最近会话
    /// - Returns: 会话名
    func nameForRecentSession(_ recent: NIMRecentSession) -> String? {
        guard let session = recent.session else { return "" }
        if session.sessionType == .P2P {
            return LPKUtil.showNick(uid: session.sessionId, in: recent.session)
        } else {
            let team = NIMSDK.shared().teamManager.team(byId: session.sessionId)
            return team?.teamName
        }
    }
    
    /// cell显示的最近会话具体内容
    /// discussion: 默认实现为：显示最近一条消息的内容，文本消息则显示文本信息，其他类型消息详见本类中 func messageContent(_:NIMMessage) -> String 方法的实现。
    ///
    /// - Parameter recent: 最近会话
    /// - Returns: 具体内容名
    func contentForRecentSession(_ recent: NIMRecentSession) -> NSAttributedString {
        if let lastmessage = recent.lastMessage {
            let content = messageContent(lastmessage)
            return NSAttributedString(string: content)
        }
        return NSAttributedString(string: "")
    }
    
    /// cell显示的最近会话时间戳
    /// DISCUSSION: 默认实现为：最后一条消息的时间戳，具体时间戳消息格式详见LPKUtil中，class func showTime(:TimeInterval,:Bool) -> String 方法的实现。
    ///
    /// - Parameter recent: 最近会话
    /// - Returns: 时间戳格式化后的字符串
    func timestampDescription(for recent: NIMRecentSession) -> String {
        if let lastMessage = recent.lastMessage {
            return LPKUtil.showTime(msglastTime: lastMessage.timestamp, showDetail: false)
        }
        return ""
    }
    
    /// 重新加载所有数据，调用时必须先调用父类方法
    ///
    /// - Parameter reload: 是否刷新列表
    func refresh(_ reload: Bool) {
        if recentSessions.count > 0 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
        if reload {
            tableView.reloadData()
        }
    }
}

// MARK: - Private / Misc

extension LPKSessionListViewController {
    
    func findInsertPlace(_ recentSession: NIMRecentSession) -> Int {
        for (idx, item) in recentSessions.enumerated() {
            if let lastmessage = recentSession.lastMessage, let itemLastmessage = item.lastMessage {
                if itemLastmessage.timestamp <= lastmessage.timestamp {
                    return idx
                }
            }
        }
        return recentSessions.count
    }
    
    func sort() {
        recentSessions.sort { (item1, item2) -> Bool in
            if let lastmsg1 = item1.lastMessage, let lastmsg2 = item2.lastMessage {
                return lastmsg1.timestamp < lastmsg2.timestamp
            }
            return false
        }
    }
    
    func messageContent(_ lastMessage: NIMMessage) -> String {
        var text: String
        switch lastMessage.messageType {
        case .text:     text = lastMessage.text ?? ""
        case .audio:    text = "[语音]"
        case .image:    text = "[图片]"
        case .video:    text = "[视频]"
        case .location: text = "[位置]"
        case .notification:
            return notificationMessageContent(lastMessage)
        case .file:     text = "[文件]"
        case .tip:      text = lastMessage.text ?? ""
        default:        text = "[未知消息]"
        }
        
        if lastMessage.messageType == .tip {
            return text
        }
        if let session = lastMessage.session, session.sessionType == .P2P {
            return text
        }
        
        if let nickName = LPKUtil.showNick(uid: lastMessage.from, in: lastMessage.session), nickName.characters.count > 0 {
            return "\(nickName) : \(text)"
        }
        return ""
    }
    
    func avatarClicked(_ sender: UIButton) {
        var view = sender.superview
        while !(view is UITableViewCell) {
            view = view?.superview
        }
        
        if let cell = view as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if recentSessions.count > indexPath.row {
                let recent = recentSessions[indexPath.row]
                selectedAvatar(at: indexPath, recent: recent)
            }
        }
    }
}

// MARK: - 
// MARK: - Delegate / Notification

extension LPKSessionListViewController: UITableViewDataSource, UITableViewDelegate, NIMLoginManagerDelegate, NIMConversationManagerDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func lp_cell(with tableView: UITableView) -> LPKSessionListCell {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: kCellID) {
                return cell as! LPKSessionListCell
            }
            let cell = LPKSessionListCell(style: .default, reuseIdentifier: kCellID)
            cell.avatarButton.addTarget(self, action: #selector(avatarClicked), for: .touchUpInside)
            return cell
        }
        
        let cell = lp_cell(with: tableView)
        
        let recent = recentSessions[indexPath.row]
        cell.nameLabel.text = nameForRecentSession(recent)
        cell.avatarButton.setAvatar(bySession: recent.session)
        cell.nameLabel.sizeToFit()
        
        cell.messageLabel.attributedText = contentForRecentSession(recent)
        cell.messageLabel.sizeToFit()
        
        cell.timeLabel.text = timestampDescription(for: recent)
        cell.timeLabel.sizeToFit()
        
        cell.refresh(with: recent)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recentSession = recentSessions[indexPath.row]
        selectedRecent(at: indexPath, recent: recentSession)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recentSession = recentSessions[indexPath.row]
            deleteRecent(at: indexPath, recent: recentSession)
        }
    }
    
    // MARK: - NIMConversationManagerDelegate
    
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        recentSessions.append(recentSession)
        sort()
        refresh(true)
    }
    
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        for (idx, recent) in recentSessions.enumerated() {
            if recentSession.session?.sessionId == recent.session?.sessionId {
                recentSessions.remove(at: idx)
                break
            }
        }
        
        let insert = findInsertPlace(recentSession)
        recentSessions.insert(recentSession, at: insert)
        refresh(true)
    }
    
    func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        //清理本地数据
        if let index = recentSessions.index(of: recentSession) {
            recentSessions.remove(at: index)
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
            if autoRemoveRemoteSession, let session = recentSession.session {
                NIMSDK.shared().conversationManager.deleteRemoteSessions([session], completion: nil)
            }
        }
        refresh(false)
    }
    
    func messagesDeleted(in session: NIMSession) {
        allMessagesDeleted()
    }
    
    func allMessagesDeleted() {
        if let recents = NIMSDK.shared().conversationManager.allRecentSessions() {
            recentSessions = recents
        } else {
            recentSessions.removeAll()
        }
        refresh(true)
    }
    
    // MARK: - NIMLoginManagerDelegate
    
    func onLogin(_ step: NIMLoginStep) {
        if step == .syncOK {
            refresh(true)
        }
    }
    
    func onMultiLoginClientsChanged() {
        
    }
    
    func notificationMessageContent(_ lastMessage: NIMMessage) -> String {
        if let object = lastMessage.messageObject as? NIMNotificationObject {
            if object.notificationType == .netCall, let content = object.content as? NIMNetCallNotificationContent {
                if content.callType == .audio {
                    return "[网络通话]"
                }
                return "[视频聊天]"
            }
            if object.notificationType == .team, let sessionId = lastMessage.session?.sessionId {
                if let team = NIMSDK.shared().teamManager.team(byId: sessionId), team.type == .normal {
                    return "[讨论组信息更新]"
                } else {
                    return "[群信息更新]"
                }
            }
        }
        return "[未知消息]"
    }
    
    // MARK: - Notification
    
    func userInfoHasUpdatedNotification(_ notification: Notification) {
        refresh(true)
    }
    
    func teamInfoHasUpdatedNotification(_ notification: Notification) {
        refresh(true)
    }
    
    func teamMembersHasUpdatedNotification(_ notification: Notification) {
        refresh(true)
    }
}
