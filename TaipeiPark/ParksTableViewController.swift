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
    
    var provider: ParkAPIProvider?
    var state: State = .preparing {
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
        
        initController()
    }
    
    // MARK: Init
    
    // move to tabbarcontroller init later
    func initController() {
        let client = APIClient()
        self.provider = ParkAPIProvider(client: client)
        provider?.fetch()
        provider?.delegate = self
        tableView.prefetchDataSource = isAutoFetching ? self : nil
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .preparing:
            return numberOfFetchingRows
        case .ready:
            if provider!.hasMoreParks && isAutoFetching {
                return provider!.numberOfParks + numberOfFetchingRows
            } else {
                return provider!.numberOfParks
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        switch state {
        case .preparing:
            cell.contentView.backgroundColor = .gray
        case .ready:
            let isFetched = provider!.numberOfParks > indexPath.row
            if isFetched {
                cell.contentView.backgroundColor = .clear
                let park = provider!.park(at: indexPath)
                cell.textLabel?.text = park.name
                cell.detailTextLabel?.text = park.address
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
            provider?.fetch()
        }
    }
}
