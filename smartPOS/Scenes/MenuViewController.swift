//
//  MenuViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 05/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.

import UIKit

class MenuViewController: UIViewController, GuillotineMenu {
    
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Activity"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Menu: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Menu: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Menu: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Menu: viewDidDisappear")
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: false, completion: nil)
    }
}

extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
