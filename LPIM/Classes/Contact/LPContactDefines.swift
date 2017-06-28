//
//  LPContactDefines.swift
//  LPIM
//
//  Created by lipeng on 2017/6/28.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

@objc protocol LPGroupMemberProtocol {
    var groupTitle: String { get }
    var memberId: String { get }
    var sortKey: String { get }
}

@objc protocol LPContactItemProtocol {
    
    /// userId和vc必有一个有值，根据有值的状态push进不同的页面
    var vc: AnyClass? { get set }
    
    /// userId和Vcname必有一个有值，根据有值的状态push进不同的页面
    //func userId() -> String?
    var userId: String? { get set }
    
    /// 返回行高
    var uiHeight: CGFloat { get }
    
    /// 重用id
    var reuseId: String { get }
    
    /// 需要构造的cell类名
    var cellName: AnyClass { get }
    
    /// badge
    var badge: String? { get set }
    
    /// 显示名
    var showName: String? { get set }
    
    /// 占位图
    var icon: UIImage? { get set }
    
    /// 头像url
    var avatarUrl: String? { get set }
    
    /// accessoryView
    var showAccessoryView: Bool { get }
    
    @objc optional var selector: Selector? { get set }
}

protocol LPContactCellDelegate {
    func refresh(withContact item: LPContactItemProtocol)
    func add(delegate: Any)
}
