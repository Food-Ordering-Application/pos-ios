//
//  DataTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

struct DataTableViewCellData {
    var text: String
    var date: Date
    var orderId: String
}

class DataTableViewCell: BaseTableViewCell {
    @IBOutlet var dataText: UILabel!
    
    @IBOutlet var lbOrderId: UILabel!
    
    @IBOutlet var lbDate: UILabel!
    
    @IBOutlet weak var icSync: UIImageView!
    override func awakeFromNib() {
        self.dataText?.font = UIFont.italicSystemFont(ofSize: 16)
        self.dataText?.textColor = UIColor(hex: "9E9E9E")
    }
 
    override class func height() -> CGFloat {
        return 80
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellData {
//            self.dataImage.setRandomDownloadImage(80, height: 80)
            self.lbOrderId.text = data.orderId.components(separatedBy: "-").first
            
            self.dataText.text = data.text
            self.lbDate.text = data.date.toFormat("HH:mm")
        }
    }
}
