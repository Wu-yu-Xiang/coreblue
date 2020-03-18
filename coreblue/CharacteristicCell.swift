//
//  CharacteristicCell.swift
//  coreblue
//
//  Created by chang on 2020/3/11.
//  Copyright © 2020 chang. All rights reserved.
//

 import UIKit

 class CharacteristicCell: UITableViewCell {

     @IBOutlet weak var lbUUID: UILabel!
     @IBOutlet weak var lbName: UILabel!
     @IBOutlet weak var lbProp: UILabel!
     @IBOutlet weak var lbValue: UILabel!
     @IBOutlet weak var lbPropHex: UILabel!
     override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
     
 }
