//
//  String+Extension.swift
//  LPIM
//
//  Created by lipeng on 2017/6/18.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

extension String {
    
    func md5() -> String {
        let cs = Array(utf8CString)
        var r = [UInt8](repeating: 0x0, count: 16)
        CC_MD5(cs, CC_LONG(strlen(cs)), &r)
        return String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      r[0], r[1], r[2],  r[3],  r[4],  r[5],  r[6],  r[7],
                      r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15])
    }
    
    func tokenByPassword() -> String {
        //demo直接使用username作为account，md5(password)作为token
        //接入应用开发需要根据自己的实际情况来获取 account和token
        return NIMSDK.shared().isUsingDemoAppKey() ? md5() : self
    }
}
