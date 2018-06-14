//
//  ParksTableViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/27.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParksTableViewController: UITableViewController, ParkProviderDelegate {
    
    // MARK: State
    
    enum State {
        case preparing, ready
    }
    
    // MARK: Property
    
    var provider: ParkProvider
    var likedParkProvider: LikedParkProvider? {
        didSet {
            likedParkProvider?.likedParkdelegate = self
        }
    }
    var persistenceDelegate: PersistenceDelegate?
    var state: State {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let numberOfFetchingRows = 15
    
    var isAutoFetching = true {
        didSet {
            tableView?.prefetchDataSource = isAutoFetching ? self : nil
        }
    }
    
    // MARK: Init
    
    init(provider: ParkProvider) {
        self.provider = provider
        self.state = provider.hasMoreParks ? .preparing : .ready
        super.init(style: .plain)
        self.provider.delegate = self
        tableView.prefetchDataSource = isAutoFetching ? self : nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ParkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParkTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Reload data model
        switch provider {
        case is LikedParkLocalProvider: //is tabBarType .favorite controller
            provider.fetch()
        case is ParkAPIProvider: //is tabBarType .list controller
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default: break
        }
    }
    
    // MARK: Action
    
    @objc func likePark(_ sender: UIButton) {
        guard
            let tableView = tableView,
            let cell = sender.superview?.superview as? ParkTableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else { return }
        
        guard
            let persistenceDelegate = persistenceDelegate,
            let likedParkProvider = likedParkProvider
        else { return }
        
        let park = provider.park(at: indexPath)
        
        do {
            try persistenceDelegate.performTask(in: .main) { (context) in
                
                let isLiked = likedParkProvider.isLikedPark(id: park.id)
                if isLiked {
                    try likedParkProvider.removeLikedPark(id: park.id)
                    try context.save()
                } else {
                    try likedParkProvider.likePark(park)
                    try context.save()
                }
                
                // MARK: Update UI
                switch self.provider {
                case is LikedParkLocalProvider:
                    self.provider.fetch()
                case is ParkAPIProvider:
                    tableView.reloadRows(at: [indexPath], with: .none)
                default: break
                }
            }
        } catch {
            let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func goToMap(_ sender: UIButton) {
        guard
            let tabBarController = tabBarController,
            let locationViewController = tabBarController.visibleViewController(of: .map) as? LocationViewController
        else { return }
        
        // find index of park
        guard
            let cell = sender.superview?.superview as? ParkTableViewCell,
            let indexPath = tableView?.indexPath(for: cell)
        else { return }
        
        let park = provider.park(at: indexPath)
        tabBarController.selectedIndex = tabBarController.tabBarIndex(of: .map)
        locationViewController.centerCoordinate = park.coordinate
        locationViewController.selectedPark = park
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .preparing:
            return numberOfFetchingRows
        case .ready:
            if provider.hasMoreParks && isAutoFetching {
                return provider.numberOfParks + numberOfFetchingRows
            } else {
                return provider.numberOfParks
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParkTableViewCell.identifier, for: indexPath) as! ParkTableViewCell
        switch state {
        case .preparing:
            cell.contentView.backgroundColor = .gray
        case .ready:
            let isFetched = provider.numberOfParks > indexPath.row
            if isFetched {
                cell.contentView.backgroundColor = .clear
                let park = provider.park(at: indexPath)
                cell.nameLabel.text = park.name
                cell.administrativeAreaLabel.text = park.administrativeArea
                cell.introductionLabel.text = park.introduction
                if let imageURL = park.imageURL {
                    ImageCacher.loadImage(with: imageURL, into: cell.parkImageView)
                }

                cell.mapButton.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
                
                // MARK: LikedPark
                cell.isLiked = likedParkProvider?.isLikedPark(id: park.id) ?? false
                cell.likeButton.addTarget(self, action: #selector(likePark), for: .touchUpInside)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentPark = self.provider.park(at: indexPath)
        
        let client = APIClient()
        let provider = ParkDetailAPIProvider(client: client)
        let parkDetailViewController = ParkDetailViewController(provider: provider)
        provider.fetchFacility(by: currentPark.name)
        provider.fetchSpot(by: currentPark.name)
        parkDetailViewController.currentPark = currentPark
        
        navigationItem.title = ""
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(parkDetailViewController, animated: true)
    }
    
    // MARK: ParkProviderDelegate
    
    func didFetch(by provider: ParkProvider) {
        state = .ready
    }
    
    func didFail(with error: Error, by provider: ParkProvider) {
        let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: LikedParkLocalProviderDelegate

extension ParksTableViewController: LikedParkLocalProviderDelegate {
    func didFail(with error: Error, by provider: LikedParkProvider) {
        let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ParksTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        switch state {
        case .preparing:
            break
        case .ready:
            if !provider.hasMoreParks { return }
            guard let indexPath = indexPaths.last else { return }
            if provider.numberOfParks > indexPath.row { return }
            provider.fetch()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
}
