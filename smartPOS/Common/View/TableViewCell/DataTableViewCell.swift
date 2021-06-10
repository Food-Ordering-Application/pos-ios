//
//  DataTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

struct DataTableViewCellData {
    var isSynced: Bool? = false
    var order: Order?
}

class DataTableViewCell: BaseTableViewCell {
    @IBOutlet var dataText: UILabel!
    
    @IBOutlet var lbOrderId: UILabel!
    
    @IBOutlet var lbDate: UILabel!
    
    @IBOutlet weak var icSync: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var lbTotal: UILabel!
    
    @IBOutlet weak var lbStatus: UILabel!
    
    override func awakeFromNib() {
        self.dataText?.font = UIFont.italicSystemFont(ofSize: 16)
        self.dataText?.textColor = UIColor(hex: "9E9E9E")
        
        self.bgView.layer.borderWidth = 1
        self.bgView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.bgView.layer.cornerRadius = 8
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
    }
 
    override class func height() -> CGFloat {
        return 80
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellData {
//            self.dataImage.setRandomDownloadImage(80, height: 80)
            if let isSynced = data.isSynced {
                self.icSync.isHidden = isSynced
            }
            guard  let order = data.order else { return }
            self.lbOrderId.text = order.id?.components(separatedBy: "-").first
            self.dataText.text = "Trinh"
            self.lbDate.text = order.createdAt?.toFormat("HH:mm")
            self.lbTotal.text = String(format: "%.0f",order.grandTotal ?? 0.0).currency()
            self.lbStatus.text = order.status?.rawValue.uppercased()
        }
    }
   
}
