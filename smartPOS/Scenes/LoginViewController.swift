//
//  LoginViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 12/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import AnimatedField
import SwiftEventBus
import UIKit

class LoginViewController: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBOutlet var vLogin: UIView! {
        didSet {
            vLogin.layer.cornerRadius = 8
            vLogin.clipsToBounds = true
            vLogin.layer.borderWidth = 1
            vLogin.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        }
    }

    @IBOutlet var btnLogin: UIButton! {
        didSet {
            btnLogin.layer.cornerRadius = 8
        }
    }

//    @IBOutlet var tfUsername: AnimatedField! {
//        didSet {
//            self.tfUsername.becomeFirstResponder()
//        }
//    }
//
//    @IBOutlet var tfPassword: AnimatedField! {
//        didSet {
    ////            self.tfPassword.becomeFirstResponder()
//        }
//    }

    @IBOutlet var fUsername: AnimatedField! {
        didSet {
//
//            fUsername.layer.cornerRadius = 8
//            fUsername.clipsToBounds = true
//            fUsername.layer.borderWidth = 1
//            fUsername.layer.borderColor = UIColor.gray.cgColor
//
            fUsername.text = ""
            fUsername.placeholder = "Tài khoản"
            fUsername.lowercased = true
            fUsername.type = .username(4, 20)
            fUsername.tag = 1
        }
    }

    @IBOutlet var fPassword: AnimatedField! {
        didSet {
            fPassword.placeholder = "Mật khẩu"
            fPassword.type = .password(6, 20)
            fPassword.isSecure = true
            fPassword.showVisibleButton = true
            fPassword.tag = 2
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTap()

        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: "Poppins-Regular", size: 14)!
        format.textFont = UIFont(name: "Poppins-Regular", size: 16)!
        format.alertColor = .red
        format.alertPosition = .top
        format.alertFieldActive = false
        format.titleAlwaysVisible = true
        format.alertFont = UIFont(name: "Poppins-Regular", size: 14)!

        fUsername.format = format
        fUsername.dataSource = self
        fUsername.delegate = self

        fPassword.format = format
        fPassword.dataSource = self
        fPassword.delegate = self
    }

    @IBAction func onLogin(_ sender: Any) {
//        self.showMenuView()
    }

    fileprivate func showMenuView() {
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let mainViewController = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController

        let nvc = UINavigationController(rootViewController: mainViewController)

        UINavigationBar.appearance().tintColor = UIColor(hex: "FF6B35")

        leftViewController.mainViewController = nvc

        let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        slideMenuController.modalPresentationStyle = .fullScreen
        present(slideMenuController, animated: false)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension LoginViewController: AnimatedFieldDelegate {
    func animatedFieldDidEndEditing(_ animatedField: AnimatedField) {
        let validInfo = fUsername.isValid && fPassword.isValid
        btnLogin.isEnabled = validInfo
        btnLogin.alpha = validInfo ? 1.0 : 0.3
    }

    func animatedFieldDidChange(_ animatedField: AnimatedField) {
        print("text: \(animatedField.text ?? "")")
    }
}

extension LoginViewController: AnimatedFieldDataSource {
    func animatedFieldLimit(_ animatedField: AnimatedField) -> Int? {
        switch animatedField.tag {
        case 1: return 10
        case 8: return 30
        default: return nil
        }
    }
}
