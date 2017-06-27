//
//  LPKDataProvider.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation

@objc protocol LPKDataProviderDelegate: NSObjectProtocol {
    
    /// 上层提供用户信息的接口
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - option: 获取选项
    /// - Returns: 用户信息
    @objc optional func info(byUser userId: String, option: LPKInfoFetchOption?) -> LPKInfo?
    
    /// 上层提供群组信息的接口
    ///
    /// - Parameters:
    ///   - teamId: 群组ID
    ///   - option: 获取选项
    /// - Returns: 群组信息
    @objc optional func info(byTeam teamId: String, option: LPKInfoFetchOption?) -> LPKInfo?
}
