//
//  LPContactDataMember.swift
//  LPIM
//
//  Created by lipeng on 2017/6/27.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPContactDataMember: NSObject, LPGroupMemberProtocol, LPContactItemProtocol {
    
    var info: LPKInfo
    
    init(info: LPKInfo) {
        self.info = info
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object is LPContactDataMember {
            let obj = object as! LPContactDataMember
            if let infoId = info.infoId, let objId = obj.info.infoId {
                return infoId == objId
            }
        }
        return false
    }
    
    // MARK: - LPGroupMemberProtocol
    
    var groupTitle: String {
        if let showName = info.showName, let title = LPSpellingCenter.shared.firstLetter(showName)?.capitalized, title.characters.count > 0 {
            let character = title.characters[title.startIndex]
            if character >= "A" && character <= "Z" {
                return title
            }
        }
        return "#"
    }
    
    var memberId: String {
        return info.infoId ?? ""
    }
    
    var sortKey: String {
        if let showName = info.showName, let key = LPSpellingCenter.shared.spelling(for: showName)?.shortSpelling {
            return key
        }
        return ""
    }
    
    // MARK: - LPContactItemProtocol
    
    /// userId和Vcname必有一个有值，根据有值的状态push进不同的页面
    var vc: AnyClass?
    
    /// userId和Vcname必有一个有值，根据有值的状态push进不同的页面
    var userId: String? {
        get { return info.infoId }
        set { }
    }
    
    /// 返回行高
    var uiHeight: CGFloat { return 50.0 }
    
    /// 重用id
    var reuseId: String {
        return "LPContactCell"
    }
    
    /// 需要构造的cell类名
    var cellName: AnyClass {
        return LPContactCell.self
    }
    
    /// badge
    var badge: String?
    
    /// 显示名
    var showName: String? {
        get { return info.showName }
        set { }
    }
    
    /// 占位图
    var icon: UIImage? {
        get { return info.avatarImage }
        set { }
    }
    
    /// 头像url
    var avatarUrl: String? {
        get { return info.avatarUrlString }
        set { }
    }
    
    /// accessoryView
    var showAccessoryView: Bool {
        return false
    }    
}
