//
//  LPConfig.swift
//  LPIM
//
//  Created by lipeng on 2017/6/17.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

struct LPConfig {
    static let shared : LPConfig = { return  LPConfig() }()
    
    var appKey = "45c6af3c98409b18a84451215d0bdd6e"
    
    /// 此处 apiURL 为网易云信Demo 应用服务器地址，更换appkey后，请更新为应用自己的服务器接口地址，并提供相关接口服
    var apiURL: String {
        get {
            assert(NIMSDK.shared().isUsingDemoAppKey(), "只有网易云信Demo appKey 才能够使用这个API接口")
            return "https://app.netease.im/api"
        }
    }
    
    // TODO: - apns证书还没配置
    var apnsCername = "ENTERPRISE"
    var pkCername = "DEMO_PUSH_KIT"
    
}


