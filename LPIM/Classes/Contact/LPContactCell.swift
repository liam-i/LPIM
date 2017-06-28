//
//  LPContactCell.swift
//  LPIM
//
//  Created by lipeng on 2017/6/28.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPContactCell: LPKContactCell {
    
    override func refresh(user item: LPContactItemProtocol, delegate: LPKContactCellDelegate?) {
        super.refresh(user: item, delegate: delegate)
        
        if let memberId = memberId {
            let state = LPSessionUtil.onlineState(memberId, detail: false)
            var title = ""
            if state.characters.count > 0 {
                title = "[\(state)] \(item.showName ?? "")"
            } else {
                if let showName = item.showName {
                    title = showName
                }
            }
            textLabel?.text = title
        }
        
    }    
}
