//
//  LPKSessionListCell.swift
//  LPIM
//
//  Created by lipeng on 2017/6/20.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPKSessionListCell: UITableViewCell {
    var avatarButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 20.0
        return btn
    }()
    var nameLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    var messageLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    var timeLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    var badgeView: LPKBadgeView = {
        return LPKBadgeView.view(withBadgeTip: "")
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func refresh(with recent: NIMRecentSession) {
        let NameLabelMaxWidth: CGFloat    = 160.0
        let MessageLabelMaxWidth: CGFloat = 200.0
        nameLabel.lp_width = nameLabel.lp_width > NameLabelMaxWidth ? NameLabelMaxWidth : nameLabel.lp_width
        messageLabel.lp_width = messageLabel.lp_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : messageLabel.lp_width
        if recent.unreadCount > 0 {
            badgeView.isHidden = false
            badgeView.badgeValue = "\(recent.unreadCount)"
        } else {
            badgeView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Session List
        let sessionListAvatarLeft: CGFloat             = 15.0
        let sessionListNameTop: CGFloat                = 15.0
        let sessionListNameLeftToAvatar: CGFloat       = 15.0
        let sessionListMessageLeftToAvatar: CGFloat    = 15.0
        let sessionListMessageBottom: CGFloat          = 15.0
        let sessionListTimeRight: CGFloat              = 15.0
        let sessionListTimeTop: CGFloat                = 15.0
        let sessionBadgeTimeBottom: CGFloat            = 15.0
        let sessionBadgeTimeRight: CGFloat             = 15.0
        
        avatarButton.lp_left      = sessionListAvatarLeft
        avatarButton.lp_centerY   = lp_height / 2.0
        nameLabel.lp_top          = sessionListNameTop
        nameLabel.lp_left          = avatarButton.lp_right + sessionListNameLeftToAvatar
        messageLabel.lp_left       = avatarButton.lp_right + sessionListMessageLeftToAvatar
        messageLabel.lp_bottom     = lp_height - sessionListMessageBottom
        timeLabel.lp_right         = lp_width - sessionListTimeRight
        timeLabel.lp_top           = sessionListTimeTop
        badgeView.lp_right         = lp_width - sessionBadgeTimeRight
        badgeView.lp_bottom        = lp_height - sessionBadgeTimeBottom
    }
    
    private func commonInit() {
        addSubview(avatarButton)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
        addSubview(badgeView)        
    }
}
