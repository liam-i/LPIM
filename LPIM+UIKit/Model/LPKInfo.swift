//
//  LPKInfo.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPKInfo: NSObject {
    /// id，如果是用户信息，为用户id；如果是群信息，为群id
    var infoId: String?
    /// 显示名
    var showName: String?
    
    /// 如果avatarUrlString为nil，则显示头像图片
    /// 如果avatarUrlString不为nil,则将头像图片当做占位图，当下载完成后显示头像url指定的图片。
    
    /// 头像url
    var avatarUrlString: String?
    /// 头像图片
    var avatarImage: UIImage?
}
