//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case checkout
    case java
    case setting
    case nonMenu
}

protocol LeftMenuProtocol: AnyObject {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController: UIViewController, LeftMenuProtocol {
//    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imgUserAvatar: UIView!
    @IBOutlet var vBackgroundHeader: UIView!
    @IBOutlet var lbUsername: UILabel!
    
//    var menus = ["Checkout", "Đơn hàng", "Quản lý kho", "Cài đặt", "NonMenu"]
    var menus: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "ic_feed")!, title: "Checkout"),
        SideMenuModel(icon: UIImage(named: "ic_feed")!, title: "Đơn hàng"),
        SideMenuModel(icon: UIImage(named: "ic_feed")!, title: "Quản lý kho"),
        SideMenuModel(icon: UIImage(named: "ic_feed")!, title: "Quản lý nhân viên"),
        SideMenuModel(icon: UIImage(named: "ic_feed")!, title: "Cài đặt"),
        SideMenuModel(icon: UIImage(named: "ic_feed")!, title: "Cài đặt"),
    ]
    var mainViewController: UIViewController!
    var checkoutViewController: UIViewController!
    var javaViewController: UIViewController!
    var settingViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let checkoutViewController = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.checkoutViewController = UINavigationController(rootViewController: checkoutViewController)
        
        let javaViewController = storyboard.instantiateViewController(withIdentifier: "JavaViewController") as! JavaViewController
        self.javaViewController = UINavigationController(rootViewController: javaViewController)
        
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.settingViewController = UINavigationController(rootViewController: settingViewController)
        
        let nonMenuController = storyboard.instantiateViewController(withIdentifier: "NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
//        self.tableView.registerCellClass(MenuItemTableViewCell.self)
        // Register TableView Cell
        self.tableView.register(MenuItemTableViewCell.nib, forCellReuseIdentifier: MenuItemTableViewCell.identifier)

        // Update TableView with the data
        self.tableView.reloadData()
//        self.imageHeaderView = ImageHeaderView.loadNib()
//        self.view.addSubview(self.imageHeaderView)
        
        setupHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }

    fileprivate func setupHeader() {
        self.vBackgroundHeader.layer.cornerRadius = 40
        self.vBackgroundHeader.clipsToBounds = true
        
        self.imgUserAvatar.layer.cornerRadius = 40
        self.imgUserAvatar.clipsToBounds = true
    
        self.lbUsername?.text = "Nguyễn Văn A"
    }

    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .checkout:
            self.slideMenuController()?.changeMainViewController(self.checkoutViewController, close: true)
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .java:
            self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
        case .setting:
            self.slideMenuController()?.changeMainViewController(self.settingViewController, close: true)
        case .nonMenu:
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        }
    }
}

extension LeftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .checkout, .main, .java, .setting, .nonMenu:
                return MenuItemTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {}
    }
}

extension LeftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .checkout, .main, .java, .setting, .nonMenu:
//                let cell = MenuItemTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: MenuItemTableViewCell.identifier)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.identifier, for: indexPath) as? MenuItemTableViewCell else { fatalError("xib doesn't exist") }

                cell.setData(self.menus[indexPath.row])
                // Highlighted color
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
                cell.selectedBackgroundView = myCustomSelectionColorView
                return cell
            }
        }
        return UITableViewCell()
    }
}
