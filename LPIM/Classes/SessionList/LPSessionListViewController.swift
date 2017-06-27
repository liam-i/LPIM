//
//  LPSessionListViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/19.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

private let kSessionListTitle: String = "LPIM"

class LPSessionListViewController: LPKSessionListViewController {
    lazy var emptyTipLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "还没有会话，在通讯录中找个人聊聊吧"
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.text =  kSessionListTitle
        lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy fileprivate var header: LPListHeader = {
        let header = LPListHeader(frame: CGRect(x: 0, y: 0, width: self.view.lp_width, height: 0))
        header.autoresizingMask = .flexibleWidth
        return header
    }()
    lazy fileprivate var supportsForceTouch: Bool = false
    lazy fileprivate var previews: [Int: UIViewControllerPreviewing] = [:]
    
    deinit {
        NIMSDK.shared().subscribeManager.remove(self)
        
        log.warning("release memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoRemoveRemoteSession = LPBundleSetting.shared.autoRemoveRemoteSession()
        if #available(iOS 9.0, *) {
            supportsForceTouch = traitCollection.forceTouchCapability == UIForceTouchCapability.available
        } else {
            supportsForceTouch = false
        }
        
        NIMSDK.shared().subscribeManager.add(self)
        
        header.delegate = self
        view.addSubview(header)
        
        emptyTipLabel.isHidden = recentSessions.count != 0
        view.addSubview(emptyTipLabel)
        
        let uid = NIMSDK.shared().loginManager.currentAccount()
        navigationItem.titleView = titleView(uid)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.lp_centerX = (navigationItem.titleView?.lp_width ?? view.lp_width) / 2.0
        tableView.lp_top = header.lp_height
        tableView.lp_height = view.lp_height - tableView.lp_top
        header.lp_bottom = tableView.lp_top + tableView.contentInset.top
        emptyTipLabel.lp_centerX = view.lp_width / 2.0
        emptyTipLabel.lp_centerY = tableView.lp_height / 2.0
    }
    
    override func refresh(_ reload: Bool) {
        super.refresh(reload)
        emptyTipLabel.isHidden = recentSessions.count != 0
    }
    
    override func selectedRecent(at indexPath: IndexPath, recent: NIMRecentSession) {
        //    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
        //    [self.navigationController pushViewController:vc animated:YES];
    }
    
    override func selectedAvatar(at indexPath: IndexPath, recent: NIMRecentSession) {
        //    if (recent.session.sessionType == NIMSessionTypeP2P) {
        //       NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:recent.session.sessionId];
        //      [self.navigationController pushViewController:vc animated:YES];
        //    }
    }
    
    override func deleteRecent(at indexPath: IndexPath, recent: NIMRecentSession) {
        super.deleteRecent(at: indexPath, recent: recent)
    }
    
    override func nameForRecentSession(_ recent: NIMRecentSession) -> String? {
        if let session = recent.session, session.sessionId == NIMSDK.shared().loginManager.currentAccount() {
            return "我的电脑"
        }
        return super.nameForRecentSession(recent)
    }
    
    override func contentForRecentSession(_ recent: NIMRecentSession) -> NSAttributedString {
        var content: NSAttributedString
        if let lastMsg = recent.lastMessage, lastMsg.messageType == .custom {
            
            var text = "[未知消息]"
            if let object = lastMsg.messageObject as? NIMCustomObject {
                if object.attachment is LPSnapchatAttachment {
                    text = "[阅后即焚]"
                } else if object.attachment is LPJanKenPonAttachment {
                    text = "[猜拳]"
                } else if object.attachment is LPChartletAttachment {
                    text = "[贴图]"
                } else if object.attachment is LPWhiteboardAttachment {
                    text = "[白板]"
                } else {
                    text = "[未知消息]"
                }
            }
            
            if recent.session?.sessionType == .P2P, let from = lastMsg.from {
                if let nickName = LPSessionUtil.showNick(from, session: lastMsg.session), nickName.characters.count > 0 {
                    text = nickName.appendingFormat(" : %@", text)
                } else {
                    text = ""
                }
            }
            content = NSAttributedString(string: text)
        } else {
            content = super.contentForRecentSession(recent)
        }
        
        let attContent = NSMutableAttributedString(attributedString: content)
        checkNeedAtTip(recent, content: attContent)
        checkOnlineState(recent, content: attContent)
        return attContent
    }
}

extension LPSessionListViewController: NIMEventSubscribeManagerDelegate, UIViewControllerPreviewingDelegate, LPListHeaderDelegate {
    
    // MARK: - NIMLoginManagerDelegate
    
    override func onLogin(_ step: NIMLoginStep) {
        super.onLogin(step)
        
        switch step {
        case .linkFailed:
            titleLabel.text = kSessionListTitle + "(未连接)"
        case .linking:
            titleLabel.text = kSessionListTitle + "(连接中)"
        case .linkOK, .syncOK:
            titleLabel.text = kSessionListTitle
        case .syncing:
            titleLabel.text = kSessionListTitle + "(同步数据)"
        default:
            break
        }
        titleLabel.sizeToFit()
        titleLabel.lp_centerX = (navigationItem.titleView?.lp_width ?? view.lp_width) / 2.0
        header.refresh(with: .netStauts, value: step)
        view.setNeedsLayout()
    }
    
    override func onMultiLoginClientsChanged() {
        super.onMultiLoginClientsChanged()
        header.refresh(with: .loginClients, value: [NIMSDK.shared().loginManager.currentLoginClients()])
        view.setNeedsLayout()
    }
    
    // MARK: - NIMEventSubscribeManagerDelegate
    
    func onRecvSubscribeEvents(_ events: [Any]) {
        var ids: [String] = []
        for event in events {
            if let event = event as? NIMSubscribeEvent, let id = event.from {
                ids.append(id)
            }
        }
        
        var indexPaths: [IndexPath] = []
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows{
            for indexPath in visibleIndexPaths where recentSessions.count > indexPath.row {
                let recent = recentSessions[indexPath.row]
                if let session = recent.session, session.sessionType == .P2P {
                    let from = session.sessionId
                    if ids.contains(from) {
                        indexPaths.append(indexPath)
                    }
                }
            }
        }
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 9.0, *) {
            if supportsForceTouch {
                let preview = registerForPreviewing(with: self, sourceView: cell)
                previews[indexPath.row] = preview
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 9.0, *) {
            if supportsForceTouch, let preview = previews[indexPath.row] {
                unregisterForPreviewing(withContext: preview)
                previews.removeValue(forKey: indexPath.row)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            if previewingContext.sourceView is UITableViewCell, let touchCell = previewingContext.sourceView as? UITableViewCell {
                guard let indexPath = tableView.indexPath(for: touchCell) else { return nil }
               
                let recent = recentSessions[indexPath.row]
                //        NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];
                //        return nav;
            }
        } else {
            // Fallback on earlier versions
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if #available(iOS 9.0, *) {
            if previewingContext.sourceView is UITableViewCell, let touchCell = previewingContext.sourceView as? UITableViewCell {
                guard let indexPath = tableView.indexPath(for: touchCell) else { return }
                
                let recent = recentSessions[indexPath.row]
                //        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
                //        [self.navigationController showViewController:vc sender:nil];
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - LPListHeaderDelegate
    
    func didSelectRowType(_ type: LPListHeaderType) {
        /// 多人登录
        switch type {
        case .loginClients:
            //            NTESClientsTableViewController *vc = [[NTESClientsTableViewController alloc] initWithNibName:nil bundle:nil];
            //            [self.navigationController pushViewController:vc animated:YES];
            break
        default:
            break
        }
    }
}

// MARK: - 
// MARK: - Private

extension LPSessionListViewController {
    
    fileprivate func titleView(_ uid: String) -> UIView {
        let subLabel = UILabel(frame: .zero)
        subLabel.textColor = UIColor.gray
        subLabel.font = UIFont.systemFont(ofSize: 12.0)
        subLabel.text = uid
        subLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        subLabel.sizeToFit()
        
        let titleView = UIView()
        titleView.lp_width = subLabel.lp_width
        titleView.lp_height = titleLabel.lp_height + subLabel.lp_height
        
        subLabel.lp_bottom = titleView.lp_height
        titleView.addSubview(titleLabel)
        titleView.addSubview(subLabel)
        return titleView
    }
    
    fileprivate func checkNeedAtTip(_ recent: NIMRecentSession, content: NSMutableAttributedString) {
        if LPSessionUtil.recentSessionIsAtMark(recent) {
            let atTip = NSAttributedString(string: "[有人@你] ", attributes: [NSForegroundColorAttributeName : UIColor.red])
            content.insert(atTip, at: 0)
        }
    }
    
    fileprivate func checkOnlineState(_ recent: NIMRecentSession, content: NSMutableAttributedString) {
        if let session = recent.session, session.sessionType == .P2P {
            let state = LPSessionUtil.onlineState(session.sessionId, detail: false)
            if state.characters.count > 0 {
                let format = "[\(state)] "
                let atTip = NSAttributedString(string: format, attributes: nil)
                content.insert(atTip, at: 0)
            }
        }
    }
}
