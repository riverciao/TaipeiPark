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
        provider.parkDetailDelegate = self
    }
}

extension ParkDetailViewController: ParkDetailProviderDelagate {
    func didFetchFacility(by provider: ParkDetailProvider) {
        DispatchQueue.main.async {
            self.nameLabel.text = self.provider.facilitiesDescription
        }
    }
    
    func didFailToFacility(with error: Error, by provider: ParkDetailProvider) {
        
    }
    
    func didFetchSpot(by provider: ParkDetailProvider) {
        DispatchQueue.main.async {
            self.introductionLabel.text = self.provider.spot(at: IndexPath(row: 0, section: 1)).introduction
        }
    }
    
    func didFailToSpot(with error: Error, by provider: ParkDetailProvider) {
        
    }
}
