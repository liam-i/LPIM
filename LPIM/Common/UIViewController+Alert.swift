//
//  UIViewController+Alert.swift
//  Happy100
//
//  Created by 李鹏 on 2017/4/2.
//  Copyright © 2017年 Hangzhou DangQiang network Technology Co., Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String = "", msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showAlert(_ title: String = "", error: Error?) {
        if let error = error, view.window != nil {
            
            let mgs = error.localizedDescription
            if mgs.characters.count == 0 {
                return
            }
            
            let alert = UIAlertController(title: title, message: mgs, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (_) -> Void in
                
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    func showAlert(title: String?,
                   msg: String?,
                   cancel: String?, cancelBlock: (() -> Void)? = nil,
                   ok: String = "确定", okBlock: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        if let cancel = cancel {
            alert.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: { (_) in
                cancelBlock?()
            }))
        }
        alert.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.destructive, handler: { (_) in
            okBlock()
        }))
        present(alert, animated: true, completion: nil)
    }
}
