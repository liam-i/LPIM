//
//  LPLoginViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import NIMSDK

class LPLoginViewController: LPBaseViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(preferredStatusBarStyle, animated: false)
        
        navigationItem.title = ""
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("完成", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginBtn.setTitleColor(UIColor(hex6: 0x2294ff), for: .normal)
        loginBtn.setBackgroundImage(#imageLiteral(resourceName: "login_btn_done_normal"), for: .normal)
        loginBtn.setBackgroundImage(#imageLiteral(resourceName: "login_btn_done_pressed"), for: .highlighted)
        loginBtn.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        let longPressOnLoginBtn = UILongPressGestureRecognizer(target: self, action: #selector(prepareShowLog))
        loginBtn.addGestureRecognizer(longPressOnLoginBtn)
        loginBtn.sizeToFit()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loginBtn)
        
        let shadow = NSShadow()
        shadow.shadowOffset = .zero
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
                                                                   NSForegroundColorAttributeName: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTextField(usernameTextField)
        resetTextField(passwordTextField)
        
        registerButton.isHidden = !NIMSDK.shared().isUsingDemoAppKey()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func loginButtonClicked(_ sender: UIButton?) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        
        guard let account = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard let token = passwordTextField.text?.tokenByPassword() else {
            return
        }
        
        /// NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
        /// 用户APP的帐号体系和 NIM SDK 并没有直接关系
        /// DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
        /// 开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
        
        LPHUD.showHUD(at: nil, text: nil)
        NIMSDK.shared().loginManager.login(account, token: token) { (error) in
            LPHUD.hide(true)
            
            if let error = error {
                LPHUD.showError(at: nil, text: "登录失败 code:\(error._code)")
                return
            }
            
            let loginData = LPLoginData()
            loginData.account = account
            loginData.token = token
            LPLoginManager.shared.currentLoginData = loginData
            
            LPServiceManager.shared.start()
            let mainVC = LPMainTabBarController()
            UIApplication.shared.keyWindow?.rootViewController = mainVC
        }
    }
    
    
    func prepareShowLog(_ gesuture: UILongPressGestureRecognizer) {
        if gesuture.state != .began { return }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "查看SDK日志", style: .destructive, handler: { (_) in
            //                    [wself showSDKLog];
        }))
        actionSheet.addAction(UIAlertAction(title: "查看Demo日志", style: .default, handler: { (_) in
            //                    [wself showDemoLog];
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let vc = LPRegisterViewController(nibName: "LPRegisterViewController", bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        var enabled = false
        if let account = usernameTextField.text, let pwd = passwordTextField.text {
            enabled = account.characters.count > 0 && pwd.characters.count > 0
        }
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
}

// MARK: - Private

extension LPLoginViewController {
    
    fileprivate func resetTextField(_ textField: UITextField) {
        textField.tintColor = UIColor.white
        let dict = [NSForegroundColorAttributeName: UIColor(hex6: 0xffffff, alpha: 0.6)]
        let mas = NSAttributedString(string: textField.placeholder!, attributes: dict)
        textField.attributedPlaceholder = mas
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(#imageLiteral(resourceName: "login_icon_clear"), for: .normal)
        }
    }
    
    func showSDKLog() {
        //    UIViewController *vc = [[NTESLogManager sharedManager] sdkLogViewController];
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //    [self presentViewController:nav
        //                       animated:YES
        //                     completion:nil];
    }
    
    func showDemoLog() {
        //    UIViewController *logViewController = [[NTESLogManager sharedManager] demoLogViewController];
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewController];
        //    [self presentViewController:nav
        //                       animated:YES
        //                     completion:nil];
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - Delegate / Notification

extension LPLoginViewController: LPRegisterViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: - LPRegisterViewControllerDelegate
    
    func registDidComplete(account: String?, password: String?) {
        usernameTextField.text = account
        passwordTextField.text = password
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            loginButtonClicked(nil)
            return false
        }
        return true
    }
}
