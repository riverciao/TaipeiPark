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
    
    var provider: ParkProvider! {
        didSet { provider.delegate = self }
    }
    var state: State {
        didSet {
            tableView.reloadData()
        }
    }
    let numberOfFetchingRows = 15
    
    var isAutoFetching = true {
        didSet {
            tableView?.prefetchDataSource = isAutoFetching ? self : nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Test
        
        let client = APIClient()
        let provider = ParkDetailAPIProvider(client: client)
        provider.fetchSpot(by: "二二八和平公園")
        
        tableView.register(UINib(nibName: ParkTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParkTableViewCell.identifier)
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
    
    // move to tabbarcontroller init later
    func setupTableView() {
        tableView.prefetchDataSource = isAutoFetching ? self : nil
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
                cell.addressLabel.text = park.address
            }
        }
        return cell
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
