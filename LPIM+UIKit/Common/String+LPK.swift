//
//  String+LPK.swift
//  LPIM
//
//  Created by lipeng on 2017/6/26.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

extension String {
    
    func lp_stringByDeletingPictureResolution() -> String {
        let doubleResolution  = "@2x"
        let tribleResolution = "@3x"
        let fileName = (self as NSString).deletingPathExtension
        var res = self
        if fileName.hasSuffix(doubleResolution) || fileName.hasSuffix(tribleResolution) {
            res = fileName.substring(to: fileName.characters.index(fileName.endIndex, offsetBy: -3))
            
            let pathExtension = (self as NSString).pathExtension
            if pathExtension.characters.count > 0 {
                res = (self as NSString).appendingPathExtension(pathExtension)!
            }
        }
        return res
    }
}
