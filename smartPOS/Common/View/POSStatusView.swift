//
//  POSStatusView.swift
//  smartPOS
//
//  Created by I Am Focused on 19/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

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
    @IBOutlet weak var colorStatus: UIView!
    @IBOutlet weak var lbStatus: UIStackView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var iconStatus: UIImageView!
    @IBOutlet weak var btnSync: UIButton! {
        didSet {
            self.btnSync.layer.borderWidth = 1
            self.btnSync.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.btnSync.layer.cornerRadius = 8
            self.btnSync.layer.shadowPath = UIBezierPath(rect: self.btnSync.bounds).cgPath
        }
    }
    
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
        self.containerView.backgroundColor =  UIColor(white: 1, alpha: 0)
        let syncingGif = UIImage.gifImageWithName("ic_syncing")
        iconStatus.image = syncingGif
    }
}
