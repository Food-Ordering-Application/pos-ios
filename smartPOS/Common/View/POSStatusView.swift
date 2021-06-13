//
//  POSStatusView.swift
//  smartPOS
//
//  Created by I Am Focused on 19/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Schedule
import SwiftDate
import SwiftEventBus
import UIKit
struct POSStatusModel {
    var status: EStatus?
    var time: Date?
}

enum EStatus: String {
    case syncing = "Syncing"
    case synced = "Synced"
    case online = "Online"
    case offline = "Offline"
}

class POSStatusView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet var colorStatus: UIView!
    @IBOutlet var lbStatus: UILabel!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var iconStatus: UIImageView!
    @IBOutlet var btnSync: UIButton! {
        didSet {
            self.btnSync.layer.borderWidth = 1
            self.btnSync.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.btnSync.layer.cornerRadius = 8
            self.btnSync.layer.shadowPath = UIBezierPath(rect: self.btnSync.bounds).cgPath
        }
    }

    var timerTest: Timer?
    var timeToSync: Int = 0
    init(_ status: POSStatusModel?) {
        super.init(frame: .zero)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = bounds
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup() {
        fromNib()
        self.colorStatus.layer.cornerRadius = 5
        self.colorStatus.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.containerView.backgroundColor = UIColor(white: 1, alpha: 0)
        let syncingGif = UIImage.gifImageWithName("ic_syncing")
        self.iconStatus.image = syncingGif
        let posStatus = POSStatusModel(status: .synced, time: APIConfig.getLatestSync() ?? Date())
        self.updateView(posStatus: posStatus)
        SwiftEventBus.onMainThread(self, name: "POSStatusIsSyncing") { result in
            guard let isSyncing = result?.object as? Bool else { return }
            let status: EStatus = isSyncing ? .syncing : .synced
            let posStatus = POSStatusModel(status: status, time: Date())
            self.updateView(posStatus: posStatus)
        }
        SwiftEventBus.onMainThread(self, name: "UpdatePOSStatus") { result in
            let isReachable = result?.object as! Bool
            let status: EStatus = isReachable ? .online : .offline
            let posStatus = POSStatusModel(status: status, time: APIConfig.getLatestSync() ?? Date())
            self.updateView(posStatus: posStatus)
        }
        self.startTimer()
    }

    @IBAction func onSync(_ sender: Any) {
//        let posStatus = POSStatusModel(status: .syncing, time: Date())
//        self.updateView(posStatus: posStatus)
        self.onPOSSync()
    }

    @objc func updateTime() {
        self.timeToSync += 1
        let posStatus = POSStatusModel(status: .synced, time: Date())
        self.updateView(posStatus: posStatus)
        if self.timeToSync > 3 * 60 {
            self.onPOSSync()
        }
    }

    func onPOSSync() {
        guard let menuId = MenuItemsMemStore.menu?.id else { return }
        SwiftEventBus.post("POSSyncMenuItemDetail", sender: menuId)
        let posStatus = POSStatusModel(status: .syncing, time: Date())
        self.updateView(posStatus: posStatus)
        self.timeToSync = 0
    }

    func startTimer() {
        guard self.timerTest == nil else { return }
        let interval = 10.0
        self.timerTest = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(POSStatusView.updateTime), userInfo: nil, repeats: true)
    }

    func stopTimerTest() {
        self.timerTest?.invalidate()
        self.timerTest = nil
    }

    func updateView(posStatus: POSStatusModel?) {
        self.iconStatus.isHidden = true
        var timeString = "Vừa xong"
        let latestSync = APIConfig.getLatestSync()
        let from = posStatus?.time ?? Date()
        let to = latestSync ?? Date()
        let rangedTime = from - to

        if let minute = rangedTime.minute {
            switch minute {
            case 0...1:
                timeString = "Vừa xong"
            case 2...59:
                timeString = "\(minute) phút trước"
            default:
                timeString = from.toFormat("dd MMM yyyy")
            }
        }

        self.lbTime.text = timeString

        guard let status = posStatus?.status else { return }
        switch status {
        case .synced, .online:
            self.lbStatus.text = "Online"
            self.colorStatus.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        case .offline:
            self.lbStatus.text = "Offline"
            self.colorStatus.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

        case .syncing:
            self.lbStatus.text = "Đang đồng bộ"
            self.colorStatus.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.iconStatus.isHidden = false
        }
    }
}
