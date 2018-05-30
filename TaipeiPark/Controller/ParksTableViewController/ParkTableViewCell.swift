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
    @IBOutlet weak var administrativeAreaLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
