//
//  LPBaseNavigationController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit

class LPBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    deinit {
        log.warning("release memory.")
    }

}

//class YLBaseNavigationController: UINavigationController,  {
//
//    deinit {
//        yalog.warning("release memory.")
//    }
//
//    fileprivate var pan: UIPanGestureRecognizer?
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        self.setNeedsStatusBarAppearanceUpdate()
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        let barSize = self.navigationBar.frame.size
////        var image = UIImage(named: "discoveer_top_title_bar")
////        image = image?.reSizeImage(CGSize(width: barSize.width, height: barSize.height + 20))
////        self.navigationBar.barTintColor = UIColor(patternImage: image!)
//
//        navigationBar.barTintColor = UIColor(hex6: kBackgroundColor, alpha: 1)
//        navigationBar.tintColor = UIColor.white
//        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        //UINavigationBar.appearance().tintColor = UIColor.white
//        //UINavigationBar.appearance().barTintColor = UIColor(hex6: kBackgroundColor)
//        //下面两句是去掉UINavigationBar的下边距黑线
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        navigationBar.isTranslucent = false
//
//        /// 这个方法有2个弊端：1.如果上一个界面的title太长会把下一个界面的title挤到右边去；2.当app从后台进入页面会闪屏
//        //        let backButtonImage = UIImage(named: "btn_back_ico")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 30, 0, 0))
//        //        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
//        //        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(CGFloat(NSInteger.min), CGFloat(NSInteger.min)), forBarMetrics: UIBarMetrics.Default)
//
//        // 设置滑动返回手势
//        self.setupPanGestureRecognizer()
//    }
//
////    override func preferredStatusBarStyle() -> UIStatusBarStyle {
////        return UIStatusBarStyle.LightContent
////    }
//
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
//        if self.viewControllers.count > 0 {
//            /* 自动显示和隐藏tabbar */
//            viewController.hidesBottomBarWhenPushed = true
//            /* 设置导航栏上面的内容 */
//            // 设置左边的返回按钮
//            let menItem = UIBarButtonItem(image: UIImage(named: "btn_back_ico"), style: UIBarButtonItemStyle.done, target: self, action: #selector(back))
//            // 使用弹簧控件缩小菜单按钮和边缘距离
//            let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
//            spaceItem.width = -10
//            viewController.navigationItem.leftBarButtonItems = [spaceItem, menItem]
//        }
//
//        super.pushViewController(viewController, animated: animated)
//    }
//
//    func back() {
//        // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
//        self.popViewController(animated: true)
//    }
//
//    // MARK: - Setup PanGestureRecognizer
//
//    func setupPanGestureRecognizer() {
//        // 获取系统自带滑动手势的target对象
//        if let target = self.interactivePopGestureRecognizer?.delegate {
//
//            let action = NSSelectorFromString("handleNavigationTransition:")
//            // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//            let pan = UIPanGestureRecognizer(target: target, action: action)
//            // 设置手势代理，拦截手势触发
//            pan.delegate = self
//            // 给导航控制器的view添加全屏滑动手势
//            self.view.addGestureRecognizer(pan)
//            // 禁止使用系统自带的滑动手势
//            self.interactivePopGestureRecognizer?.isEnabled = false
//
//            self.pan = pan
//        }
//    }
//
//    func enabledGestureRecognizer(_ enable: Bool) {
//        self.pan?.isEnabled = enable
//    }
//

//}


extension LPBaseNavigationController: UIGestureRecognizerDelegate {
    //    /**
    //     什么时候调用：每次触发手势之前都会询问下代理，是否触发。
    //     作用：拦截手势触发
    //     - parameter gestureRecognizer: 手势识别器
    //     - returns: 标志是否禁用了当前手势识别器
    //     */
    //    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    //        // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    //        // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    //        if self.childViewControllers.count == 1 {
    //            return false // 表示用户在根控制器界面，就不需要触发滑动手势，
    //        }
    //        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
    //            let translationX = pan.translation(in: self.view).x
    //            if translationX > 0 {
    //                return true
    //            } else {
    //                return false
    //            }
    //        }
    //        return true
    //    }
}
