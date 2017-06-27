//
//  LPKBadgeView.swift
//  LPIM
//
//  Created by lipeng on 2017/6/20.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPKBadgeView: UIView {
    fileprivate var badgeBackgroundColor: UIColor = UIColor.red
    fileprivate var badgeTextColor: UIColor = UIColor.white
    fileprivate var badgeTextFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    fileprivate var badgeTopPadding: CGFloat = 2.0  //数字顶部到红圈的距离
    fileprivate var badgeLeftPadding: CGFloat = 2.0 //数字左部到红圈的距离
    fileprivate var whiteCircleWidth: CGFloat = 2.0 //最外层白圈的宽度
    
    var badgeValue: String? {
        didSet {
            if let badgeValue = badgeValue, let value = Int(badgeValue), value > 9 {
                badgeLeftPadding = 6.0
            } else {
                badgeLeftPadding = 2.0
            }
            badgeTopPadding      = 2.0
            
            frame = frame(withBadge: badgeValue)
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    class func view(withBadgeTip badgeValue: String) -> LPKBadgeView {
        let instance = LPKBadgeView(frame: .zero)
        instance.frame = instance.frame(withBadge: badgeValue)
        instance.badgeValue = badgeValue
        return instance
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        if let badgeValue = badgeValue, badgeValue.characters.count > 0 {
            draw(withContent: rect, context: context)
        } else {
            draw(withOutContent: rect, context: context)
        }
        context.restoreGState()
    }
}

// MARK: - 
// MARK: - Private

extension LPKBadgeView {
    
    fileprivate func frame(withBadge badgeValue: String?) -> CGRect {
        let bsize = badgeSize(badgeValue)
        let bframe = CGRect(x: frame.origin.x,
                            y: frame.origin.y,
                            width: bsize.width + badgeLeftPadding * 2 + whiteCircleWidth * 2,
                            height: bsize.height + badgeTopPadding * 2 + whiteCircleWidth * 2) // 8=2*2（红圈-文字）+2*2（白圈-红圈）
        return bframe
    }
    
    fileprivate func badgeSize(_ badgeValue: String?) -> CGSize {
        guard let badgeValue = badgeValue, badgeValue.characters.count != 0 else { return .zero }
        var size = (badgeValue as NSString).size(attributes: [NSFontAttributeName : badgeTextFont])
        if size.width < size.height {
            size = CGSize(width: size.height, height: size.height)
        }
        return size
    }
    
    fileprivate func draw(withContent rect: CGRect, context: CGContext) {
        guard let badgeValue = badgeValue else { return }
        
        let bodyFrame = bounds
        let bkgFrame = bounds.insetBy(dx: whiteCircleWidth, dy: whiteCircleWidth)
        let badgeSize = bounds.insetBy(dx: whiteCircleWidth + badgeLeftPadding, dy: whiteCircleWidth + badgeTopPadding)
        
        /// 外白色描边
        context.setFillColor(UIColor.white.cgColor)
        if let intValue = Int(badgeValue), intValue > 9 {
            let circleWith = bodyFrame.height
            let totalWidth = bodyFrame.width
            let diffWidth = totalWidth - circleWith
            let originPoint = bodyFrame.origin
            let leftCicleFrame = CGRect(origin: originPoint, size: CGSize(width: circleWith, height: circleWith))
            let centerFrame = CGRect(x: originPoint.x + circleWith / 2, y: originPoint.y, width: diffWidth, height: circleWith)
            let rightCicleFrame = CGRect(x: originPoint.x + (totalWidth - circleWith), y: originPoint.y, width: circleWith, height: circleWith)
            
            context.fillEllipse(in: leftCicleFrame)
            context.fill(centerFrame)
            context.fillEllipse(in: rightCicleFrame)
        } else {
            context.fillEllipse(in: bodyFrame)
        }
        
        /// badge背景色
        context.setFillColor(badgeBackgroundColor.cgColor)
        if let intValue = Int(badgeValue), intValue > 9 {
            let circleWith = bkgFrame.size.height
            let totalWidth = bkgFrame.size.width
            let diffWidth = totalWidth - circleWith
            let originPoint = bkgFrame.origin
            let leftCicleFrame = CGRect(x: originPoint.x, y: originPoint.y, width: circleWith, height: circleWith)
            let centerFrame = CGRect(x: originPoint.x + circleWith / 2, y: originPoint.y, width: diffWidth, height: circleWith)
            let rightCicleFrame = CGRect(x: originPoint.x + (totalWidth - circleWith), y: originPoint.y, width: circleWith, height: circleWith)
            
            context.fillEllipse(in: leftCicleFrame)
            context.fill(centerFrame)
            context.fillEllipse(in: rightCicleFrame)
        } else {
            context.fillEllipse(in: bkgFrame)
        }
        
        context.setFillColor(badgeTextColor.cgColor)
        let badgeTextStyle = NSMutableParagraphStyle()
        badgeTextStyle.lineBreakMode = .byWordWrapping
        badgeTextStyle.alignment = .center
        
        let badgeTextAttributes: [String: Any] = [NSFontAttributeName: badgeTextFont,
                                                  NSForegroundColorAttributeName: badgeTextColor,
                                                  NSParagraphStyleAttributeName: badgeTextStyle]
        (badgeValue as NSString).draw(in: CGRect(x: whiteCircleWidth + badgeLeftPadding,
                                                 y: whiteCircleWidth + badgeTopPadding,
                                                 width: badgeSize.width,
                                                 height: badgeSize.height),
                                      withAttributes: badgeTextAttributes)
    }
    
    fileprivate func draw(withOutContent rect: CGRect, context: CGContext) {
        let bodyFrame = bounds
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: bodyFrame)
    }
}

