//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import SwiftEntryKit
import UIKit
import SwiftEventBus

enum LeftMenu: Int {
    case main = 0
    case checkout
    case deliveryOrder
    case setting
    case nonMenu
}

protocol LeftMenuProtocol: AnyObject {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController: UIViewController, LeftMenuProtocol {
    // MARK: Show popup new order

    private var displayMode: EKAttributes.DisplayMode {
        return PresetsDataSource.displayMode
    }

    private var attributes: EKAttributes?

//    @IBOutlet var tableView: UITableView!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var imgUserAvatar: UIView!
    @IBOutlet var vBackgroundHeader: UIView!
    @IBOutlet var lbUsername: UILabel!
    @IBOutlet var logoutBtn: UIButton! {
        didSet {
            self.logoutBtn.layer.borderWidth = 1
            self.logoutBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.4176585674, blue: 0.2058730721, alpha: 1)

            self.logoutBtn.layer.shadowPath = UIBezierPath(rect: self.logoutBtn.bounds).cgPath
            self.logoutBtn.layer.cornerRadius = 8
        }
    }

//    var menus = ["Checkout", "Đơn hàng", "Quản lý kho", "Cài đặt", "NonMenu"]
    var menus: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "shop")!, title: "Đặt hàng"),
        SideMenuModel(icon: UIImage(named: "purchase-order")!, title: "Đơn hàng"),
        SideMenuModel(icon: UIImage(named: "track-order")!, title: "Giao hàng"),
        SideMenuModel(icon: UIImage(named: "in-inventory")!, title: "Kho hàng"),
        SideMenuModel(icon: UIImage(named: "store-setting")!, title: "Cài đặt"),
    ]
    var mainViewController: UIViewController!
    var deliveryViewController: UIViewController!
    var ordersPageViewController: UIViewController!
    var settingViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationOrdersPage(_:)), name: Notification.Name("OrdersPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationOrderDetailNotification(_:)), name: Notification.Name("OrderDetailNotification"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didGetNotificationOrderDetailNotification(_ notification: Notification) {
        guard let orderId = notification.object as? String else { return }
        showOrderNotification(attributes: self.attributes!, orderId: orderId)
    }

    @objc func didGetNotificationOrdersPage(_ notification: Notification) {
        self.changeViewController(LeftMenu.deliveryOrder)
        guard let orderId = notification.object as? String else { return }
        let queue = DispatchQueue.global(qos: .background) // or some higher QOS level
        // Do somthing after 10.5 seconds
        queue.asyncAfter(deadline: .now() + 0.3) {
            // your task code here
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("OrderDetail"), object: orderId)
            }
            DispatchQueue.main.async {
                let defaultRow = IndexPath(row: 2, section: 0)
                self.tableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
            }
        }
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
        let deliveryViewController = storyboard.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        self.deliveryViewController = UINavigationController(rootViewController: deliveryViewController)

        let ordersPageViewController = storyboard.instantiateViewController(withIdentifier: "OrdersPageViewController") as! OrdersPageViewController
        self.ordersPageViewController = UINavigationController(rootViewController: ordersPageViewController)

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
        setup()
        self.setupHeader()
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
            self.slideMenuController()?.changeMainViewController(self.deliveryViewController, close: true)
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .deliveryOrder:
            self.slideMenuController()?.changeMainViewController(self.ordersPageViewController, close: true)
        case .setting:
            self.slideMenuController()?.changeMainViewController(self.settingViewController, close: true)
        case .nonMenu:
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        }
    }
    
    @IBAction func handleLogour(_ sender: Any) {
        SwiftEventBus.post("Unauthorized")
        
    } 
}

extension LeftViewController {
    private func setup() {
        self.attributes = .topToast
        self.attributes!.displayMode = self.displayMode
        self.attributes!.hapticFeedbackType = .error
        self.attributes!.displayDuration = .pi
        self.attributes!.popBehavior = .animated(animation: .translation)
        self.attributes!.entryBackground = .color(color: EKColor.white)
        self.attributes!.statusBar = .light
    }

    private func showOrderNotification(attributes: EKAttributes, orderId: String?) {
        let title = EKProperty.LabelContent(
            text: "Đơn hàng mới",
            style: .init(
                font: MainFont.medium.with(size: 16),
                color: .black,
                displayMode: self.displayMode
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: "102 Nguyễn Văn Cừ, phường 4, quận 10",
            style: .init(
                font: MainFont.light.with(size: 14),
                color: EKColor.black,
                displayMode: self.displayMode
            ),
            accessibilityIdentifier: "description"
        )
        let image = EKProperty.ImageContent(
            image: UIImage(named: "appstore")!,
            displayMode: self.displayMode,
            size: CGSize(width: 50, height: 50),
            tint: .none,
            accessibilityIdentifier: "thumbnail"
        )
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

extension LeftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .checkout, .main, .deliveryOrder, .setting, .nonMenu:
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
            case .checkout, .main, .deliveryOrder, .setting, .nonMenu:
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
