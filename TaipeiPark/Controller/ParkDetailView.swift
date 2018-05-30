//
//  ParkDetailView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/30.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkDetailView: UIView {
    
    class var identifier: String { return String(describing: self) }
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkTypeLabel: UILabel!
    @IBOutlet weak var administrativeAreaLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var facilitiesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = .yellow
    }
}

extension ParkDetailView {
    func creat() -> ParkDetailView {
        return UIView.load(nibName: ParkDetailView.identifier) as! ParkDetailView
    }
}

