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
    
    lazy var parkNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Park Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: Setup
    
    func setUp() {
        self.backgroundColor = .white
        
        self.addSubview(parkNameLabel)
        parkNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        parkNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        parkNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
}

extension ParkDetailView {
    class func creat() -> ParkDetailView {
        return UIView.load(nibName: ParkDetailView.identifier) as! ParkDetailView
    }
}

