//
//  NavigatoinController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    // MARK: Property
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        let title = NSLocalizedString("Taipei Park", comment: "")
        label.text = title
        label.textColor = .barTintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: Setup
    
    private func setUp() {
        navigationBar.barTintColor = .barColor
        navigationBar.tintColor = .barTintColor
        
        // MARK: titleLabel
        navigationBar.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
    }
}
