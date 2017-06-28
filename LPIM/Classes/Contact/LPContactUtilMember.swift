//
//  LPContactUtilItem.swift
//  LPIM
//
//  Created by lipeng on 2017/6/28.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPContactUtilMember: NSObject, LPContactItemProtocol, LPGroupMemberProtocol {
    
    // MARK: - LPContactItemProtocol
    
    /// 显示名
    var showName: String?
    
    /// badge
    var badge: String?
    
    /// 占位图
    var icon: UIImage?

    /// userId和Vcname必有一个有值，根据有值的状态push进不同的页面
    var vc: AnyClass?
    
    /// userId和Vcname必有一个有值，根据有值的状态push进不同的页面
    var userId: String?
    
    var selector: Selector?

    /// 返回行高
    var uiHeight: CGFloat {
        return 57.0 // util类Cell行高
    }
    
    /// 重用id
    var reuseId: String {
        return "LPContactUtilCell"
    }
    
    /// 需要构造的cell类名
    var cellName: AnyClass {
        return LPContactUtilCell.self
    }

    /// 头像url
    var avatarUrl: String?
    
    /// accessoryView
    var showAccessoryView: Bool {
        return true
    }

    // MARK: - LPGroupMemberProtocol
    
    var groupTitle: String {
        return ""
    }
    
    var memberId: String {
        return userId ?? ""
    }
    
    var sortKey: String {
        return ""
    }
}
