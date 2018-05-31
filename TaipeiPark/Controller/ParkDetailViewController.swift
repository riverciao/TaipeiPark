//
//  ParkDetailViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkDetailViewController: UIViewController {
    
    // MARK: State
    enum State {
        case preparing, ready
    }
    
    // MARK: Property
    let provider: ParkDetailProvider
    
    // ParkDetailView
    var parkDetailView: ParkDetailView?
    var currentPark: Park?
    
    // SpotsCollectionView
    var spotsCollectionView: SpotsCollectionView?
    var spotState: State {
        didSet {
            DispatchQueue.main.async {
                self.spotsCollectionView?.reloadData()
            }
        }
    }
    
    // MARK: Init
    
    init(provider: ParkDetailProvider) {
        self.provider = provider
        self.spotState = provider.isSpotsFetched ? .ready : .preparing
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
        self.tabBarController?.tabBar.isHidden = true
        
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let spotsCollectionViewHeight = SpotsCollectionView.viewHeight(with: view.bounds.width)
        
        // MARK: SpotsCollectionView
        let collectionViewFrame = CGRect(x: 0, y: view.bounds.height - spotsCollectionViewHeight, width: view.bounds.width, height: spotsCollectionViewHeight)
        let layout = UICollectionViewFlowLayout()
        self.spotsCollectionView = SpotsCollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        if let spotsCollectionView = spotsCollectionView {
            spotsCollectionView.delegate = self
            spotsCollectionView.dataSource = self
            self.view.addSubview(spotsCollectionView)
        }
        
        // MARK: ParkDetailView
        let parkDetailViewHeight = view.bounds.height - navigationBarHeight - spotsCollectionViewHeight
        let parkDetailViewFrame = CGRect(x: 0, y: navigationBarHeight, width: view.bounds.width, height: parkDetailViewHeight)
        self.parkDetailView = ParkDetailView(frame: parkDetailViewFrame)
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
        spotState = .ready
    }
    
    func didFailToSpot(with error: Error, by provider: ParkDetailProvider) {
        
    }
}

extension ParkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfSpots
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotCollectionViewCell.identifier, for: indexPath) as! SpotCollectionViewCell
        switch spotState {
        case .preparing:
            cell.contentView.backgroundColor = .gray
        case .ready:
            let spot = provider.spot(at: indexPath)
            cell.backgroundColor = .clear
            cell.spotImageView.load(url: URL(string:spot.imageURL)!)
            cell.spotName.text = spot.name
        }
        return cell
    }
}
