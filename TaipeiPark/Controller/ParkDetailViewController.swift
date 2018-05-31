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
    var currentPark: Park?
    
    var spotsCollectionView: UICollectionView?
    
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
        if let park = currentPark {
            self.parkDetailView?.parkNameLabel.text = park.name
            self.parkDetailView?.parkTypeLabel.text = park.parkType
            self.parkDetailView?.areaAddressLabel.text = park.administrativeArea + park.address
            self.parkDetailView?.openTimeLabel.text = park.openTime
            self.parkDetailView?.introductionLabel.text = park.introduction
            self.parkDetailView?.parkImageView.load(url: park.imageURL)
        }
    }
    
}

extension ParkDetailViewController: ParkDetailProviderDelagate {
    func didFetchFacility(by provider: ParkDetailProvider) {
        DispatchQueue.main.async {
            self.parkDetailView?.facilityLabel.text = self.provider.facilitiesDescription
        }
    }
    
    func didFailToFacility(with error: Error, by provider: ParkDetailProvider) {
        
    }
    
    func didFetchSpot(by provider: ParkDetailProvider) {
    }
    
    func didFailToSpot(with error: Error, by provider: ParkDetailProvider) {
        
    }
}

extension ParkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfSpots
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotCollectionViewCell.identifier, for: indexPath) as! SpotCollectionViewCell
        
        return cell
    }
    
    
}
