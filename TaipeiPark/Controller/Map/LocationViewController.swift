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
        let annotation = CustomPointAnnotation(pinType: .open)
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
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = customPointAnnotation
        }
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(#imageLiteral(resourceName: "icon-star").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.unlikedColor
        annotationView?.rightCalloutAccessoryView = button
        let view = UIView(frame: CGRect(x: 20, y: 0, width: 100, height: 40))
        view.backgroundColor = UIColor.barTintColor
        annotationView?.detailCalloutAccessoryView = view
        
        
        annotationView?.image = customPointAnnotation.pinType.image
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pinCoordinate = view.annotation?.coordinate {
            setRegion(centerCoordinate: pinCoordinate)
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
            
            var annotation = CustomPointAnnotation(pinType: .open)
            if !isInOpenTime {
                annotation = CustomPointAnnotation(pinType: .close)
            }
            annotation.coordinate = park.coordinate
            annotation.title = park.name
            annotation.subtitle = park.administrativeArea

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
