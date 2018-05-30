//
//  ParkDetailView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/30.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkDetailView: UIView {
    
    // MARK: Property
    
    class var identifier: String { return String(describing: self) }
    lazy var parkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var parkNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Park Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var parkTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Park Type"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var areaAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Area Address"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var openTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Open Time"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var facilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Facility"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Introduction"
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
    
    private func setUp() {
        self.backgroundColor = .white
        
        self.addSubview(parkImageView)
        parkImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        parkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        parkImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        parkImageView.heightAnchor.constraint(equalToConstant: self.bounds.width * 0.8).isActive = true
        
        self.addSubview(parkNameLabel)
        parkNameLabel.topAnchor.constraint(equalTo: parkImageView.bottomAnchor, constant: 8).isActive = true
        parkNameLabel.rightAnchor.constraint(equalTo: parkImageView.rightAnchor).isActive = true
        parkNameLabel.widthAnchor.constraint(equalTo: parkImageView.widthAnchor).isActive = true
        
        self.addSubview(parkTypeLabel)
        self.addSubview(areaAddressLabel)
        self.addSubview(openTimeLabel)
        self.addSubview(facilityLabel)
        self.addSubview(introductionLabel)

        
        setupLabelLayout(for: parkTypeLabel, previousLabel: parkNameLabel)
        setupLabelLayout(for: areaAddressLabel, previousLabel: parkTypeLabel)
        setupLabelLayout(for: openTimeLabel, previousLabel: areaAddressLabel)
        setupLabelLayout(for: facilityLabel, previousLabel: openTimeLabel)
        setupLabelLayout(for: introductionLabel, previousLabel: facilityLabel)
        
    }
    
    private func setupLabelLayout(for label: UILabel, previousLabel: UILabel) {
        label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: parkImageView.rightAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: parkImageView.widthAnchor).isActive = true
    }
}

extension ParkDetailView {
    class func creat() -> ParkDetailView {
        return UIView.load(nibName: ParkDetailView.identifier) as! ParkDetailView
    }
}

