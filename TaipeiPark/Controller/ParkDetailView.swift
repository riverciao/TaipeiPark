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

    
//    @IBOutlet var contentView: UIView!
//    @IBOutlet weak var parkImageView: UIImageView!
//    @IBOutlet weak var parkNameLabel: UILabel!
//    @IBOutlet weak var typeLabel: UILabel!
//    @IBOutlet weak var adminisrativeAreaLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var openTimeLabel: UILabel!
//    @IBOutlet weak var facilitiesLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    override func awakeFromNib() {
//        self.backgroundColor = .yellow
//    }
    
    func commonInit() {
        
        self.backgroundColor = .blue
//        Bundle.main.loadNibNamed(ParkDetailView.identifier, owner: self)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension ParkDetailView {
    class func creat() -> ParkDetailView {
        return UIView.load(nibName: ParkDetailView.identifier) as! ParkDetailView
    }
}

