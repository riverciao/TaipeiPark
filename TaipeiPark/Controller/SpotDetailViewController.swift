//
//  SpotDetailViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/5.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class SpotDetailViewController: UIViewController {

    // MARK: Property
    
    let currentSpot: Spot
    var spotDetailView: SpotDetailView?
    
    // MARK: Init
    
    init(spot: Spot) {
        self.currentSpot = spot
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        view.backgroundColor = .white
        spotDetailView = SpotDetailView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        if let spotDetailView = spotDetailView {
            view.addSubview(spotDetailView)
        }
        
        if let imageURL = currentSpot.imageURL {
            spotDetailView?.spotImageView.load(url: imageURL)
        }
        spotDetailView?.parkNameLabel.text = currentSpot.parkName
        spotDetailView?.spotNameLabel.text = currentSpot.name
        spotDetailView?.openTimeLabel.text = currentSpot.openTime
        spotDetailView?.introductionLabel.text = currentSpot.introduction
    }
}
