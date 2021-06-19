//
//  ActivateCodeViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 12/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Loady
import SwiftEventBus
import UIKit

class ActivateCodeViewController: UIViewController {
    var worker: LoginWorker? = LoginWorker()
    @IBOutlet var tfCodeOne: UITextField! {
        didSet {
            tfCodeOne.delegate = self
            tfCodeOne.tag = 1
        }
    }

    @IBOutlet var tfCodeTwo: UITextField! {
        didSet {
            tfCodeTwo.delegate = self
            tfCodeTwo.tag = 2
        }
    }

    @IBOutlet var tfCodeThree: UITextField! {
        didSet {
            tfCodeThree.delegate = self
            tfCodeThree.tag = 3
        }
    }

    var fourPhaseTempTimer: Timer?
    @IBOutlet var btnActivate: LoadyFourPhaseButton! {
        didSet {
            btnActivate.layer.cornerRadius = 8
            btnActivate.loadingColor = UIColor(red: 0.38, green: 0.66, blue: 0.09, alpha: 1.0)
            btnActivate.setPhases(phases: .init(normalPhase:
                (title: "Khoá", image: UIImage(named: "unlocked"), background: UIColor(red: 0.00, green: 0.49, blue: 0.90, alpha: 1.0)), loadingPhase:
                (title: "Đang đợi ...", image: nil, background: UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)), successPhase:
                (title: "Đã kích hoạt", image: UIImage(named: "locked"), background: UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.0)), errorPhase:
                (title: "Lỗi", image: UIImage(named: "unlocked"), background: UIColor(red: 0.64, green: 0.00, blue: 0.15, alpha: 1.0))))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onActivateCode(_ sender: Any) {
        let activationCode = "\(tfCodeOne.text ?? "")-\(tfCodeTwo.text ?? "")-\(tfCodeThree.text ?? "")"
        let devideId = UIDevice.current.identifierForVendor?.uuidString
        print("activationCode: ", activationCode)
        print("devideId: ", devideId)
        var errorString = ""
        btnActivate.startLoading()
        worker?.userDataManager.verifyKey(posAppKey: activationCode, deviceId: devideId ?? "", APIConfig.debugMode).done { verifyRes in
            print("verifyRes Response")
            print(verifyRes)
            if verifyRes.statusCode >= 200, verifyRes.statusCode <= 300 {
                let data = verifyRes.data
                if let merchantId = data.merchantId {
                    APIConfig.setMerchantId(merchantId: merchantId)
                }
                if let restaurantId = data.restaurantId {
                    APIConfig.setRestaurantId(restaurantId: restaurantId)
                }
            } else {
                errorString = "Usernam/Password is invalid."
            }
        }.catch { error in
            print(error.localizedDescription.description)
            errorString = error.asAFError?.errorDescription ?? "Đã có lỗi xảy ra."
        }.finally {
            if self.btnActivate.loadingIsShowing() {
                self.btnActivate.stopLoading()
            }
            if errorString != "" {
                self.btnActivate.errorPhase()
                return
            }
            self.btnActivate.successPhase()
            self.showLoginView()
        }

//        if let button = sender as? LoadyFourPhaseButton {
//            if button.loadingIsShowing() {
//                button.stopLoading()
//                return
//            }
//            button.startLoading()
//            fourPhaseTempTimer?.invalidate()
//            fourPhaseTempTimer = nil
//            btnActivate.loadingPhase()
//            if #available(iOS 10.0, *) {
//                self.fourPhaseTempTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
//                    if self.btnActivate.tag == 0 {
//                        self.btnActivate.errorPhase()
//                        self.btnActivate.tag = 1
//                    } else if self.btnActivate?.tag == 1 {
//                        self.btnActivate.successPhase()
//                        self.btnActivate.tag = 2
//                    } else {
//                        self.btnActivate.normalPhase()
//                        self.btnActivate.tag = 0
//                    }
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                self.fourPhaseTempTimer?.fire()
//            }
//            return
//        }
    }

    func showLoginView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true)
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

extension ActivateCodeViewController {
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 4
    }

    private func shouldNextTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }

    private func shouldPrevTextField(_ textField: UITextField) {
        let prevTextFieldTag = textField.tag - 1
        print("prevTextFieldTag", prevTextFieldTag, textField.superview?.viewWithTag(prevTextFieldTag))
        if let prevTextField = textField.superview?.viewWithTag(prevTextFieldTag) as? UITextField {
            prevTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

   override func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            shouldPrevTextField(textField)
            return
        }

        if textField.text?.count == 4 {
            shouldNextTextField(textField)
            return
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        switch textField {
        case tfCodeOne:
            return tfCodeOne.text?.count != 4
        case tfCodeTwo:
            if tfCodeTwo.text?.count == 4 {
                shouldNextTextField(textField)
                return false
            }
            if tfCodeOne.text?.count != 4 {
                shouldPrevTextField(textField)
                return false
            }
            return tfCodeTwo.text?.count != 4
        case tfCodeThree:
            if tfCodeTwo.text?.count != 4 {
                shouldPrevTextField(textField)
                return false
            }
            return tfCodeThree.text?.count != 4
        default:
            return true
        }
    }
}
