//
//  LPBaseCollectionViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPBaseCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    deinit {
        log.warning("release memory.")
    }

}
