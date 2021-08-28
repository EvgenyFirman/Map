//
//  ViewController.swift
//  Map
//
//  Created by Евгений Фирман on 27.08.2021.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

class ViewController: UIViewController {
    
    private var map = MKMapView()
    
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 2000
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeMap()
        
        checkLocationServices()
        
    }
    
// MARK: - ViewDidLayoutSubviews Function
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        map.frame = view.bounds
    }
    
    
    
// MARK: - Initialize map view
    private func initializeMap() {
        
        view.addSubview(map)
        
    }
    
// MARK: - Setup Location Manager
    func setUpLocationManager() {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
// MARK: - Check location services
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            setUpLocationManager()
            checkLocationManagerAutorization()
        } else {

        }
        
    }
    
// MARK: - Allign View on Users Location
    
    func centerViewOnUsersLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            map.setRegion(region, animated: true)
        }
    }

// MARK: - Check Location Manager Autorization Function
    func checkLocationManagerAutorization() {
        
        switch locationManager.authorizationStatus {
        
        case .authorizedWhenInUse:
            
            map.showsUserLocation = true
            
            centerViewOnUsersLocation()
    
            break
        case .denied:
         
            
            break
        case .notDetermined:
           
            
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            
            
            break
        case .authorizedAlways:
            
            break
        }
    }
}


// MARK: - Extension View Controller
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}

