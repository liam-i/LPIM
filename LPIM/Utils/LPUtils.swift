//
//  LPUtils.swift
//  LPIM
//
//  Created by lipeng on 2017/6/17.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import XCGLogger


/// 日志调试器
let log: XCGLogger = {
    let log = XCGLogger.default
    #if DEBUG
        log.remove(destinationWithIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier)
        log.add(destination: AppleSystemLogDestination(identifier: XCGLogger.Constants.systemLogDestinationIdentifier))
        log.logAppDetails()
    #else
        log.setup(level:.severe, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
    #endif
    let format = PrePostFixLogFormatter()
    format.apply(prefix: "🗯🗯🗯 ", postfix: nil, to: .verbose)
    format.apply(prefix: "🔹🔹🔹 ", postfix: nil, to: .debug)
    format.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: nil, to: .info)
    format.apply(prefix: "⚠️⚠️⚠️ ", postfix: nil, to: .warning)
    format.apply(prefix: "‼️‼️‼️ ", postfix: nil, to: .error)
    format.apply(prefix: "💣💣💣 ", postfix: nil, to: .severe)
    log.formatters = [format]
    return log
}()


class YLUtils {
    
    /// 获取当前栈顶部的viewController
    class var topController: UIViewController? {
        get {
            if var controller = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedVc = controller.presentedViewController {
                    controller = presentedVc
                }
                return controller
            }
            return nil
        }
    }
}
