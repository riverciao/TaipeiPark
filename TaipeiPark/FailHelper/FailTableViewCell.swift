//
//  FailTableViewCell.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/26.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class FailTableViewCell: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
