//
//  LPKCellConfig.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

@objc protocol LPKCellLayoutConfigDelegate {
    
    /// - Returns: 返回message的内容大小
    @objc optional func contentSize(_ model: LPKMessageModel, cellWidth width: CGFloat) -> CGSize
    
    /// 需要构造的cellContent类名
    @objc optional func cellContent(_ model: LPKMessageModel) -> String
    
    /// 左对齐的气泡，cell气泡距离整个cell的内间距
    @objc optional func cellInsets(_ model: LPKMessageModel) -> UIEdgeInsets
    
    /// 左对齐的气泡，cell内容距离气泡的内间距
    @objc optional func contentViewInsets(_ model: LPKMessageModel) -> UIEdgeInsets
    
    /// 是否显示头像
    @objc optional func shouldShowAvatar(_ model: LPKMessageModel) -> Bool
    
    /// 左对齐的气泡，头像到左边的距离
    @objc optional func avatarMargin(_ model: LPKMessageModel) -> CGFloat
    
    /// 是否显示姓名
    @objc optional func shouldShowNickName(_ model: LPKMessageModel) -> Bool
    
    /// 左对齐的气泡，昵称到左边的距离
    @objc optional func nickNameMargin(_ model: LPKMessageModel) -> CGFloat
    
    /// 消息显示在左边
    @objc optional func shouldShowLeft(_ model: LPKMessageModel) -> Bool
    
    /// 需要添加到Cell上的自定义视图
    @objc optional func customViews(_ model: LPKMessageModel) -> [UIView]
}
