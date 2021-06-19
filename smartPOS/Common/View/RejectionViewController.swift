//
//  RejectionViewController.swift
//  smartPOS
//
//  Created by IAmFocused on 6/11/21.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import UIKit
struct RejectionDataModel {
    var note: String?
    var orderItemIds: [String]?
}
protocol RejectionViewControllerDelegate {
    func rejectionData(data: RejectionDataModel)
}
class RejectionViewController: UIViewController {
    static func makeRejectionVC(orderItems: [OrderItem]) -> RejectionViewController {
          let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RejectionViewController") as! RejectionViewController
          
          newViewController.orderItems = orderItems
          
          return newViewController
      }
    @IBOutlet var tvNote: UITextView! {
        didSet {
            // Round the corners.
            tvNote.layer.masksToBounds = true

            // Set the size of the roundness.
            tvNote.layer.cornerRadius = 8.0

            // Set the thickness of the border.
            tvNote.layer.borderWidth = 1

            // Set the border color to black.
            tvNote.layer.borderColor = UIColor.systemGray.cgColor

            // Set the font.
            tvNote.font = UIFont.systemFont(ofSize: 16.0)

            // Set font color.
            tvNote.textColor = UIColor.black

            // Set left justified.
            tvNote.textAlignment = NSTextAlignment.left

            // Automatically detect links, dates, etc. and convert them to links.
            tvNote.dataDetectorTypes = UIDataDetectorTypes.all

            // Set shadow darkness.
            tvNote.layer.shadowOpacity = 0.5

            // Make text uneditable.
            tvNote.isEditable = true
        }
    }

    @IBOutlet weak var btnReadyReject: UIButton! {
        didSet {
            btnReadyReject.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: RejectionViewControllerDelegate?
    
    var orderItems: [OrderItem] = []
    
    var selectedIndexPaths = [IndexPath]()
    
    var orderItemsSelection: [OrderItem] = []
    
    
    // MARK: Object lifecycle
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        setupTableView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupTableView()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load Rejection View Controller")
        setupTableView()
    }
    fileprivate func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.allowsMultipleSelection = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        // Register TableView Cell
        self.tableView.register(RadioTableViewCell.nib, forCellReuseIdentifier: RadioTableViewCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Update TableView with the data
        self.tableView.reloadData()
    }
  
    
    @IBAction func readyRejectHandler(_ sender: Any) {
        print("iam ready reject")

        var orderItemIds: [String] = []
        for indexPath in selectedIndexPaths {
            if let orderItemId = self.orderItems[indexPath.row].id {
                orderItemIds.append(orderItemId)
            }
        }
        let data = RejectionDataModel(note: tvNote.text, orderItemIds: orderItemIds)
        print(data)
        self.presentingViewController!.dismiss(animated: true, completion: nil)
        self.delegate?.rejectionData(data: data)
    }
}

// MARK: Setting for Table View

extension RejectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndexPathAtCurrentSection = self.selectedIndexPaths.filter { $0.section == indexPath.section }
        for indexPath in selectedIndexPathAtCurrentSection {
            tableView.deselectRow(at: indexPath, animated: true)
            if let indexOf = selectedIndexPaths.firstIndex(of: indexPath) {
                self.selectedIndexPaths.remove(at: indexOf)
            }
        }
        self.selectedIndexPaths.append(indexPath)
    }
    
    // On DeSelection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            self.selectedIndexPaths.remove(at: index)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        self.tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        return indexPath
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableViewCell.identifier, for: indexPath) as? RadioTableViewCell else { fatalError("xib doesn't exist") }
        cell.selectionStyle = .none
        cell.setData(self.orderItems[indexPath.row])
        return cell
    }

}
