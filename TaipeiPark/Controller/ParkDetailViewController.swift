//
//  ParkDetailViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkDetailViewController: UIViewController {
    
    let provider: ParkDetailProvider
    var parkDetailView: ParkDetailView?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    // MARK: Setup
    func setup() {
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        self.parkDetailView = ParkDetailView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.bounds.width, height: view.bounds.height * 0.8))
        if let parkDetailView = parkDetailView {
            self.view.addSubview(parkDetailView)
        }
    }
    
}

extension ParkDetailViewController: ParkDetailProviderDelagate {
    func didFetchFacility(by provider: ParkDetailProvider) {
        DispatchQueue.main.async {
            self.parkDetailView?.parkNameLabel.text = self.provider.facilitiesDescription
        }
    }
    
    func didFailToFacility(with error: Error, by provider: ParkDetailProvider) {
        
    }
    
    func didFetchSpot(by provider: ParkDetailProvider) {
        DispatchQueue.main.async {
//            self.parkDetailView?.descriptionLabel.text = self.provider.spot(at: IndexPath(row: 0, section: 1)).introduction
        }
    }
    
    func didFailToSpot(with error: Error, by provider: ParkDetailProvider) {
        
    }
}
