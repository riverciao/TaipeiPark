//
//  LocationViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Property
    
    let provider: ParkProvider
    var locationManager = CLLocationManager()
    var locationView: LocationView? {
        didSet {
            print("locationViewDidSet")
        }
    }
    
    // MARK: Init
    
    init(provider: ParkProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        provider.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupLocationManager()
        addPins()
    }
    
    // MARK: Setup
    
    private func setUp() {
        
        // MARK: LocationView
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        locationView = LocationView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: view.frame.height - tabBarHeight - navigationBarHeight))
        if let locationView = locationView {
            view.addSubview(locationView)
        }
        provider.fetch()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func addPins() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.042622, longitude: 121.565149)
        locationView?.mapView.addAnnotation(annotation)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Zoom to user location
        if let userLocation = locations.last {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 600, 600)
            locationView?.mapView.setRegion(viewRegion, animated: false)
        }
    }
}

extension LocationViewController: ParkProviderDelegate {
    func didFetch(by provider: ParkProvider) {
        print("didFetch")
        
    }
    
    func didFail(with error: Error, by provider: ParkProvider) {
        print(error)
    }
}
