//
//  LPKDevice.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

private let kLPKNormalImageSize: CGFloat = 1280 * 960

struct LPKDevice {
    static let shared: LPKDevice = { return LPKDevice() }()
    
    /// 图片/音频推荐参数
    var suggestImagePixels: CGFloat {
        return kLPKNormalImageSize
    }
    
    var compressQuality: CGFloat {
        return 0.5
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
