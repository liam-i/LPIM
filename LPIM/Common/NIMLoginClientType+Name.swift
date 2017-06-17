//
//  NIMLoginClientType+Name.swift
//  LPIM
//
//  Created by lipeng on 2017/6/18.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import NIMSDK

extension NIMLoginClientType {
    
    var clientName: String {
        switch self {
        case .typeAOS , .typeiOS , .typeWP:
            return "移动"
        case .typePC:
            return "电脑"
        case .typeWeb:
            return "网页"
        default:
            return ""
        }
    }
    
}
