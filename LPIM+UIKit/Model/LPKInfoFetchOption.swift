//
//  LPKInfoFetchOption.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import NIMSDK

class LPKInfoFetchOption: NSObject {
    /// 所属会话
    var session: NIMSession?
    
    /// 所属消息
    var message: NIMMessage?
    
    /// 屏蔽备注名
    var forbidaAlias: Bool = false
}
