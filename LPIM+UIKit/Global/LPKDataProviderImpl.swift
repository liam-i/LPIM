//
//  LPKDataProviderImpl.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import NIMSDK

class LPKDataProviderImpl: NSObject {
    fileprivate lazy var defaultUserAvatar: UIImage? = UIImage.lp_image(named: "avatar_user")
    fileprivate lazy var defaultTeamAvatar: UIImage? = UIImage.lp_image(named: "avatar_team")
    fileprivate lazy var request: LPKDataRequest = LPKDataRequest()
    
    override init() {
        super.init()
        NIMSDK.shared().userManager.add(self)
        NIMSDK.shared().teamManager.add(self)
        NIMSDK.shared().loginManager.add(self)
    }
    
    deinit {
        log.warning("release memory.")
        NIMSDK.shared().userManager.remove(self)
        NIMSDK.shared().teamManager.remove(self)
        NIMSDK.shared().loginManager.remove(self)
    }
    
    // MARK: - nickname
    
    fileprivate func nickname(user: NIMUser, memberInfo: NIMTeamMember?, option: LPKInfoFetchOption?) -> String? {
        if !(option?.forbidaAlias ?? false) {
            if let alias = user.alias, alias.characters.count > 0 {
                return alias
            }
        }
        if let nick = memberInfo?.nickname, nick.characters.count > 0 {
            return nick
        }
        if let nick = user.userInfo?.nickName, nick.characters.count > 0 {
            return nick
        }
        return nil
    }
}

extension LPKDataProviderImpl: LPKDataProviderDelegate {
    
    func info(byTeam teamId: String, option: LPKInfoFetchOption?) -> LPKInfo? {
        guard let team = NIMSDK.shared().teamManager.team(byId: teamId) else { return nil }
        
        let info = LPKInfo()
        info.showName = team.teamName
        info.infoId      = teamId
        info.avatarImage = defaultTeamAvatar
        info.avatarUrlString = team.thumbAvatarUrl
        return info
    }
    
    func info(byUser userId: String, option: LPKInfoFetchOption?) -> LPKInfo {
        if let message = option?.message {
            assert(userId == message.from, "user id should be same with message from")
            return info(byUser: userId, message: message, option: option)
        }
        return info(byUser: userId, session: option?.session, option: option)
    }
    
    func info(byUser userId: String, session: NIMSession?, option: LPKInfoFetchOption?) -> LPKInfo {
        var needFetchInfo = false
        
        let info = LPKInfo()
        info.infoId = userId
        info.showName = userId //默认值
        info.avatarImage = defaultUserAvatar
        
        if let session = session {
            let sessionType = session.sessionType
            switch sessionType {
            case .P2P, .team:
                if let user = NIMSDK.shared().userManager.userInfo(userId) {
                    let uinfo = user.userInfo
                    
                    var member: NIMTeamMember? = nil
                    if sessionType == .team {
                        member = NIMSDK.shared().teamManager.teamMember(userId, inTeam: session.sessionId)
                    }
                    
                    info.showName = nickname(user: user, memberInfo: member, option: option)
                    info.avatarUrlString = uinfo?.thumbAvatarUrl
                    info.avatarImage = defaultUserAvatar
                    
                    if uinfo == nil {
                        needFetchInfo = true
                    }
                }
            case .chatroom:
                assert(false, "invalid type") // 聊天室的Info不会通过这个回调请求
            }
        }
        
        if needFetchInfo {
            request.requestUserIds([userId])
        }
        return info
    }
    
    func info(byUser userId: String, message: NIMMessage, option: LPKInfoFetchOption?) -> LPKInfo {
        if let session = message.session, session.sessionType == .chatroom {
            let info = LPKInfo()
            info.infoId = userId
            if userId == NIMSDK.shared().loginManager.currentAccount() {
                if let user = NIMSDK.shared().userManager.userInfo(userId), let uinfo = user.userInfo {
                    info.showName = uinfo.nickName
                    info.avatarUrlString = uinfo.thumbAvatarUrl
                }
            } else if message.messageExt is NIMMessageChatroomExtension, let ext = message.messageExt as? NIMMessageChatroomExtension {
                info.showName = ext.roomNickname
                info.avatarUrlString = ext.roomAvatar
            }
            info.avatarImage = defaultUserAvatar
            return info
        }
        return info(byUser: userId, session: message.session, option: option)
    }
}

extension LPKDataProviderImpl: NIMUserManagerDelegate, NIMTeamManagerDelegate, NIMLoginManagerDelegate {
    
    //将个人信息和群组信息变化通知给 LPKKit 。
    //如果您的应用不托管个人信息给云信，则需要您自行在上层监听个人信息变动，并将变动通知给 LPKKit。

    // MARK: - NIMUserManagerDelegate
    
    func onFriendChanged(_ user: NIMUser) {
        if let uid = user.userId {
            LPKKit.shared.notfiyUserInfoChanged([uid])
        }
    }
    
    func onUserInfoChanged(_ user: NIMUser) {
        if let uid = user.userId {
            LPKKit.shared.notfiyUserInfoChanged([uid])
        }
    }
    
    // MARK: - NIMTeamManagerDelegate
    
    func onTeamAdded(_ team: NIMTeam) {
        if let tid = team.teamId {
            LPKKit.shared.notifyTeamInfoChanged([tid])
        }
    }
    
    func onTeamUpdated(_ team: NIMTeam) {
        if let tid = team.teamId {
            LPKKit.shared.notifyTeamInfoChanged([tid])
        }
    }
    
    func onTeamRemoved(_ team: NIMTeam) {
        if let tid = team.teamId {
            LPKKit.shared.notifyTeamInfoChanged([tid])
        }
    }
    
    func onTeamMemberChanged(_ team: NIMTeam) {
        if let tid = team.teamId {
            LPKKit.shared.notifyTeamMemebersChanged([tid])
        }
    }
    
    // MARK: - NIMLoginManagerDelegate
    
    func onLogin(_ step: NIMLoginStep) {
        if step == .syncOK {
            LPKKit.shared.notifyTeamInfoChanged(nil)
            LPKKit.shared.notifyTeamMemebersChanged(nil)
        }
    }
}

fileprivate class LPKDataRequest: NSObject {
    var maxMergeCount: Int = 20 // 最大合并数
    
    private var isRequesting: Bool = false
    private var requestUserIdArray: [String] = [] // 待请求池
    
    func requestUserIds(_ userIds: [String]) {
        for uid in userIds {
            if !requestUserIdArray.contains(uid) {
                requestUserIdArray.append(uid)
            }
        }
        request()
    }
    
    private func request() {
        if isRequesting || requestUserIdArray.count == 0 {
            return
        }
        
        let MaxBatchReuqestCount = 10
        isRequesting = true
        let userIds: [String]
        if requestUserIdArray.count > MaxBatchReuqestCount {
            userIds = Array(requestUserIdArray[0..<MaxBatchReuqestCount])
        } else {
            userIds = requestUserIdArray
        }
        
        NIMSDK.shared().userManager.fetchUserInfos(userIds) { [weak self] (users, error) in
            self?.afterReuquest(userIds)
            if error == nil {
                LPKKit.shared.notfiyUserInfoChanged(userIds)
            }
        }
    }
    
    private func afterReuquest(_ userIds: [String]) {
        isRequesting = false
        for uid in userIds {
            if let index = requestUserIdArray.index(of: uid) {
                requestUserIdArray.remove(at: index)
            }
        }
        request()
    }
}
