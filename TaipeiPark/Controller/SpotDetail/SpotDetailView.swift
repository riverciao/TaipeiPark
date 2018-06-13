//
//  SpotDetailView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/5.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class SpotDetailView: UIView {
    
    // MARK: Property
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    lazy var spotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var parkNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Park Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var spotNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Spot Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var openTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Open Time"
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
    
    // MARK: Init
    
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
        self.backgroundColor = .backgroundColor
        self.addSubview(scrollView)
        scrollView.allConstraints(equalTo: self)        
        scrollView.addSubview(spotImageView)
        spotImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        spotImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        spotImageView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.6).isActive = true
        spotImageView.heightAnchor.constraint(equalToConstant: self.bounds.width * 0.6).isActive = true
        
        setupLabelsLayout([
            spotNameLabel,
            parkNameLabel,
            openTimeLabel,
            introductionLabel
            ])
        
    }
    
    private func setupLabelsLayout(_ labels: [UILabel]) {
        for i in labels.indices {
            scrollView.addSubview(labels[i])
            labels[i].centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            labels[i].widthAnchor.constraint(equalToConstant: self.bounds.width * 0.9).isActive = true
            if i == 0 {
                labels[i].topAnchor.constraint(equalTo: spotImageView.bottomAnchor, constant: 8).isActive = true
            } else {
                labels[i].topAnchor.constraint(equalTo: labels[i-1].bottomAnchor, constant: 4).isActive = true
            }
            if i == labels.indices.last {
                labels[i].bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
            }
        }
    }
}
