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
    var locationManager = CLLocationManager()
    var locationView: LocationView?
    
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
}

extension LocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Zoom to user location
        if let userLocation = locations.last {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
            locationView?.mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customPointAnnotation = annotation as? CustomPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomPointAnnotation.identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customPointAnnotation, reuseIdentifier: CustomPointAnnotation.identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = customPointAnnotation
        }
        
        annotationView?.image = customPointAnnotation.pinType.image
        
        return annotationView
    }
}

extension LocationViewController: ParkProviderDelegate {
    func didFetch(by provider: ParkProvider) {
        
        for park in provider.parks {
            
            print("OpenTime: \(park.openTime)")
            var annotation = CustomPointAnnotation(pinType: .open)
            if park.name == "二二八和平公園" {
                annotation = CustomPointAnnotation(pinType: .close)
            }
            annotation.coordinate = park.coordinate

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
