//
//  ParkDetailViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkDetailViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    let provider: ParkDetailProvider
    
    // MARK: Init
    
    init(provider: ParkDetailProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
