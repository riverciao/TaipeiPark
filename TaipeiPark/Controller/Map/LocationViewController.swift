//
//  LocationViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    // MARK: Property
    
    let provider: ParkProvider
    var likedParkProvider: LikedParkProvider? {
        didSet {
            likedParkProvider?.likedParkdelegate = self
        }
    }
    var persistenceDelegate: PersistenceDelegate?
    var locationManager = CLLocationManager()
    var locationView: LocationView?
    var centerLocation: CLLocation?
    
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
        addPin()
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
        locationView?.mapView.delegate = self
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
    
    // MARK: Action
    private func setRegion(centerCoordinate: CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000, 1000)
        locationView?.mapView.setRegion(viewRegion, animated: false)
    }
    
    func addPin() {
        // Add test pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.044369, longitude: 121.564943)
        self.locationView?.mapView.addAnnotation(annotation)
    }
}

extension LocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Zoom to user location
        if centerLocation == nil {
            if let userLocation = locations.last {
                centerLocation = userLocation
                setRegion(centerCoordinate: userLocation.coordinate)
            }
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customPointAnnotation = annotation as? CustomPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomPointAnnotation.identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customPointAnnotation, reuseIdentifier: CustomPointAnnotation.identifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = customPointAnnotation
        }
        
        annotationView?.image = customPointAnnotation.pinType.image
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pinCoordinate = view.annotation?.coordinate {
            setRegion(centerCoordinate: pinCoordinate)
        }
        
        guard let annotation = view.annotation as? CustomPointAnnotation else { return }
        let callOutView = CallOutView(frame: CGRect(x: 0, y: 0, width: 200, height: 130))
        view.addSubview(callOutView)
        
        callOutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.calloutOffset.x).isActive = true
        callOutView.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
        callOutView.titleLabel.text = annotation.park.name
        callOutView.subtitleLabel.text = annotation.park.administrativeArea
        callOutView.isOpened = {
            switch annotation.pinType {
            case .open: return true
            case .close: return false
            }
        }()
        callOutView.isLiked = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let callOutViews = view.subviews
        for view in callOutViews {
            view.removeFromSuperview()
        }
    }
}

extension LocationViewController: ParkProviderDelegate {
    func didFetch(by provider: ParkProvider) {
        
        for park in provider.parks {
            
            // MARK: Check if now is in park open time
            let parkOpenTime = park.openTime ?? "00:00~24:00"
            let now = Date()
            let isInOpenTime = now.isInOpenTime(parkOpenTime)
            
            var annotation = CustomPointAnnotation(pinType: .open, park: park)
            if !isInOpenTime {
                annotation = CustomPointAnnotation(pinType: .close, park: park)
            }

            DispatchQueue.main.async {
                self.locationView?.mapView.addAnnotation(annotation)
            }
            
            // Map Loading Scale
            //            let mapContainsPoint = MKMapRectContainsPoint((locationView?.mapView.visibleMapRect)!, MKMapPointForCoordinate(park.coordinate))
            //            let annotations = locationView?.mapView.annotations(in: (locationView?.mapView.visibleMapRect)!)
        }
    }
    
    func didFail(with error: Error, by provider: ParkProvider) {
        print(error)
    }
}

extension LikedParkLocalProviderDelegate: LikedParkLocalProviderDelegate {
    
}
