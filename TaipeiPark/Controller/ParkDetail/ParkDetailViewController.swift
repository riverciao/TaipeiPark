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
    var parkDetailView: ParkDetailView!
    var currentPark: Park?
    
    // SpotsCollectionView
    var spotsCollectionView: SpotsCollectionView!
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
        addSubView()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Setup
    private func addSubView() {
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
    }
    
    private func setup() {
        self.tabBarController?.tabBar.isHidden = true
        
        if let park = currentPark {
            parkDetailView.parkNameLabel.text = park.name
            parkDetailView.parkTypeLabel.text = park.parkType
            parkDetailView.areaAddressLabel.text = park.administrativeArea + park.address
            parkDetailView.openTimeLabel.text = park.openTime
            parkDetailView.introductionLabel.text = park.introduction
            if let imageURL = park.imageURL {
                ImageCacher.loadImage(with: imageURL, into: parkDetailView.parkImageView)
            }
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
        let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didFetchSpot(by provider: ParkDetailProvider) {
        spotState = .ready
    }
    
    func didFailToSpot(with error: Error, by provider: ParkDetailProvider) {
        let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
            cell.spotName.text = spot.name
            if let imageURL = spot.imageURL {
                ImageCacher.loadImage(with: imageURL, into: cell.spotImageView)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let spot = provider.spot(at: indexPath)
        let spotDetailViewController = SpotDetailViewController(spot: spot)
        navigationItem.title = ""
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(spotDetailViewController, animated: true)
    }
}
