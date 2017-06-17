//
//  LPRegisterViewController.swift
//  LPIM
//
//  Created by lipeng on 2017/6/16.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol LPRegisterViewControllerDelegate: NSObjectProtocol {
    func registDidComplete(account: String?, password: String?) -> Void
}

class LPRegisterViewController: LPBaseViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: LPRegisterViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    
    func useClearBar() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTextField(accountTextField)
        resetTextField(nicknameTextField)
        resetTextField(passwordTextField)
    }
    
    func setupNav() {
        let registerBtn = UIButton(type: .custom)
        registerBtn.setTitle("完成", for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerBtn.setTitleColor(UIColor(hex6: 0x2294ff), for: .normal)
        registerBtn.setBackgroundImage(#imageLiteral(resourceName: "login_btn_done_normal"), for: .normal)
        registerBtn.setBackgroundImage(#imageLiteral(resourceName: "login_btn_done_pressed"), for: .highlighted)
        registerBtn.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        
        registerBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: registerBtn)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let image = #imageLiteral(resourceName: "icon_back_normal")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        var enabled = false
        if let account = accountTextField.text, let nickname = nicknameTextField.text, let pwd = passwordTextField.text {
            enabled = account.characters.count > 0 && nickname.characters.count > 0 && pwd.characters.count > 0
        }
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    @IBAction func existedButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func doneButtonClicked(_ sender: UIButton?) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        
        if !check() { return }
        let data = LPRegisterData(account: accountTextField.text!,
                                  token: passwordTextField.text!.tokenByPassword(),
                                  nickname: nicknameTextField.text!)
        
        LPHUD.showHUD(at: nil, text: nil)
        LPHTTPSession.shared.registerUser(with: data) { (errorMsg) in
            LPHUD.hide(true)
            
            if let errorMsg = errorMsg {
                self.delegate?.registDidComplete(account: nil, password: nil)
                LPHUD.showError(at: nil, text: "注册失败（\(errorMsg)）")
                return
            }
            
            LPHUD.showSuccess(at: nil, text: "注册成功")
            self.delegate?.registDidComplete(account: data.account, password: self.passwordTextField.text)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension LPRegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            doneButtonClicked(nil)
            return false
        }
        return true
    }
}

// MARK: - 
// MARK: - Private

extension LPRegisterViewController {
    
    fileprivate func resetTextField(_ textField: UITextField) {
        textField.tintColor = UIColor.white
        let dict = [NSForegroundColorAttributeName: UIColor(hex6: 0xffffff, alpha: 0.6)]
        let mas = NSAttributedString(string: textField.placeholder!, attributes: dict)
        textField.attributedPlaceholder = mas
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(#imageLiteral(resourceName: "login_icon_clear"), for: .normal)
        }
    }
    
    fileprivate func check() -> Bool {
        var checkAccount: Bool {
            guard let account = accountTextField.text else { return false }
            return account.characters.count > 0 && account.characters.count <= 20
        }
        
        var checkPassword: Bool {
            guard let pwd = passwordTextField.text else { return false }
            return pwd.characters.count >= 6 && pwd.characters.count <= 20
        }
        
        var checkNickname: Bool {
            guard let nickname = nicknameTextField.text else { return false }
            return nickname.characters.count > 0 && nickname.characters.count <= 10
        }
        
        if !checkAccount {
            LPHUD.showError(at: view, text: "账号长度有误")
            return false
        }
        if !checkPassword {
            LPHUD.showError(at: view, text: "密码长度有误")
            return false
        }
        if !checkNickname {
            LPHUD.showError(at: view, text: "昵称长度有误")
            return false
        }
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
