//
//  LPKMediaItem.swift
//  LPIM
//
//  Created by lipeng on 2017/6/24.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPKMediaItem: NSObject {
    var selctor: Selector
    var normalImage: UIImage?
    var selectedImage: UIImage?
    var title: String
    
    init(selector: Selector, normalImage: UIImage?, selectedImage: UIImage?, title: String) {
        self.selctor = selector
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.title = title
    }
}



