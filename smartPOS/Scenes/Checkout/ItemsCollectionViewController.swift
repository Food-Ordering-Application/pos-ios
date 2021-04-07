//
//  ItemsCollectionViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import BouncyLayout
import UIKit

class ItemsCollectionViewController: UIViewController {
    let numberOfItems = 50
    var randomCellStyle: CellStyle { return arc4random_uniform(10) % 2 == 0 ? .blue : .gray }
    
    lazy var style: [CellStyle] = { (0..<self.numberOfItems).map { _ in self.randomCellStyle } }()
//    lazy var style: [CellStyle] = { (0..<self.numberOfItems).map { _ in .blue } }()
//    lazy var topOffset: [CGFloat] = { (0..<self.numberOfItems).map { _ in CGFloat(arc4random_uniform(250)) } }()
    lazy var topOffset: [CGFloat] = { (0..<self.numberOfItems).map { _ in CGFloat(200) } }()
    
    lazy var sizes: [CGSize] = {
        (0..<self.numberOfItems).map { _ in
            return  CGSize(width: floor((UIScreen.main.bounds.width - (5 * 10)) / 4), height: floor((UIScreen.main.bounds.width - (5 * 10)) / 7))
//            return  CGSize(width: 120, height: 60)
        }
    }()
    
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
        view.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        
        return view
    }()
    
    func backgroundColor() -> UIColor {
//        return UIColor(red: 0 / 255, green: 153 / 255, blue: 202 / 255, alpha: 1)
        return UIColor.white.withAlphaComponent(0.98)
    }
    
    convenience init( ) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
}

extension ItemsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.setCell(style: style[indexPath.row])
    }
}

extension ItemsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

