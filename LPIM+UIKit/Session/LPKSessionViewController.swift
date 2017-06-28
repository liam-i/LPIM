//
//  LPKSessionViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/24.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPKSessionViewController: UIViewController {

    convenience init(session: NIMSession) {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    /// 相册
    func onTapMediaItemPicture(_ item: LPKMediaItem) {
        
    }
    
    /// 拍摄
    func onTapMediaItemShoot(_ item: LPKMediaItem) {
        
    }
    
    /// 位置
    func onTapMediaItemLocation(_ item: LPKMediaItem) {
        
    }

}
