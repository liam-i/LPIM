//
//  LPRegisterTask.swift
//  LPIM
//
//  Created by lipeng on 2017/6/17.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK
import SwiftyJSON

typealias LPRegisterHandler = (_ errorMsg: String?) -> Void

struct LPRegisterData {
    var account: String
    var token: String
    var nickname: String
}

class LPRegisterTask: NSObject, LPHTTPSessionTask {
    var data: LPRegisterData?
    var handler: LPRegisterHandler?
        
    // MARK: -
    // MARK: - LPHTTPSessionTask
    
    func taskRequest() -> URLRequest? {
        guard let data = data else { return nil }
        
        let urlstring = LPConfig.shared.apiURL.appending("/createDemoUser")
        let url = URL(string: urlstring)!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "Post"
        request.addValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("nim_demo_ios", forHTTPHeaderField: "User-Agent")
        request.addValue(NIMSDK.shared().appKey()!, forHTTPHeaderField: "appkey")
        let postData = "username=\(data.account)&password=\(data.token)&nickname=\(data.nickname)"
        request.httpBody = postData.data(using: .utf8)
        return request
    }
    
    func onGetResponse(jsonObject: Any?, errorMsg: String?) {
        var errorMsg = errorMsg
        if let dict = jsonObject as? [AnyHashable: Any] {
            let json = JSON(dict)
            let code = json["res"].intValue
            if code == 200 {
                log.info("注册成功")
                errorMsg = nil
            } else {
                errorMsg = json["errmsg"].stringValue
            }
        }
        handler?(errorMsg)
    }
}
