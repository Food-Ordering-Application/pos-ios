//
//  OrdersCollectionViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 15/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import BouncyLayout
import SkeletonView
import UIKit
class OrdersCollectionViewController: UIViewController {
    lazy var size = CGSize(width: floor((UIScreen.main.bounds.width - (2 * 10)) / 4), height: 140)
    
    // MARK: Setup to show list item by colection view controller using Bouncylayout

    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
    }
    
    var additionalInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    lazy var layout = BouncyLayout(style: .regular)
    
    lazy var collectionView: UICollectionView = {
        self.layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.backgroundColor()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.isSkeletonable = true
        view.register(OrderCollectionViewCell.nib, forCellWithReuseIdentifier: OrderCollectionViewCell.identifier)
        return view
    }()
    
    func backgroundColor() -> UIColor {
        return UIColor.white.withAlphaComponent(0.98)
    }
    
    var displayedOrders: [OrdersPage.DisplayedOrder] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if displayedOrders.isEmpty {
            collectionView.prepareSkeleton(completion: { _ in
                self.view.showAnimatedGradientSkeleton()
            })
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func updateData(viewModel: OrdersPage.FetchOrders.ViewModel) {
        displayedOrders = viewModel.displayedOrders
        print("updateData-\(displayedOrders)")
        collectionView.reloadData()
        print("updateData-\(displayedOrders)")
    }
}

extension OrdersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionViewCell.identifier, for: indexPath) as? OrderCollectionViewCell, !displayedOrders.isEmpty else { /* fatalError("xib doesn't exist") */ return UICollectionViewCell() }
        let order = self.displayedOrders[indexPath.row]
        
        cell.setCell(order)
    
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
        myCustomSelectionColorView.layer.cornerRadius = 8
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderToDisplay = displayedOrders[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("OrderDetail"), object: orderToDisplay.id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - Setup

private extension OrdersCollectionViewController {
    func setup() {
        title = "Items Collection"
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        collectionView.contentInset = UIEdgeInsets(top: insets.top + additionalInsets.top, left: insets.left + additionalInsets.left, bottom: insets.bottom + additionalInsets.bottom, right: insets.right + additionalInsets.right)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
        ])
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        // MARK: Setup notification to fetchOrders from OrdersPageViewController

        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFetchOrders(_:)), name: Notification.Name("FetchOrders"), object: nil)
    }
    
    @objc func didGetNotificationFetchOrders(_ notification: Notification) {
        let viewModel = notification.object as! OrdersPage.FetchOrders.ViewModel?
        displayedOrders = viewModel!.displayedOrders
        collectionView.reloadData()
        print("updateData-\(displayedOrders)")
    }
}