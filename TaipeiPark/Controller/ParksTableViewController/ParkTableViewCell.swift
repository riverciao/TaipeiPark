//
//  ParkTableViewCell.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/27.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = UIFont.systemFont(ofSize: 22)
        addressLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
}
