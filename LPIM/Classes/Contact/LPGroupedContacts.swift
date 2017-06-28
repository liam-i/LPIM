//
//  LPGroupedContacts.swift
//  LPIM
//
//  Created by lipeng on 2017/6/27.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

class LPGroupedContacts: LPGroupedDataCollection {
    
    override init() {
        super.init()
        
        guard let myFriends = NIMSDK.shared().userManager.myFriends() else { return }
        
        print("myFriends.count=\(myFriends.count)")
        var contacts: [LPContactDataMember] = []
        for user in myFriends {
            if let uid = user.userId, let info = LPKKit.shared.info(byUser: uid, option: nil) {
                let contact = LPContactDataMember(info: info)
                contacts.append(contact)
            }
        }
        
        setupMembers(contacts)
    }
}
