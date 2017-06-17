//
//  LPService.swift
//  LPIM
//
//  Created by lipeng on 2017/6/17.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

protocol LPServiceTask: NSObjectProtocol {
    func taskRequest() -> URLRequest?
    
    // TODO: - errorMsg: String?参数需要优化
    func onGetResponse(jsonObject: Any?, errorMsg: String?)
}

class LPService {
    static let shared: LPService = { return LPService() }()
    
    fileprivate lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    func registerUser(with data: LPRegisterData, completion: @escaping LPRegisterHandler) {
        let task = LPRegisterTask()
        task.data = data
        task.handler = completion
        runTask(task: task)
    }

    //- (void)fetchDemoChatrooms:(NTESChatroomListHandler)completion {
    //    NTESDemoFetchChatroomTask *task = [[NTESDemoFetchChatroomTask alloc] init];
    //    task.handler = completion;
    //    [self runTask:task];
    //}
}

extension LPService {
    fileprivate func runTask(task: LPServiceTask) {
        if !NIMSDK.shared().isUsingDemoAppKey() {
            // Demo Service中我们模拟了APP服务器所应该实现的部分功能，上层开发需要构建相应的APP服务器，而不是直接使用我们的DEMO服务器
            return task.onGetResponse(jsonObject: nil, errorMsg: "use your own app server")
        }
        
        guard let request = task.taskRequest() else { return }
        let sessionTask = session.dataTask(with: request) { (data, response, error) in
            var jsonObject: Any?
            var errorMsg: String? = error?.localizedDescription
            if error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    do {
                        jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    } catch {
                        errorMsg = error.localizedDescription
                        log.error(error)
                    }
                } else {
                    errorMsg = "invalid data"
                }
            }
            DispatchQueue.main.async {
                task.onGetResponse(jsonObject: jsonObject, errorMsg: errorMsg)
            }
        }
        sessionTask.resume()
    }
}
