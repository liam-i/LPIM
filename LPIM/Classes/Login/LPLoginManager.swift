//
//  LPLoginManager.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation

class LPLoginData: NSObject, NSCoding {
    var account: String?
    var token: String?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        account = aDecoder.decodeObject(forKey: "account") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        if let account = account, account.characters.count > 0 {
            aCoder.encode(account, forKey: "account")
        }
        if let token = token, token.characters.count > 0 {
            aCoder.encode(token, forKey: "token")
        }
    }
}

class LPLoginManager {
    
    // MARK: - internal
    
    static let shared : LPLoginManager = {
        var filePath: String? = nil
        if let appDocumentPath = LPFileLocationHelper.appDocumentPath {
            filePath = appDocumentPath + "lpim_sdk_login_data"
        }
        return LPLoginManager(path: filePath)
    }()
    
    var currentLoginData: LPLoginData? {
        didSet { saveData() }
    }
    
    // MARK: - private
    
    private var filePath: String?
    
    private init(path: String?) {
        filePath = path
        readData()
    }
    
    // TODO: - 建议上层开发对这个地方做加密,DEMO只为了做示范,所以没加密
    /// 从文件中读取和保存用户名密码
    private func readData() {
        guard let filePath = filePath else {
            currentLoginData = nil
            return log.error("readData error, filePath is nil.")
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            let object = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
            if object is LPLoginData, let loginData = object as? LPLoginData {
                return currentLoginData = loginData
            }
        }
        currentLoginData = nil
    }
    
    private func saveData() {
        guard let filePath = filePath else {
            return log.error("readData error, filePath is nil.")
        }
        
        var data = Data()
        if let loginData = currentLoginData {
            data = NSKeyedArchiver.archivedData(withRootObject: loginData)
        }
        
        try? data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
    }
}
