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
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .cyan
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
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
        
        self.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        scrollView.addSubview(parkImageView)
        parkImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        parkImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        parkImageView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.8).isActive = true
        parkImageView.heightAnchor.constraint(equalToConstant: self.bounds.width * 0.8).isActive = true

        setupLabelsLayout([parkNameLabel,
                           parkTypeLabel,
                           areaAddressLabel,
                           openTimeLabel,
                           facilityLabel,
                           introductionLabel])
    }
    
    private func setupLabelsLayout(_ labels: [UILabel]) {
        for i in labels.indices {
            scrollView.addSubview(labels[i])
            labels[i].rightAnchor.constraint(equalTo: parkImageView.rightAnchor).isActive = true
            labels[i].widthAnchor.constraint(equalTo: parkImageView.widthAnchor).isActive = true
            if i == 0 {
                labels[i].topAnchor.constraint(equalTo: parkImageView.bottomAnchor, constant: 8).isActive = true
            } else {
                labels[i].topAnchor.constraint(equalTo: labels[i-1].bottomAnchor, constant: 8).isActive = true
            }
            if i == labels.indices.last {
                labels[i].bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
            }
        }
    }
}

extension ParkDetailView {
    class func creat() -> ParkDetailView {
        return UIView.load(nibName: ParkDetailView.identifier) as! ParkDetailView
    }
}

