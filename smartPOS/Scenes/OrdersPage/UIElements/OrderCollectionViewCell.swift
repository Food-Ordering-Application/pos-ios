//
//  OrderCollectionViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 15/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import SwiftDate
import UIKit
class OrderCollectionViewCell: UICollectionViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var lbOrderID: UILabel!
    @IBOutlet var lbStatus: PaddingLabel!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbTimeRemaining: UILabel!
    @IBOutlet var lbTotalQuantity: UILabel!
    @IBOutlet var lbDistance: UILabel!
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var lbTotal: UILabel!

    var timer: Timer?
    var totalTime = 60

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupStyle()
    }

    lazy var top: NSLayoutConstraint = self.viewBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.viewBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.viewBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.viewBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)

    fileprivate func setupStyle() {
        viewBackground.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        viewBackground.layer.shadowRadius = 4
        viewBackground.layer.shadowOffset = .zero
        viewBackground.layer.shadowOpacity = 0.4
        viewBackground.layer.shouldRasterize = true

        viewBackground.layer.cornerRadius = 8
        viewBackground.backgroundColor = .white
        top.constant = 5
        left.constant = 5
        bottom.constant = -5
        right.constant = -5

        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([top, left, bottom, right])

        clipsToBounds = true
    }

    func setCell(_ data: Order?) {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        if let order = data {
            lbOrderID?.text = order.id?.components(separatedBy: "-").first?.uppercased()
//            lbStatus?.text = order.status.map { $0.rawValue }
            setuplbStatus(status: order.status)
            lbNote?.text = order.note
            lbTimeRemaining?.text = "__:__"
            startOtpTimer(time: order.delivery?.expectedDeliveryTime)
            lbTotalQuantity?.text = "\(countingQuantity(orderItems: order.orderItems))"
            lbTotal?.text = String(format: "%.0f", order.grandTotal ?? 0.0).currency()
            if let driver = order.delivery {
                let distance: Float = floor((driver.distance ?? 0) / 1000)
                lbDistance?.text = "\(distance)kms"
                lbName?.text = driver.customerName
            }
        }
    }


    private func startOtpTimer(time: Date?) {
        guard let time = time else {
            return
        }
        if time < Date() {
            return
        }
        let arangedTime = time - Date()
        guard let minuteNum = arangedTime.minute, let secondNum = arangedTime.second else {
            return
        }
        totalTime = minuteNum * 60 + secondNum
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        print(totalTime)
        lbTimeRemaining.text = timeFormatted(totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1 // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    fileprivate func countingQuantity(orderItems: [OrderItem]?) -> Int {
        guard let orderItems = orderItems else { return 0 }
        return orderItems.map { orderItem -> Int in
            orderItem.quantity ?? 0
        }.reduce(0, +)
    }

    fileprivate func setuplbStatus(status: OrderStatus?) {
        lbStatus?.text = status.map { $0.rawValue }
        var bgColor: UIColor = .systemTeal
        switch status {
        case .ordered:
            bgColor = .systemTeal
        case .confirmed:
            bgColor = .systemYellow
        case .ready, .completed:
            bgColor = .systemGreen
        case .cancelled:
            bgColor = .systemRed
        default:
            print("Unknown setuplbStatus")
        }
        lbStatus.backgroundColor = bgColor
    }
}
