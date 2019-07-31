//
//  UIViewController+FormSheet.swift
//  LPIM
//
//  Created by 李鹏 on 2017/3/28.
//  Copyright © 2017年 Hangzhou DangQiang network Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit

enum LPPresentationStyle {
    case activity
    case formSheet
}

enum LPTransitionStyle {
    case coverVertical
    case curveEaseInOut
}

extension UIViewController {
    
    // MARK: - public
    
    /// 显示 activity 视图控制器
    func presentActivity(_ contentViewController: UIViewController,
                         enableTapGesture: Bool = true,
                         completion: (() -> Void)?) {
        self.presentFormSheet(contentViewController,
                              presentationStyle: LPPresentationStyle.activity,
                              transitionStyle: LPTransitionStyle.coverVertical,
                              edgePoint: nil,
                              enableTapGesture: enableTapGesture,
                              completion: completion)
    }
    
    /// 隐藏 activity 视图控制器
    func dismissActivity(_ completion: (() -> Void)?) {
        kFormSheetVCS.last?.dismissViewController(completion)
    }
    
    /// 显示 formSheet 视图控制器
    func presentFormSheet(_ contentViewController: UIViewController,
                          edgePoint: CGPoint? = nil,
                          enableTapGesture: Bool = true,
                          transitionStyle: LPTransitionStyle = LPTransitionStyle.coverVertical,
                          completion: (() -> Void)?) {
        self.presentFormSheet(contentViewController,
                              presentationStyle: LPPresentationStyle.formSheet,
                              transitionStyle: transitionStyle,
                              edgePoint: edgePoint,
                              enableTapGesture: enableTapGesture,
                              completion: completion)
    }
    
    /// 隐藏 formSheet 视图控制器
    func dismissFormSheet(_ completion: (() -> Void)?) {
        kFormSheetVCS.last?.dismissViewController(completion)
    }
    
    // MARK: - private
    
    private func presentFormSheet(_ contentViewController: UIViewController,
                                  presentationStyle: LPPresentationStyle,
                                  transitionStyle: LPTransitionStyle,
                                  edgePoint: CGPoint?,
                                  enableTapGesture: Bool,
                                  completion: (() -> Void)?) {
        
        let formSheetVc = LPFormSheetViewController()
        formSheetVc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(formSheetVc, animated: false) {
            formSheetVc.presentViewController(contentViewController,
                                              presentationStyle: presentationStyle,
                                              transitionStyle: transitionStyle,
                                              edgePoint: edgePoint,
                                              enableTapGesture: enableTapGesture)
            completion?()
        }
    }
}

private var kFormSheetVCS: [LPFormSheetViewController] = []
class LPFormSheetViewController: LPBaseViewController {
    lazy var presentationStyle: LPPresentationStyle = LPPresentationStyle.activity
    lazy var transitionStyle: LPTransitionStyle = LPTransitionStyle.coverVertical
    lazy var maskView: UIView = UIView()
    lazy var tapGesture: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(formSheetTapGestureRecognizer))
    }()
    
    var contentViewController: UIViewController?
    var transitionConstraint: Constraint?
    
    // MARK: - cycle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.maskView.alpha = 0.0
        
        // 初始化灰色遮罩
        self.maskView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        //        self.maskView.layer.borderColor = UIColor.redColor().CGColor
        //        self.maskView.layer.borderWidth = 2
        self.view.addSubview(self.maskView)
        
        // 添加单击手势
        self.maskView.addGestureRecognizer(self.tapGesture)
    }
    
    // MARK: - public
    
    /// 显示activity、formSheet视图控制器
    func presentViewController(_ viewController: UIViewController,
                               presentationStyle: LPPresentationStyle,
                               transitionStyle: LPTransitionStyle,
                               edgePoint: CGPoint?,
                               enableTapGesture: Bool) {
        
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.contentViewController = viewController
        kFormSheetVCS.append(self)
        self.tapGesture.isEnabled = enableTapGesture
        
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        switch presentationStyle {
        case LPPresentationStyle.activity:
            self.activityAnimation(viewController)
        case LPPresentationStyle.formSheet:
            self.formSheetAnimation(viewController, edgePoint: edgePoint)
        }
    }
    
    /// 隐藏视图控制器
    func dismissViewController(_ completion: (() -> Void)?) {
        switch self.transitionStyle {
        case LPTransitionStyle.coverVertical:
            UIView.animate(withDuration: kDuration_Of_Animation, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
                self.maskView.alpha = 0.0
                if let height = self.contentViewController?.view.frame.height {
                    if self.presentationStyle == LPPresentationStyle.activity {
                        self.transitionConstraint?.update(offset: height)
                    } else {
                        self.transitionConstraint?.update(offset: (self.view.frame.height + height) / 2.0)
                    }
                }
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.dismiss(animated: false, completion: {
                    self.contentViewController = nil
                    self.transitionConstraint = nil
                    kFormSheetVCS.removeLast()
                    
                    if let completion = completion {
                        completion()
                    }
                })
            })
        case LPTransitionStyle.curveEaseInOut:
            UIView.animate(withDuration: kDuration_Of_Animation, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.maskView.alpha = 0.0
            }) { (finished) in
                self.dismiss(animated: false, completion: { 
                    self.contentViewController = nil
                    self.transitionConstraint = nil
                    kFormSheetVCS.removeLast()
                    
                    if let completion = completion {
                        completion()
                    }
                })
            }
        }
    }
    
    /// 单击手势用来隐藏视图控制器
    func formSheetTapGestureRecognizer(_ recognizer: UIGestureRecognizer) {
        if let contetnView = self.contentViewController?.view {
            let point = recognizer.location(in: contetnView)
            if !contetnView.bounds.contains(point) {
                dismissViewController(nil)
            }
        }
    }
    
    // MARK: - private
    
    /// 显示activity视图控制器
    private func activityAnimation(_ viewController: UIViewController) {
        let height = viewController.view.frame.height
        viewController.view.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(height)
            make.left.right.equalTo(self.view)
            let offset = make.bottom.equalTo(self.view.snp.bottom).offset(height)
            self.transitionConstraint = offset.constraint
        }
        
        self.maskView.alpha = 0.0
        self.view.layoutIfNeeded()
        self.transitionConstraint?.update(offset: 0.0)
        UIView.animate(withDuration: kDuration_Of_Animation, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.maskView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// 显示formSheet视图控制器
    private func formSheetAnimation(_ viewController: UIViewController, edgePoint: CGPoint?) {
        
        // 设置边距
        if let edgePoint = edgePoint {
            let frame = self.view.frame
            let size = CGSize(width: frame.width - edgePoint.x * 2.0, height: frame.height - edgePoint.y * 2.0)
            viewController.view.frame.size = size
        }
        
        viewController.view.snp.makeConstraints( { (make) in
            make.height.equalTo(viewController.view.frame.height)
            make.width.equalTo(viewController.view.frame.width)
            make.centerX.equalTo(self.view.snp.centerX)
            switch self.transitionStyle {
            case LPTransitionStyle.coverVertical:
                let offset =  (self.view.frame.height + viewController.view.frame.height) / 2.0
                self.transitionConstraint = make.centerY.equalTo(self.view.snp.centerY).offset(offset).constraint
            case LPTransitionStyle.curveEaseInOut:
                make.centerY.equalTo(self.view.snp.centerY).offset(0.0)
            }
        })
        
        switch self.transitionStyle {
        case LPTransitionStyle.coverVertical:
            self.maskView.alpha = 0.0
            self.view.layoutIfNeeded()
            transitionConstraint?.update(offset: 0.0)
            UIView.animate(withDuration: kDuration_Of_Animation, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.maskView.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        case LPTransitionStyle.curveEaseInOut:
            self.maskView.alpha = 0.0
            UIView.animate(withDuration: 0.1, animations: {
                self.maskView.alpha = 1.0
            })
            let previousTransform = viewController.view.transform
            viewController.view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0)
            UIView.animate(withDuration: 0.2, animations: {
                viewController.view.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0.0)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    viewController.view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0)
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.1, animations: {
                        viewController.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0)
                    }, completion: { (finished) in
                        viewController.view.transform = previousTransform
                    })
                })
            })
        }
    }
}
