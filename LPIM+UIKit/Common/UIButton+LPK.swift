//
//  UIButton+LPK.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

extension UIButton {
    
    func setAvatar(bySession session: NIMSession?) {
        guard let session = session else { return }
        
        var info: LPKInfo?
        if session.sessionType == .team {
            info = LPKKit.shared.info(byTeam: session.sessionId, option: nil)
        } else {
            let option = LPKInfoFetchOption()
            option.session = session
            info = LPKKit.shared.info(byUser: session.sessionId, option: option)
        }
        
        let urlString = info?.avatarUrlString ?? ""
        kf.setImage(with: URL(string: urlString), for: .normal, placeholder: info?.avatarImage)
    }
    
    func setAvatar(byMessage message: NIMMessage?) {
        guard let message = message else { return }
        let option = LPKInfoFetchOption()
        option.message = message
        
        let info = LPKKit.shared.info(byUser: message.from ?? "", option: option)
        
        let urlString = info?.avatarUrlString ?? ""
        kf.setImage(with: URL(string: urlString), for: .normal, placeholder: info?.avatarImage)
    }
    
}
