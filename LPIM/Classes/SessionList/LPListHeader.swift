//
//  LPListHeader.swift
//  LPIM
//
//  Created by lipeng on 2017/6/26.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

enum LPListHeaderType {
    case commonText, netStauts, loginClients
}

protocol LPListHeaderView: NSObjectProtocol {
    func setContentText(_ content: String) -> Void
}
protocol LPListHeaderDelegate: NSObjectProtocol {
    func didSelectRowType(_ type: LPListHeaderType) -> Void
}

class LPListHeader: UIView {
    weak var delegate: LPListHeaderDelegate?
    
    func refresh(with type: LPListHeaderType, value: Any) {
        switch type {
        case .commonText:
            if let value = value as? String {
                refresh(withCommonText: value)
            }
        case .netStauts:
            if let value = value as? NIMLoginStep {
                refresh(withNetStatus: value)
            }
        case .loginClients:
            if let value = value as? [NIMLoginClient] {
                refresh(withClients: value)
            }
        }
        sizeToFit()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 0.0
        for subView in subviews {
            subView.sizeToFit()
            height += subView.lp_height
        }
        return CGSize(width: lp_width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var top: CGFloat = 0.0
        for subView in subviews {
            subView.lp_top = top
            top = top + subView.lp_height
            subView.lp_centerX = lp_width / 2.0
        }
    }
}

// MARK: - Private

extension LPListHeader {
    
    func refresh(withClients clients: [NIMLoginClient]) {
        //    NSString *text = nil;
        //    if (clients.count) {
        //        //目前的踢人逻辑是web和pc不能共存，移动端不能共存，所以这里取第一个显示就可以了
        //        NIMLoginClient *client = clients.firstObject;
        //        NSString *name = [NTESClientUtil clientName:client.type];
        //        text = name.length? [NSString stringWithFormat:@"正在使用云信%@版",name] : @"正在使用云信未知版本";
        //    }
        //    [self addRow:ListHeaderTypeLoginClients content:text viewClassName:@"NTESMutiClientsHeaderView"];
    }
    
    func refresh(withNetStatus step: NIMLoginStep) {
        //    NSString *text = nil;
        //    switch (step) {
        //        case NIMLoginStepLinkFailed:
        //        case NIMLoginStepLoseConnection:
        //            text = @"当前网络不可用，请检查网络设置";
        //            break;
        //        case NIMLoginStepLoginFailed:
        //            text = @"登录失败";
        //            break;
        //        case NIMLoginStepNetChanged:
        //        {
        //            if ([[Reachability reachabilityForInternetConnection] isReachable])
        //            {
        //                text = @"网络正在切换,识别中....";
        //            }
        //            else
        //            {
        //                text = @"当前网络不可用";
        //            }
        //        }
        //            break;
        //        default:
        //            break;
        //    }
        //    [self refreshWithCommonText:text];
    }
    
    func refresh(withCommonText text: String) {
        //    [self addRow:ListHeaderTypeCommonText content:text viewClassName:@"NTESTextHeaderView"];
    }
    
    ////参数viewClassName的Class 必须是UIControl的子类并实现<NTESSessionListHeaderView>协议
    //- (void)addRow:(NTESListHeaderType)type content:(NSString *)content viewClassName:(NSString *)viewClassName{
    //    UIControl<NTESListHeaderView> *rowView = (UIControl<NTESListHeaderView> *)[self viewWithTag:type];
    //    if ([content length])
    //    {
    //        if (!rowView) {
    //            Class clazz = NSClassFromString(viewClassName);
    //            rowView = [[clazz alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    //            rowView.backgroundColor = [self fillBackgroundColor:type];
    //            __block NSInteger insert = self.subviews.count;
    //            [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //                UIView *view = obj;
    //                if (view.tag > type) {
    //                    insert = idx;
    //                    *stop = YES;
    //                }
    //            }];
    //            rowView.tag = type;
    //            [self insertSubview:rowView atIndex:insert];
    //            [rowView addTarget:self action:@selector(didSelectRow:) forControlEvents:UIControlEventTouchUpInside];
    //        }
    //        [rowView setContentText:content];
    //    }
    //    else
    //    {
    //        [rowView removeFromSuperview];
    //    }
    //}
    //
    //
    //- (void)didSelectRow:(id)sender{
    //    UIControl *view = sender;
    //    if ([self.delegate respondsToSelector:@selector(didSelectRowType:)]) {
    //        [self.delegate didSelectRowType:view.tag];
    //    }
    //}
    //
    //
    //- (UIColor *) fillBackgroundColor:(NTESListHeaderType)type{
    //    NSDictionary *dict = @{
    //                           @(ListHeaderTypeNetStauts)    : [UIColor yellowColor],
    //                           @(ListHeaderTypeCommonText)   : UIColorFromRGB(0xefefef),
    //                           @(ListHeaderTypeLoginClients) : UIColorFromRGB(0xefefef)
    //                           };
    //    return dict[@(type)];
    //}

}
