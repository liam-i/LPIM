//
//  LPContactUtilCell.swift
//  LPIM
//
//  Created by lipeng on 2017/6/28.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

protocol LPContactUtilCellDelegate: NSObjectProtocol {
    func utilImageClicked(_ content: String?) -> Void
}

class LPContactUtilCell: UITableViewCell {
    weak var delegate: LPContactUtilCellDelegate?
    
    fileprivate var badgeView: LPKBadgeView = {
        return LPKBadgeView.view(withBadgeTip: nil)
    }()
    fileprivate weak var dataModel: LPContactItemProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        comminit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminit()
    }
    
    func refresh(with item: LPContactItemProtocol, delegate: LPContactUtilCellDelegate?) {
        self.delegate = delegate
        dataModel = item
        
        textLabel?.text = item.showName
        imageView?.image = item.icon
        textLabel?.sizeToFit()
        
        badgeView.badgeValue = item.badge
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let kLPContactAvatarLeft: CGFloat = 10.0 // 没有选择框的时候，头像到左边的距离
        let kLPBadgeValueRight: CGFloat =  50.0
        
        imageView?.lp_left = kLPContactAvatarLeft
        imageView?.lp_centerY = lp_height / 2.0
        badgeView.lp_right = lp_width - kLPBadgeValueRight
        badgeView.lp_centerY = lp_height / 2.0
    }
    
    private func comminit() {
        addSubview(badgeView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(utilImageClicked))
        imageView?.addGestureRecognizer(tap)
        imageView?.isUserInteractionEnabled = true
    }
    
    @objc private func utilImageClicked() {
        delegate?.utilImageClicked(dataModel?.showName)
    }
}
