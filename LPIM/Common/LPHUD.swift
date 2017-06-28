//
//  LPHUD.swift
//  LPIM
//
//  Created by lipeng on 2017/6/17.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import LPProgressHUD

class LPHUD {
    static var lastHUD: LPProgressHUD? = nil
    
    class func showText(at view: UIView?, text: String, center: Bool = false) {
        if let lastHUD = lastHUD {
            lastHUD.hide(animated: false)
        }
        
        let inView = view ?? topView()
        let HUD = LPProgressHUD(with: inView)
        HUD.mode = LPProgressHUDMode.text
        HUD.detailsLabel.text = text
        HUD.margin = 10.0
        if !center {
            HUD.offset = CGPoint(x: 0.0, y: LPProgressMaxOffset)
        }
        HUD.removeFromSuperViewOnHide = true
        inView.addSubview(HUD)
        HUD.show(animated: true)
        
        HUD.hide(animated: true, afterDelay: kDuration_Of_HUD)
    }
    
    class func showError(at view: UIView?, text: String?) {
        let errorView = UIImageView(image: UIImage(named: "hud_error"))
        let HUD = show(at: view, text: text, customView: errorView, global: true)
        HUD.hide(animated: true, afterDelay: kDuration_Of_HUD)
    }
    
    class func showSuccess(at view: UIView?, text: String?) {
        let successView = UIImageView(image: UIImage(named: "hud_success"))
        let HUD = show(at: view, text: text, customView: successView, global: true)
        HUD.hide(animated: true, afterDelay: kDuration_Of_HUD)
    }
    
    @discardableResult class func showHUD(at view: UIView?, text: String?, global: Bool = true) -> LPProgressHUD {
        return show(at: view, text: text, customView: nil, global: global)
    }
}

extension LPHUD {
    class func hide(_ animated: Bool) {
        if let hud = lastHUD {
            hud.hide(animated: animated)
            lastHUD = nil
        }
    }
}

extension LPHUD {
    
    fileprivate class func show(at view: UIView?, text: String?, customView: UIView?, global: Bool) -> LPProgressHUD {
        LPHUD.hide(false)
        
        let inView = view ?? topView()
        let HUD = LPProgressHUD(with: inView)
        if let _ = customView {
            HUD.mode = LPProgressHUDMode.customView
        } else {
            HUD.mode = LPProgressHUDMode.indeterminate
        }
        
        HUD.customView = customView
        HUD.detailsLabel.text = text
        HUD.removeFromSuperViewOnHide = true
        inView.addSubview(HUD)
        HUD.show(animated: true)
        
        if global {
            lastHUD = HUD
        }
        return HUD
    }
    
    fileprivate class func topView() -> UIView {
        return UIApplication.shared.keyWindow ?? UIView()
    }
}
