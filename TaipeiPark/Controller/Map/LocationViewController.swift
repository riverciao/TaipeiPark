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
    
    var locationManager = CLLocationManager()
    var locationView: LocationView?
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupLocationManager()
    }
    
    // MARK: Setup
    
    private func setUp() {
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        locationView = LocationView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: view.frame.height - tabBarHeight - navigationBarHeight))
        if let locationView = locationView {
            view.addSubview(locationView)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Zoom to user location
        if let userLocation = locations.last {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 600, 600)
            locationView?.mapView.setRegion(viewRegion, animated: true)
        }
    }
}
