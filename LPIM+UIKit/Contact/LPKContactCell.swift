//
//  LPKContactCell.swift
//  LPIM
//
//  Created by lipeng on 2017/6/28.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

protocol LPKContactCellDelegate: NSObjectProtocol {
    func avatarClicked(_ uid: String) -> Void
}

class LPKContactCell: UITableViewCell {
    weak var delegate: LPKContactCellDelegate?
    var memberId: String?
    lazy var avatarButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 15
        return btn
    }()
    var accessoryButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.lp_image(named: "icon_accessory_normal"), for: .normal)
        btn.setImage(UIImage.lp_image(named: "icon_accessory_pressed"), for: .highlighted)
        btn.setImage(UIImage.lp_image(named: "icon_accessory_selected"), for: .selected)
        btn.isHidden = true
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        comminit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminit()
    }
    
    func refresh(user item: LPContactItemProtocol, delegate: LPKContactCellDelegate?) {
        self.delegate = delegate
        refresh(title: item.showName)
        memberId = item.userId
        
        if let memberId = memberId, let info = LPKKit.shared.info(byUser: memberId, option: nil) {
            refresh(avatar: info)
        }
    }
    
    func refresh(team item: LPContactItemProtocol, delegate: LPKContactCellDelegate?) {
        self.delegate = delegate
        
        self.delegate = delegate
        refresh(title: item.showName)
        memberId = item.userId
        
        if let memberId = memberId, let info = LPKKit.shared.info(byTeam: memberId, option: nil) {
            refresh(avatar: info)
        }
    }
    
    private func comminit() {
        avatarButton.addTarget(self, action: #selector(avatarClicked), for: .touchUpInside)
        addSubview(avatarButton)
        
        accessoryButton.sizeToFit()
        addSubview(accessoryButton)
    }
    
    private func refresh(title: String?) {
        textLabel?.text = title
    }
    
    private func refresh(avatar info: LPKInfo) {
        let urlString = info.avatarUrlString ?? ""
        avatarButton.kf.setImage(with: URL(string: urlString), for: .normal, placeholder: info.avatarImage)
    }
    
    @objc private func avatarClicked(_ sender: UIButton) {
        if let uid = memberId, let delegate = delegate {
            delegate.avatarClicked(uid)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        accessoryButton.isHighlighted = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let kLPContactAccessoryLeft: CGFloat = 10.0
        let kLPContactAvatarLeft: CGFloat = 10.0
        let kLPContactAvatarAndAccessorySpacing: CGFloat = 10.0
        let kLPContactAvatarAndTitleSpacing: CGFloat = 20.0
        
        let scale = lp_width / 320.0
        let maxTextLabelWidth = 210.0 * scale
        
        textLabel?.lp_width = min(textLabel?.lp_width ?? 0.0, maxTextLabelWidth)
        
        accessoryButton.lp_left = kLPContactAccessoryLeft
        accessoryButton.lp_centerY = lp_height / 2.0
        
        avatarButton.lp_left = accessoryButton.isHidden ? kLPContactAvatarLeft : kLPContactAvatarAndAccessorySpacing + accessoryButton.lp_right
        avatarButton.lp_centerY = lp_height / 2.0
        textLabel?.lp_left = avatarButton.lp_right + kLPContactAvatarAndTitleSpacing
    }
}
