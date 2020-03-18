//
//  Peripheral.swift
//  coreblue
//
//  Created by chang on 2020/3/11.
//  Copyright © 2020 chang. All rights reserved.
//


import UIKit

class PeripheralCell: UITableViewCell {

    @IBOutlet weak var lbUUID: UILabel!
    @IBOutlet weak var lbRSSI: UILabel!
    @IBOutlet weak var lbConntable: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
