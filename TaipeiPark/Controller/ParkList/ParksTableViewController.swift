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
    var likedParkProvider: LikedParkProvider?
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
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: ParkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParkTableViewCell.identifier)
        setUp()
    }
    
    // MARK : SetUp
    
    private func setUp() {
        
    }
    
    // TODO: move to tabbarcontroller init later
    func setupTableView() {
        tableView.prefetchDataSource = isAutoFetching ? self : nil
    }
    
    // MARK: Action
    
    @objc func likePark(_ sender: Any) {
        guard
            let tableView = tableView,
            let button = sender as? UIButton,
            let cell = button.superview?.superview?.superview as? ParkTableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else { fatalError("cell not found") }
        
        guard
            let persistenceDelegate = persistenceDelegate,
            let likedParkProvider = likedParkProvider
        else { fatalError("make sure persistenceDelegate and likedParkProvider are assigned") }
        
        let park = provider.park(at: indexPath)
        
        do {
            try persistenceDelegate.performTask(in: .main) { (context) in
                
                let isLiked = likedParkProvider.isLikedPark(id: park.id)
                if isLiked {
                    try likedParkProvider.removeLikedPark(id: park.id)
                    try context.save()
                } else {
                    try likedParkProvider.likePark(id: park.id)
                    try context.save()
                }
                
                DispatchQueue.main.sync {
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        } catch {
            
        }
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
                cell.parkImageView.image = nil
                cell.parkImageView.load(url: park.imageURL)
                
                // LikePark
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
        self.navigationController?.pushViewController(parkDetailViewController, animated: true)
    }
    
    // MARK: ParkProviderDelegate
    
    func didFetch(by provider: ParkProvider) {
        state = .ready
    }
    
    func didFail(with error: Error, by provider: ParkProvider) {
        print("error: \(error)")
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
