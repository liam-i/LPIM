//
//  LPBaseViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    deinit {
        log.warning("release memory.")
    }

}
